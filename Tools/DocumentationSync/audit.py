#!/usr/bin/env python3
"""Reconcile GitBook's explicit OpenAPI inclusions with pinned bunq/doc Swagger."""

import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[2]
REFS = ROOT / "References"
PAGES = REFS / "upstream/gitbook/pages"
TAGS = re.compile(r"{%\s*openapi\b(?P<attrs>.*?)%}", re.DOTALL | re.IGNORECASE)
ATTRS = re.compile(r'''\b([\w-]+)\s*=\s*(["'])(.*?)\2''', re.DOTALL)
PARAMETERS = re.compile(r"\{[^{}]+\}")
METHODS = {"get", "post", "put", "patch", "delete", "head", "options", "trace"}


def classify_spec_source(source):
    source = source or ""
    if "raw.githubusercontent.com/bunq/doc/" in source and "swagger.json" in source:
        return "bunq_doc_swagger"
    if "/files/" in source and (source.startswith("/files/") or "doc.bunq.com" in source):
        return "gitbook_attachment_unverified"
    return "unrecognized"


def key(method, path):
    path = re.sub(r"^/v1(?=/)", "", path.rstrip("/"))
    return method.upper(), PARAMETERS.sub("{}", path) or "/"


def extract_directives(text, filename):
    results = []
    for match in TAGS.finditer(text):
        attrs = {name.lower(): value for name, _, value in ATTRS.findall(match["attrs"])}
        method = attrs.get("method", "").lower()
        path = attrs.get("path", "")
        if method not in METHODS or not path.startswith("/"):
            results.append({"source": filename, "line": text.count("\n", 0, match.start()) + 1, "attributes": attrs, "issue": "invalid_directive"})
            continue
        results.append({
            "source": filename,
            "line": text.count("\n", 0, match.start()) + 1,
            "method": method.upper(),
            "path": path,
            "spec_source": attrs.get("src"),
        })
    return results


def audit():
    structured = json.loads((REFS / "inventories/operations.json").read_text())
    expected = {}
    for item in structured:
        expected.setdefault(key(item["method"], item["path"]), []).append(item["path"])
    inclusions = []
    pages = sorted(PAGES.rglob("*.md"))
    for page in pages:
        filename = page.relative_to(ROOT).as_posix()
        inclusions.extend(extract_directives(page.read_text(encoding="utf-8"), filename))

    matched = []
    missing = []
    invalid = []
    referenced = set()
    unknown_sources = []
    attachments = []
    for item in inclusions:
        if "issue" in item:
            invalid.append(item)
            continue
        reference = key(item["method"], item["path"])
        referenced.add(reference)
        provenance = classify_spec_source(item["spec_source"])
        if provenance == "gitbook_attachment_unverified":
            attachments.append(item)
        elif provenance == "unrecognized":
            unknown_sources.append(item)
        if reference in expected:
            matched.append(item)
        else:
            missing.append(item)

    unreferenced = [
        {"method": method, "normalized_path": path, "swagger_paths": expected[method, path]}
        for method, path in sorted(expected.keys() - referenced)
    ]
    output = {
        "source_method": "gitbook_openapi_directive",
        "counts": {
            "gitbook_pages": len(pages),
            "pages_with_directives": len({item["source"] for item in inclusions}),
            "openapi_directives": len(inclusions),
            "matched_directives": len(matched),
            "directives_not_in_swagger": len(missing),
            "invalid_directives": len(invalid),
            "gitbook_attachment_directives_unverified": len(attachments),
            "unknown_spec_sources": len(unknown_sources),
            "unique_referenced_operations": len(referenced),
            "swagger_operations": len(structured),
            "swagger_without_directive": len(unreferenced),
        },
        "not_in_swagger": missing,
        "invalid": invalid,
        "unknown_sources": unknown_sources,
        "gitbook_attachments_unverified": attachments,
        "without_directive": unreferenced,
        "matched": matched,
        "interpretation": "A matching method/path does not prove specification-content equivalence. GitBook attachments are unverified provenance, not missing endpoints.",
    }
    inventory = REFS / "inventories"
    (inventory / "reconciliation.json").write_text(json.dumps(output, indent=4, sort_keys=True) + "\n")
    lines = [
        "# Bunq GitBook OpenAPI reconciliation", "",
        "Parses `{% openapi ... %}` directives, not incidental prose mentions.", "",
    ]
    lines.extend(f"- {name.replace('_', ' ')}: {count}" for name, count in output["counts"].items())
    lines.extend(["", "## Directives absent from pinned Swagger", ""])
    lines.extend(f"- `{item['method']} {item['path']}` ({item['source']}:{item['line']})" for item in missing)
    if not missing:
        lines.append("None.")
    lines.extend(["", "## GitBook attachments not independently verified", ""])
    lines.extend(f"- `{item['spec_source']}`: {item['method']} {item['path']} ({item['source']}:{item['line']})" for item in attachments)
    if not attachments:
        lines.append("None.")
    lines.extend(["", "## Invalid directives and unfamiliar sources", ""])
    lines.extend(f"- {item['source']}:{item['line']}" for item in invalid + unknown_sources)
    if not invalid and not unknown_sources:
        lines.append("None.")
    lines.extend(["", "## Scope", "", "Swagger operations without a GitBook directive are not necessarily absent or unsupported. Attachment contents have not been independently verified. See reconciliation.json for detailed evidence.", ""])
    (inventory / "reconciliation.md").write_text("\n".join(lines))
    for name, count in output["counts"].items():
        print(f"{name}: {count}")
    return 2 if missing or invalid or unknown_sources else 0


if __name__ == "__main__":
    raise SystemExit(audit())
