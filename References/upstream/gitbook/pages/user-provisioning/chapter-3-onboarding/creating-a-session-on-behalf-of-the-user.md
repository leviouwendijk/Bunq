> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/user-provisioning/chapter-3-onboarding/creating-a-session-on-behalf-of-the-user.md).

# Creating a session on behalf of the user

## Step 1: Create SessionServer

Before creating notification filters, you need to establish a `SessionServer` using the `token_value` obtained when the `PartnerUserProvision` becomes active.

**Endpoint:**

```http
POST /v1/session-server
```

**Request Body:**

```json
{ 
    "secret": "<credential.token_value_from_created_provision>" 
}
```

The `token_value` is obtained from the credential object when the `PartnerUserProvision` status becomes `CREATED` and subStatus = `PENDING_PROCESS_USER_ONBOARDING` (as shown in Chapter 2).

**Response:**

```json
{
    "Response": [
        {
            "Id": {
                "id": 2173
            }
        },
        {
            "Token": {
                "id": 2173,
                "created": "2025-08-13 15:53:11.594918",
                "updated": "2025-08-13 15:53:11.594918",
                "token": "f981bd6d26b8328b89e85a774c404bb02e72d18062dab92bb59c9e59a1c5958f"
            }
        },
        {
            "UserApiKey": {
                "id": 1364,
                "created": "2025-08-13 15:53:11.286445",
                "updated": "2025-08-13 15:53:11.286445",
                "requested_by_user": {
                    "UserCompany": {
                        "id": 1360,
                        "display_name": "Surrey Coöperatie",
                        "public_nick_name": "Surrey Coöperatie",
                        "avatar": {...},
                        "session_timeout": 604800
                    }
                },
                "granted_by_user": {
                    "UserPerson": {
                        "id": 1363,
                        "display_name": "New bunqer",
                        "public_nick_name": "New bunqer",
                        "avatar": {...},
                        "session_timeout": 604800
                    }
                }
            }
        }
    ]
}
```

* `Id`: Session ID for authentication
* `Token`: Session token for API calls
* `UserApiKey`: Information about the API key relationship between the partner (`requested_by_user`) and the provisioned user (`granted_by_user`)

Save the session ID for subsequent API calls to the provisioned user's endpoints.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/user-provisioning/chapter-3-onboarding/creating-a-session-on-behalf-of-the-user.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
