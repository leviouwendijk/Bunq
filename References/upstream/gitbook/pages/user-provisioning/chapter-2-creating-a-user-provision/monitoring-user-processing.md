> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/user-provisioning/chapter-2-creating-a-user-provision/monitoring-user-processing.md).

# Monitoring User Processing

**Endpoint:**

```http
GET /v1/partner-user-provision/{provision_id}
```

**Response (initial):**

```json
{
    "Response": [
        {
            "PartnerUserProvision": {
                "id": 123,
                "created": "2025-08-13 14:45:18.621550",
                "updated": "2025-08-13 14:45:18.621550",
                "external_uuid": "550e8400-e29b-41d4-a716-446655440000",
                "status": "CREATED",
                "sub_status": "PENDING_PROCESS_USER",
                "action_required": "NONE",
                "products": ["USER_VERIFIED"],
                "label_user": null,
                "oauth_request": null,
                "credential": null
            }
        }
    ]
}
```

**Status Explanation:**

* Status: `CREATED` → Provision is created, processing started
* Sub Status: `PENDING_PROCESS_USER` → User account is being created
* label\_user: `null` → User account not yet created
* oauth\_request: `null` → OAuth setup not yet started

Continue polling this endpoint until the `sub_status` changes.

***

## Alternative: Webhook Notifications instead of Polling

*See Chapter 9: Webhooks for more information.*

**Endpoint:**

```http
POST /v1/user/{user_api_key_id}/notification-filter-url
```

**Request Body:**

```json
{
    "notification_filters": [
        {
            "category": "PARTNER_USER_PROVISION",
            "notification_target": "https://your-webhook-endpoint.com/provision-updates"
        }
    ]
}
```


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/user-provisioning/chapter-2-creating-a-user-provision/monitoring-user-processing.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
