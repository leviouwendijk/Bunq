> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/user-provisioning/chapter-2-creating-a-user-provision.md).

# Chapter 2 Creating a user provision

Provisioning a user is the initial step in the process of creating a user account within the bunq platform. This step involves assigning basic user attributes and configurations, such as unique identifiers, contact method, and necessary personal details. By completing this step, you obtain an API Key in order to do actions on-behalf-of the user (such as finalizing the onboarding and then creating monetary accounts, cards, payments etc).

**Endpoint:**

```http
POST /v1/partner-user-provision

{
    "external_uuid": "550e8400-e29b-41d4-a716-446655440000",
    "pointer": {
        "type": "EMAIL",
        "value": "user@example.com",
        "name": "user@example.com"
    },
    "products": ["USER_VERIFIED"]
}
```

**Parameters:**

| Field           | Type   | Required | Description                                                                                       |
| --------------- | ------ | -------- | ------------------------------------------------------------------------------------------------- |
| `external_uuid` | string | Yes      | Unique identifier for this provision request. Must be a valid UUID.                               |
| `pointer`       | object | Yes      | User identification pointer (email, phone, etc.)                                                  |
| `pointer.type`  | string | Yes      | <p>Type of pointer.</p><p>Can either be:</p><p><code>EMAIL</code>, <code>PHONE\_NUMBER</code></p> |
| `pointer.value` | string | Yes      | The actual pointer value (email address, phone number)                                            |
| `pointer.name`  | string | Yes      | Display name for the pointer                                                                      |
| `products`      | array  | Yes      | List of products to provision for the user. In this case, `USER_VERIFIED`                         |

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

The response contains the `provision_id` used for monitoring. Save this ID for monitoring the provision status.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/user-provisioning/chapter-2-creating-a-user-provision.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
