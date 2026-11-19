# Bunq reference tooling

Documentation acquisition, contract reconciliation and integrity verification. No banking API calls or credentials are used.

From `Bunq/`:

- `python3 Tools/DocumentationSync/sync.py` — acquire GitBook Markdown and revision-pinned bunq/doc documents.
- `python3 Tools/DocumentationSync/audit.py` — reconcile GitBook OpenAPI directives with pinned Swagger, keeping provenance warnings separate.
- `python3 Tools/DocumentationSync/verify.py` — read-only checksum integrity check.
- `python3 -m unittest discover -s Tools/DocumentationSync -p 'test_*.py'` — offline tests.

The GitBook attachment referenced by 14 directives remains unverified despite matching method/path operations in Swagger. This is a provenance warning, not an endpoint mismatch.
