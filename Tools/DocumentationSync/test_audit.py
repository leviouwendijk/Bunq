"""Offline tests for GitBook OpenAPI directive reconciliation."""

import unittest
import audit


class GitBookDirectiveTests(unittest.TestCase):
    def test_extracts_explicit_directive(self):
        text = '# Payment\n{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/payment" method="post" %}\n{% endopenapi %}\n'
        found = audit.extract_directives(text, "payment.md")
        self.assertEqual(len(found), 1)
        self.assertEqual(found[0]["method"], "POST")
        self.assertEqual(found[0]["line"], 2)
        self.assertEqual(found[0]["path"], "/user/{userID}/payment")

    def test_normalizes_parameter_identifiers_only(self):
        self.assertEqual(
            audit.key("get", "/v1/user/{id}/payment/"),
            audit.key("GET", "/user/{userID}/payment"),
        )


    def test_classifies_gitbook_provenance(self):
        self.assertEqual(audit.classify_spec_source("/files/xJ3v0GinyfONRbxz8Srh"), "gitbook_attachment_unverified")
        self.assertEqual(audit.classify_spec_source("<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>"), "bunq_doc_swagger")
        self.assertEqual(audit.classify_spec_source("https://example.com/spec"), "unrecognized")


if __name__ == "__main__":
    unittest.main()
