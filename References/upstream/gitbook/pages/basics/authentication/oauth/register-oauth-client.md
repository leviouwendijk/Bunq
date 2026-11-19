> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/authentication/oauth/register-oauth-client.md).

# Register OAuth Client

Before you can start the OAuth authorization flow with bunq, you need to register an OAuth client. This client represents your application and provides the necessary credentials (`client_id` and `client_secret`) to securely authenticate users.

#### How to Create an OAuth Client

To create an OAuth client, send a `POST` request to:

```
POST /user/{user_id}/oauth-client
```

Replace `{user_id}` with your bunq user ID.

Then it will look like this:

```bash
curl -X POST "https://api.bunq.com/v1/user/{user_id}/oauth-client" \
  -H "Content-Type: application/json" \
  -H "Cache-Control: no-cache" \
  -H "User-Agent: YourServiceName" \
  -H "X-Bunq-Language: en_US" \
  -H "X-Bunq-Region: nl_NL" \
  -H "X-Bunq-Geolocation: 0 0 0 0 000" \
  -H "X-Bunq-Client-Authentication: your_session_token" \
  -H "X-Bunq-Client-Request-Id: 550e8400-e29b-41d4-a716-446655440000" \
  -H "X-Bunq-Client-Signature: base64_encoded_signature_of_payload" \
  -d '[{
        "status": "ACTIVE",
        "display_name": "My Cool App",
        "redirect_url": "https://myapp.com/oauth/callback"
      }]'
```

Once you have that oauth client registered you can retrieve its details by repeating the same API call but then as a GET request the response will contain the client\_id and client\_secret. Another item to keep track of is the ID of the oauth client. You may want to use it later in a PUT request to update the redirect URL

{% hint style="warning" %}
Be aware that each bunq user can only have 1 oauth client at a time. You'll get errors if you try to register a second one. As such you want to keep track of the ID so you can update the initial oauth client.
{% endhint %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/authentication/oauth/register-oauth-client.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
