> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/authentication/oauth/handle-the-authorization-code.md).

# Handle the Authorization Code

In the previous steps we have set up an oauth client and learned how users can scan a QR code to grant access to their bunq account.

In this chapter we'll learn how to complete the oauth flow and handle the authorization code.

Once the user authorizes your app, bunq will redirect them to your registered `redirect_uri` with a `code` and `state` parameter this may look like this:

```
https://myapp.com/oauth/callback?code=AUTH_CODE&state=xyz789

```

It's your responsibility to have a endpoint on your server that can catch that callback and retrieve the code and state.

The `state` parameter is a recommended security feature in the OAuth 2.0 flow. It serves two key purposes:

1. **Prevents CSRF Attacks**\
   When initiating the OAuth authorization request, you should generate a unique and unpredictable `state` value and store it temporarily (e.g. in a session, database, or memory store). When the user is redirected back to your `redirect_uri`, you must verify that the returned `state` matches what you originally sent.
2. **Preserves Application Context**\
   You can also use `state` to carry context from your app, such as the ID of the user initiating the flow or the page they started from. This allows you to restore state after the OAuth flow completes.

The **authorization code** is a short-lived, one-time-use credential returned by bunq after a user grants your app permission. It serves as a temporary token that can be securely exchanged for long-term credentials.

### Exchanging the Authorization Code for an Access Token

Once bunq redirects the user to your app with a `code`, you can exchange it for an access token by making a `POST` request to:

```
https://api.oauth.bunq.com/v1/token
```

#### Required Parameters

* `grant_type`: must be `authorization_code`
* `code`: the code you received in the redirect
* `redirect_uri`: must match the one you registered
* `client_id`: your OAuth client ID
* `client_secret`: your OAuth client secret

***

#### Example `cURL` Request

```bash
curl -X POST https://api.oauth.bunq.com/v1/token \
  -d grant_type=authorization_code \
  -d code=AUTH_CODE \
  -d redirect_uri=https://myapp.com/oauth/callback \
  -d client_id=YOUR_CLIENT_ID \
  -d client_secret=YOUR_CLIENT_SECRET
```

Replace:

* `AUTH_CODE` with the `code` you received from bunq
* `YOUR_CLIENT_ID` with your actual client ID
* `YOUR_CLIENT_SECRET` with your client secret
* `https://myapp.com/oauth/callback` with your registered redirect URI

***

#### Example Successful Response

```json
{"access_token":"8ac6eb1d3a1a36f0bb16afe2b776d5b32f88393da19c06657cf05167da19aa16","token_type":"bearer","state":"hMtbxh3o11-pMiN5E8KOgw"}
```

It's a good idea to store this access\_token in your database and associate it with your end-user. We cannot use the access token to make API calls to bunq directly. Instead we use the Access Token to obtain a session token that we then can use on behalf of the user.

***


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/authentication/oauth/handle-the-authorization-code.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
