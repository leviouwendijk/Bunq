> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/authentication/oauth/making-api-calls-on-behalf-of-bunq-users.md).

# Making API calls on behalf of bunq Users

When interacting with the bunq API on behalf of a user, you need two key pieces of information from the **session-server** endpoint: the **end user session token** and the **user API key ID**. The session token represents the end user's consent and authenticates your requests, while the user API key ID uniquely identifies the API key that your application must use to access that specific user's data.

The response from the session endpoint is divided into three main sections. **User API Key Info** contains the API key that your application should use for authorized calls. **Requested By** describes your application or Payment Service Provider, including metadata such as display name and session expiration. **Granted By** details the end user who authorized the session, including their display name and session expiration.

> **Warning:** Do **not use the normal user ID in API calls**. All requests must include the session token in the headers and use the user API key ID in the URL to correctly identify the user for the session. This ensures that your application acts on behalf of the user safely and in compliance with bunq's security model.

For example, to fetch all monetary accounts for a user, you would use the following API call:

```python

#Function assuming you have your full installation set up
def get_monetary_accounts():
    session_token = "fc857727d7c2bff375a0e8cde6e657cec2a5b45d1de489ac3ca20eb033016ad2" 
    end_user_id = "2580769"
    user_api_key_id = "2608880"
    response = requests.get(
        f"https://public-api.sandbox.bunq.com/v1/user/{user_api_key_id}/monetary-account",
        headers={
            "User-Agent": "text",
            "X-Bunq-Client-Authentication": session_token,
            "Content-Type": "application/json"},
    )
    return response.json()
```


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/authentication/oauth/making-api-calls-on-behalf-of-bunq-users.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
