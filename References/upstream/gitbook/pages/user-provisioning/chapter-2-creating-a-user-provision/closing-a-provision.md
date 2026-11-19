> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/user-provisioning/chapter-2-creating-a-user-provision/closing-a-provision.md).

# Closing a Provision

**Endpoint:**

```http
PUT /v1/partner-user-provision/{provision_id}
```

**Request Body:**

```json
{
    "status": "CANCELLED"
}
```

**Response:**

```json
{
    "Response": [
        {
            "Id": {
                "id": 123
            }
        }
    ]
}
```

**After cancellation:**

```json
{
    "Response": [
        {
            "PartnerUserProvision": {
                "id": 123,
                "external_uuid": "550e8400-e29b-41d4-a716-446655440000",
                "status": "CLOSED",
                "sub_status": "NONE",
                "action_required": "NONE",
                "products": ["USER_VERIFIED"],
                "label_user": {...},
                "oauth_request": {...},
                "credential": null
            }
        }
    ]
}
```

#### Main Status Values

| `CREATED`   | Provision created, processing in progress |
| ----------- | ----------------------------------------- |
| `ACTIVE`    | Provision fully active and operational    |
| `CANCELLED` | Provision cancelled by request            |
| `FAILED`    | Provision failed during processing        |
| `CLOSED`    | Provision closed and no longer active     |

#### Sub Status Values

**Main Status Values**

| `CREATED`   | Provision created, processing in progress |
| ----------- | ----------------------------------------- |
| `ACTIVE`    | Provision fully active and operational    |
| `CANCELLED` | Provision cancelled by request            |
| `FAILED`    | Provision failed during processing        |
| `CLOSED`    | Provision closed and no longer active     |

**Sub Status Values**

| `NONE`                            | Any         | No specific sub-process active         |
| --------------------------------- | ----------- | -------------------------------------- |
| `PENDING_PROCESS_USER`            | `CREATED`   | Creating bunq user account             |
| `PENDING_PROCESS_RELATION_USER`   | `CREATED`   | Establishing partner-user relationship |
| `PENDING_PROCESS_OAUTH_REQUEST`   | `CREATED`   | Setting up OAuth access                |
| `PENDING_PROCESS_USER_ONBOARDING` | `CREATED`   | Processing user onboarding             |
| `PENDING_PROCESS_CLOSURE`         | `CANCELLED` | ​                                      |


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/user-provisioning/chapter-2-creating-a-user-provision/closing-a-provision.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
