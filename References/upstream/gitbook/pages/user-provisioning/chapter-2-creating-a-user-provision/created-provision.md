> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/user-provisioning/chapter-2-creating-a-user-provision/created-provision.md).

# Created Provision

At this step, provisioning the user is finalized when you notice the `sub_status = PENDING_PROCESS_USER_ONBOARDING` . At this stage, the user is required to perform actions to finalize the onboarding. And company can use the next onboarding API to send the KYC data to bunq for validation.

**Endpoint:**

```http
GET /v1/partner-user-provision/{provision_id}
```

**Response - Active Provision:**

```json
{
    "Response": [
        {
            "PartnerUserProvision": {
                "id": 123,
                "created": "2025-08-13 14:45:18.621550",
                "updated": "2025-08-13 14:45:25.345678",
                "external_uuid": "550e8400-e29b-41d4-a716-446655440000",
                "status": "CREATED",
                "sub_status": "PENDING_PROCESS_USER_ONBOARDING",
                "action_required": "USER",
                "products": ["USER_VERIFIED"],
                "label_user": {
                    "uuid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
                    "display_name": "User Name",
                    "country": "NL",
                    "avatar": {...},
                    "public_nick_name": "UserNick",
                    "type": "PERSON"
                },
                "oauth_request": {
                    "id": 456,
                    "created": "2025-08-13 14:45:24.123456",
                    "updated": "2025-08-13 14:45:24.123456",
                    "status": "ACTIVE",
                    "scope": ["PAYMENT_INFORMATION"],
                    "redirect_url": "https://www.bunq.com/",
                    "authorization_code": "auth_code_123",
                    "client_id": "client_id_456"
                },
                "credential": {
                    "id": 789,
                    "created": "2025-08-13 14:45:24.567890",
                    "updated": "2025-08-13 14:45:24.567890",
                    "status": "ACTIVE",
                    "expiry_time": "2025-08-20 14:45:24.567890",
                    "token_value": "credential_token_abc123def456",
                    "permitted_device": {
                        "description": "Partner API Device",
                        "ip": "192.168.1.100"
                    }
                }
            }
        }
    ]
}
```

**Status Explanation:**

* Status: `ACTIVE` - The provision is fully active and ready to use
* Sub Status: `NONE` - No further processing required
* `oauth_request`: Contains OAuth details for API access
* `credential`: Contains user credential information

At this point, the user account is fully provisioned and you can use the OAuth details to make API calls on behalf of the user.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/user-provisioning/chapter-2-creating-a-user-provision/created-provision.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
