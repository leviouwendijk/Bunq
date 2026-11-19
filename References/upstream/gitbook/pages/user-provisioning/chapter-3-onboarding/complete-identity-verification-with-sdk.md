> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/user-provisioning/chapter-3-onboarding/complete-identity-verification-with-sdk.md).

# Complete Identity Verification with SDK

**Endpoint:**

```http
GET /v1/user/{user_api_key_id}/identity-verification-session/36
```

**Response:**

```json
{
    "Response": [
        {
            "IdentityVerificationSessionIncode": {
                "id": 36,
                "created": "2025-10-31 16:38:53.872547",
                "updated": "2025-10-31 16:38:53.872547",
                "purpose": "VERIFICATION",
                "applicant_identifier_external": null,
                "session_identifier_external": "incode_token",
                "country": "NL",
                "status": "CREATED",
                "token": "token_value_123",
                "url_api": "https://demo-api.incodesmile.com/0/",
                "should_record_session": true,
                "result": null
            }
        }
    ]
}
```

## Step 3: Pass the information to the SDK

Here, the token should be passed to the SDK in order for the session to start. User will then interact with it and they will apply facial verification and ID check. After it is done, your app will obtain a confirmation from the SDK, then you need to inform bunq using the following endpoint.

**Endpoint:**

```html
PUT /v1/user/{user_api_key_id}/identity-verification-session/36
```

**Request Body:**

```json
{
    "status": "SUBMITTED"
}
```

**Response:**

```json
{
    "Response": [
        {
            "Id": {
                "id": 36
            }
        }
    ]
}
```

## Step 4: Keep polling until the result is completed

**Endpoint:**

```http
GET /v1/user/{user_api_key_id}/identity-verification-session/36
```

**Response:**

```json
{
    "Response": [
        {
            "IdentityVerificationSessionIncode": {
                "id": 36,
                "created": "2025-10-31 16:38:53.872547",
                "updated": "2025-10-31 16:38:53.872547",
                "purpose": "VERIFICATION",
                "applicant_identifier_external": null,
                "session_identifier_external": "incode_token",
                "country": "NL",
                "status": "PROCESSED",
                "token": "token_value_123",
                "url_api": "https://demo-api.incodesmile.com/0/",
                "should_record_session": true,
                "result": "APPROVED"
            }
        }
    ]
}
```

Now, user identity verification is completed and user is Approved, you can continue with finalizing the rest of the fulfillments.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/user-provisioning/chapter-3-onboarding/complete-identity-verification-with-sdk.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
