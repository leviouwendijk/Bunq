> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/user-provisioning/chapter-1-setting-up-oauth-client.md).

# Chapter 1 Setting up oauth client

**This chapter goes into the setting up of the oauth client for user provisioning.**

{% hint style="info" %}
Our default API documentation has additional material related to setting up[OAuth](/basics/authentication/oauth.md).
{% endhint %}

**Endpoint:**

```http
POST /v1/user/{user_id}/oauth-client

{}
```

**Response:**

```json
{
    "Response": [
        {
            "Id": {
                "id": 789
            }
        }
    ]
}
```

***

## Step 2: Read OAuth Client Details

**Endpoint:**

```http
GET /v1/user/{user_id}/oauth-client/{client_id}
```

**Response:**

```json
{
    "Response": [
        {
            "OauthClient": {
                "id": 789,
                "status": "ACTIVE",
                "display_name": null,
                "client_id": "client_abc123def456",
                "secret": "secret_xyz789uvw012",
                "callback_url": []
            }
        }
    ]
}
```

**Fields:**

| Field          | Type    | Description                            |
| -------------- | ------- | -------------------------------------- |
| `id`           | integer | Unique identifier for the OAuth client |
| `status`       | string  | Status (e.g., `ACTIVE`)                |
| `display_name` | string  | Human-readable name                    |
| `client_id`    | string  | OAuth client ID                        |
| `secret`       | string  | OAuth client secret                    |
| `callback_url` | array   | Registered callback URLs               |

***

## Step 3: Register OAuth Callback URL

**Endpoint:**

```http
POST /v1/user/{user_id}/oauth-client/{client_id}/callback-url

{
    "url": "https://yourpartner.com/oauth/callback"
}
```

**Response:**

```json
{
    "Response": [
        {
            "Id": {
                "id": 456
            }
        }
    ]
}
```

| Parameter | Type   | Required | Description                    |
| --------- | ------ | -------- | ------------------------------ |
| `url`     | string | Yes      | HTTPS callback URL to register |

***

## Step 4: Read Callback URL Details

**Endpoint:**

```http
GET /v1/user/{user_id}/oauth-client/{client_id}/callback-url/{callback_url_id}
```

**Response:**

```json
{
    "Response": [
        {
            "OauthCallbackUrl": {
                "id": 456,
                "created": "2025-08-13 14:45:20.123456",
                "updated": "2025-08-13 14:45:20.123456",
                "url": "https://yourpartner.com/oauth/callback"
            }
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
GET https://doc.bunq.com/user-provisioning/chapter-1-setting-up-oauth-client.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
