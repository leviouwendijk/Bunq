#!/usr/bin/env python3

import concurrent.futures
import datetime
import hashlib
import json
import os
import pathlib
import re
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.parse
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parents[2]
DOCS = "https://doc.bunq.com"
GIT = "https://github.com/bunq/doc.git"

FILES = (
    "swagger.json",
    "generated.json",
    "base.json",
    "CHANGELOG.md",
    "DESCRIPTION.md",
    "README.md",
)

METHODS = {
    "get", "post", "put", "patch",
    "delete", "head", "options", "trace",
}


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def write(relative, data):
    target = ROOT / relative

    if not target.resolve().is_relative_to(ROOT.resolve()):
        raise ValueError(f"Outside workspace: {relative}")

    target.parent.mkdir(parents=True, exist_ok=True)

    if not target.parent.resolve().is_relative_to(ROOT.resolve()):
        raise ValueError(f"Unsafe target: {relative}")

    with tempfile.NamedTemporaryFile(
        dir=target.parent,
        delete=False,
    ) as handle:
        temporary = pathlib.Path(handle.name)

        try:
            handle.write(data)
        except BaseException:
            temporary.unlink(missing_ok=True)
            raise

    os.replace(temporary, target)


def write_json(relative, value):
    data = json.dumps(
        value,
        indent=4,
        ensure_ascii=False,
        sort_keys=True,
    ) + "\n"

    write(relative, data.encode())


def fetch(url, expected_host):
    for attempt in range(3):
        try:
            request = urllib.request.Request(
                url,
                headers={
                    "User-Agent": "BunqSDKReferenceSync/1.0",
                    "Accept": "text/markdown, text/plain, application/json;q=0.8, */*;q=0.2",
                },
            )

            with urllib.request.urlopen(
                request,
                timeout=30,
            ) as response:
                actual = urllib.parse.urlsplit(
                    response.geturl()
                )

                if (
                    actual.scheme != "https"
                    or actual.hostname != expected_host
                ):
                    raise ValueError(
                        f"Unexpected redirect: {response.geturl()}"
                    )

                data = response.read(64 * 1024 * 1024 + 1)

                if not data or len(data) > 64 * 1024 * 1024:
                    raise ValueError(
                        "Empty or oversized response"
                    )

                if re.match(
                    br"\s*(?:<!doctype\s+html|<html\b)",
                    data[:256],
                    re.I,
                ):
                    raise ValueError(
                        "HTML returned instead of documentation"
                    )

                return data

        except (
            urllib.error.URLError,
            TimeoutError,
            ValueError,
            OSError,
        ) as error:
            if attempt == 2:
                raise RuntimeError(
                    f"{type(error).__name__}: {error}"
                ) from error

            time.sleep(0.75 * (attempt + 1))


def markdown_pages(index):
    text = index.decode("utf-8")

    candidates = re.findall(
        r"\]\(\s*(?:<([^>]+)>|([^\s)]+))",
        text,
    )

    urls = set()

    for wrapped, plain in candidates:
        link = (wrapped or plain).strip()

        parsed = urllib.parse.urlsplit(
            urllib.parse.urljoin(DOCS + "/", link)
        )

        if (
            parsed.scheme != "https"
            or parsed.hostname != "doc.bunq.com"
        ):
            continue

        path = parsed.path.rstrip("/")

        if not path or path == "/llms.txt":
            continue

        if pathlib.PurePosixPath(path).suffix.lower() in {
            ".json", ".txt", ".png", ".svg",
            ".pdf", ".xml", ".yaml", ".yml",
        }:
            continue

        if not path.endswith(".md"):
            path += ".md"

        segments = path.lstrip("/").split("/")
        decoded = [
            urllib.parse.unquote(item)
            for item in segments
        ]

        if any(
            item in {"", ".", ".."}
            or "/" in item
            or "\\" in item
            for item in decoded
        ):
            continue

        urls.add(
            urllib.parse.urlunsplit(
                ("https", "doc.bunq.com", path, "", "")
            )
        )

    return sorted(urls)


def github_revision():
    result = subprocess.run(
        ["git", "ls-remote", "--symref", GIT, "HEAD"],
        check=True,
        capture_output=True,
        text=True,
        timeout=45,
    )

    branch = None
    revision = None

    for line in result.stdout.splitlines():
        if (
            line.startswith("ref: refs/heads/")
            and line.endswith("\tHEAD")
        ):
            branch = line.split("\t", 1)[0].removeprefix(
                "ref: refs/heads/"
            )

        elif line.endswith("\tHEAD"):
            candidate = line.split("\t", 1)[0]

            if re.fullmatch(r"[0-9a-f]{40,64}", candidate):
                revision = candidate

    if not revision:
        raise ValueError(
            "Could not resolve bunq/doc HEAD"
        )

    return {
        "branch": branch,
        "revision": revision,
    }


def store(url, relative, kind, revision=None):
    time.sleep(0.3)

    entry = {
        "url": url,
        "path": relative,
        "kind": kind,
        "status": "failed",
    }

    if revision:
        entry["revision"] = revision

    try:
        content = fetch(
            url,
            urllib.parse.urlsplit(url).hostname,
        )

        write(relative, content)

        entry.update(
            status="ok",
            bytes=len(content),
            sha256=sha256(content),
        )

    except Exception as error:
        entry["error"] = str(error)

    return entry


def refs(document):
    found = []
    stack = [document]

    while stack:
        node = stack.pop()

        if isinstance(node, dict):
            if isinstance(node.get("$ref"), str):
                found.append(node["$ref"])

            stack.extend(node.values())

        elif isinstance(node, list):
            stack.extend(node)

    return sorted(set(found))


def inspect_spec(document, source):
    if (
        not isinstance(document, dict)
        or not isinstance(document.get("paths"), dict)
        or not ("swagger" in document or "openapi" in document)
    ):
        return None

    operations = []

    for path, methods in sorted(document["paths"].items()):
        if not isinstance(methods, dict):
            continue

        for method, operation in sorted(methods.items()):
            if (
                method.lower() not in METHODS
                or not isinstance(operation, dict)
            ):
                continue

            responses = operation.get("responses") or {}

            operations.append({
                "source": source,
                "method": method.upper(),
                "path": path,
                "operation_id": operation.get("operationId"),
                "deprecated": operation.get("deprecated", False),
                "responses": sorted(map(str, responses.keys())),
                "security": operation.get(
                    "security",
                    document.get("security"),
                ),
            })

    defined = document.get("definitions", {})

    if isinstance(document.get("components"), dict):
        defined = document["components"].get(
            "schemas",
            defined,
        )

    schemas = []

    if isinstance(defined, dict):
        for name, value in sorted(defined.items()):
            if not isinstance(value, dict):
                continue

            schemas.append({
                "source": source,
                "name": name,
                "properties": sorted(
                    value.get("properties") or {}
                ),
                "required": sorted(
                    value.get("required") or []
                ),
            })

    unresolved = []
    external = []

    for reference in refs(document):
        if not reference.startswith("#/"):
            external.append(reference)
            continue

        current = document

        try:
            for token in reference[2:].split("/"):
                token = token.replace(
                    "~1", "/"
                ).replace(
                    "~0", "~"
                )

                current = (
                    current[int(token)]
                    if isinstance(current, list)
                    else current[token]
                )

        except (
            KeyError,
            IndexError,
            ValueError,
            TypeError,
        ):
            unresolved.append(reference)

    return operations, schemas, unresolved, external


def self_test():
    sample_index = (
        b"- [A](/api-reference/foo)\n"
        b"- [A](https://doc.bunq.com/api-reference/foo#x)\n"
        b"- [External](https://other.com/x)\n"
    )

    assert markdown_pages(sample_index) == [
        DOCS + "/api-reference/foo.md"
    ]

    sample = {
        "swagger": "2.0",
        "paths": {
            "/user": {
                "get": {
                    "responses": {"200": {}}
                }
            }
        },
        "definitions": {
            "User": {
                "properties": {
                    "id": {"type": "integer"}
                }
            }
        },
    }

    operations, schemas, unresolved, external = inspect_spec(
        sample,
        "sample.json",
    )

    assert len(operations) == 1
    assert len(schemas) == 1
    assert not unresolved
    assert not external

    assert sha256(b"abc") == (
        "ba7816bf8f01cfea414140de5dae2223"
        "b00361a396177a9cb410ff61f20015ad"
    )

    print("Offline acquisition tests: PASS")


def main():
    timestamp = datetime.datetime.now(
        datetime.timezone.utc
    ).isoformat()

    entries = []

    index = store(
        DOCS + "/llms.txt",
        "References/upstream/gitbook/llms.txt",
        "index",
    )

    entries.append(index)

    pages = {
        DOCS + "/api-reference/start-here.md"
    }

    discovery_error = None

    if index["status"] == "ok":
        try:
            pages.update(
                markdown_pages(
                    (ROOT / index["path"]).read_bytes()
                )
            )
        except (UnicodeDecodeError, ValueError) as error:
            discovery_error = str(error)
    else:
        discovery_error = index.get(
            "error",
            "Index unavailable",
        )

    with concurrent.futures.ThreadPoolExecutor(
        max_workers=3
    ) as pool:
        futures = []

        for url in sorted(pages):
            path = urllib.parse.urlsplit(
                url
            ).path.lstrip("/")

            futures.append(
                pool.submit(
                    store,
                    url,
                    "References/upstream/gitbook/pages/" + path,
                    "markdown",
                )
            )

        for future in concurrent.futures.as_completed(futures):
            entries.append(future.result())

    try:
        git = github_revision()
    except Exception as error:
        git = {"error": str(error)}

    if "revision" in git:
        revision = git["revision"]

        with concurrent.futures.ThreadPoolExecutor(
            max_workers=3
        ) as pool:
            futures = [
                pool.submit(
                    store,
                    f"https://raw.githubusercontent.com/bunq/doc/{revision}/{name}",
                    "References/upstream/bunq-doc/" + name,
                    "github",
                    revision,
                )
                for name in FILES
            ]

            for future in concurrent.futures.as_completed(futures):
                entries.append(future.result())

    else:
        for name in FILES:
            entries.append({
                "kind": "github",
                "path": "References/upstream/bunq-doc/" + name,
                "status": "failed",
                "error": "Git revision unresolved",
            })

    entries.sort(key=lambda item: item["path"])

    operations = []
    schemas = []
    unresolved = []
    external = []
    invalid = []

    for entry in entries:
        if (
            entry["status"] != "ok"
            or not entry["path"].endswith(".json")
        ):
            continue

        try:
            document = json.loads(
                (ROOT / entry["path"]).read_bytes()
            )

            spec = inspect_spec(
                document,
                entry["path"],
            )

            if spec:
                o, s, u, e = spec

                operations.extend(o)
                schemas.extend(s)

                unresolved.extend(
                    {
                        "source": entry["path"],
                        "ref": reference,
                    }
                    for reference in u
                )

                external.extend(
                    {
                        "source": entry["path"],
                        "ref": reference,
                    }
                    for reference in e
                )

        except (
            ValueError,
            TypeError,
            UnicodeDecodeError,
        ) as error:
            invalid.append({
                "path": entry["path"],
                "error": str(error),
            })

    write_json(
        "References/manifests/snapshot.json",
        {
            "captured_at": timestamp,
            "provider": "bunq",
            "git": git,
            "discovery": {
                "indexed_markdown_pages": len(pages),
                "error": discovery_error,
            },
            "sources": entries,
        },
    )

    write_json(
        "References/inventories/operations.json",
        operations,
    )

    write_json(
        "References/inventories/schemas.json",
        schemas,
    )

    write_json(
        "References/inventories/reference_errors.json",
        {
            "unresolved_internal": unresolved,
            "external_unresolved": external,
            "invalid_json": invalid,
        },
    )

    good = sum(
        entry["status"] == "ok"
        for entry in entries
    )

    failed = [
        entry
        for entry in entries
        if entry["status"] != "ok"
    ]

    problems = bool(
        failed
        or discovery_error
        or len(pages) == 1
        or invalid
        or unresolved
        or not operations
    )

    status = "partial" if problems else "complete"

    lines = [
        "# bunq documentation acquisition",
        "",
        f"- Captured (UTC): {timestamp}",
        f"- Status: **{status}** (acquisition completeness, not full API coverage)",
        f"- Sources succeeded: {good}/{len(entries)}",
        f"- Indexed Markdown pages (including required seed): {len(pages)}",
        f"- Parsed structured operations: {len(operations)}",
        f"- Parsed schemas: {len(schemas)}",
        f"- Unresolved internal references: {len(unresolved)}",
        f"- External references not fetched: {len(external)}",
        f"- Invalid JSON documents: {len(invalid)}",
        f"- bunq/doc revision: {git.get('revision', 'unavailable')}",
        "",
        "## Failures",
        "",
    ]

    lines += [
        f"- `{item['path']}`: {item['error']}"
        for item in failed
    ] or ["None."]

    if discovery_error:
        lines += [
            "",
            "## Discovery failure",
            "",
            discovery_error,
        ]

    lines += [
        "",
        "## Interpretation",
        "",
        "The published GitHub Swagger and current GitBook Markdown are separate sources. Their API coverage has NOT been established as equivalent.",
        "Markdown pages are retained as raw evidence; no endpoint counts are inferred from prose.",
        "Failed downloads never count as fresh snapshots. Existing files may remain on disk but are not counted as acquired on this run.",
    ]

    write(
        "References/inventories/coverage.md",
        ("\n".join(lines) + "\n").encode(),
    )

    print(
        f"bunq documentation: {status}; "
        f"fetched {good}/{len(entries)}; "
        f"operations={len(operations)}; "
        f"schemas={len(schemas)}"
    )

    print(
        "Report: References/inventories/coverage.md"
    )

    return 2 if problems else 0


if __name__ == "__main__":
    if "--self-test" in sys.argv:
        self_test()
    else:
        sys.exit(main())
