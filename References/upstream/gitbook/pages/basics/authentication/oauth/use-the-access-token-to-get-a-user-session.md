> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/authentication/oauth/use-the-access-token-to-get-a-user-session.md).

# Use the Access Token to get a user session

Once you have received the `access_token` through the OAuth flow, you must use it to create a **session**. This session allows your app to perform authenticated API calls on behalf of the user. This is an equal process to the regular  flow. However what is different is that you use the end-users access token to get the session.

#### Endpoint

```
POST /v1/session-server
```

#### Purpose

This endpoint creates a new API session using the OAuth access token.

#### Example `cURL` Request

> ⚠️ This example assumes you've already signed the payload and have the device token ready.

```bash
curl -X POST https://api.bunq.com/v1/session-server \
  -H "Content-Type: application/json" \
  -H "Cache-Control: no-cache" \
  -H "User-Agent: my-app-name" \
  -H "X-Bunq-Language: en_US" \
  -H "X-Bunq-Region: nl_NL" \
  -H "X-Bunq-Geolocation: 0 0 0 0 000" \
  -H "X-Bunq-Client-Authentication: your_device_token" \
  -H "X-Bunq-Client-Signature: BASE64_SIGNATURE_OF_PAYLOAD" \
  -d '{"secret":"USER_ACCESS_TOKEN"}'
```

***

#### ✅ Example Response

```json

{
    "Response": [
        {
            "Id": {
                "id": 25536694
            }
        },
        {
            "Token": {
                "id": 25536694,
                "created": "2025-03-05 16:12:11.918100",
                "updated": "2025-03-05 16:12:11.918100",
                "token": "ce717e3001d979ff5e22bac13508b46e7ad740971d1d75c5371614e546ca8b83"
            }
        },
        {
            "UserPerson": { "id": 1822179,
                            "rest of the user object":"..."  }
        }
    ]
}
```

***


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/authentication/oauth/use-the-access-token-to-get-a-user-session.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
