#!/usr/bin/env python3
"""Read-only checksum and inventory verification for the bunq reference corpus."""

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
REFERENCES = ROOT / "References"


def main():
    snapshot = json.loads((REFERENCES / "manifests/snapshot.json").read_text())
    errors = []
    seen = set()
    for source in snapshot["sources"]:
        relative = source["path"]
        if relative in seen:
            errors.append(f"Duplicate manifest path: {relative}")
        seen.add(relative)
        if source["status"] != "ok":
            errors.append(f"Failed download in snapshot: {relative}")
            continue
        path = ROOT / relative
        if not path.is_file():
            errors.append(f"Missing: {relative}")
            continue
        content = path.read_bytes()
        if len(content) != source["bytes"] or hashlib.sha256(content).hexdigest() != source["sha256"]:
            errors.append(f"Changed: {relative}")
    for relative in (
        "References/upstream/bunq-doc/swagger.json",
        "References/upstream/bunq-doc/generated.json",
        "References/upstream/bunq-doc/base.json",
    ):
        try:
            json.loads((ROOT / relative).read_bytes())
        except (OSError, ValueError) as error:
            errors.append(f"Invalid JSON {relative}: {error}")
    operations = json.loads((REFERENCES / "inventories/operations.json").read_text())
    schemas = json.loads((REFERENCES / "inventories/schemas.json").read_text())
    if not operations or not schemas:
        errors.append("Empty operation or schema inventory")
    for error in errors:
        print("FAIL:", error)
    print(f"Bunq verify: {len(snapshot['sources'])} sources, {len(operations)} operations, {len(schemas)} schemas; failures={len(errors)}")
    return 2 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
