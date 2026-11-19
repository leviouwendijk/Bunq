> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/user-provisioning/chapter-2-creating-a-user-provision/monitoring-oauth-processing.md).

# Monitoring oAuth Processing

**Endpoint:**

```http
GET /v1/partner-user-provision/{provision_id}
```

**Response - OAuth Processing:**

```json
{
    "Response": [
        {
            "PartnerUserProvision": {
                "id": 123,
                "created": "2025-08-13 14:45:18.621550",
                "updated": "2025-08-13 14:45:22.789012",
                "external_uuid": "550e8400-e29b-41d4-a716-446655440000",
                "status": "CREATED",
                "sub_status": "PENDING_PROCESS_OAUTH_REQUEST",
                "action_required": "NONE",
                "products": ["USER_VERIFIED"],
                "label_user": {
                    "uuid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
                    "display_name": "User Name",
                    "country": "NL",
                    "avatar": {...},
                    "public_nick_name": "UserNick",
                    "type": "PERSON"
                },
                "oauth_request": null,
                "credential": null
            }
        }
    ]
}
```

**Status Explanation:**

* Status: `CREATED` - Still in creation process
* Sub Status: `PENDING_PROCESS_OAUTH_REQUEST` - Setting up OAuth access
* `oauth_request`: `null` - OAuth setup in progress


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/user-provisioning/chapter-2-creating-a-user-provision/monitoring-oauth-processing.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
