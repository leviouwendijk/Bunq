> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/authentication/oauth/redirect-users-to-authorize-your-app.md).

# Redirect Users to Authorize your app

Once you've successfully registered your OAuth client ( ), you will have a **client\_id** and **client\_secret**. These credentials allow your application to request access on behalf of your users.

What we want now is to redirect the end-user to a page where they can give away the access to their bank account. This is done by redirecting them to the authorization page.

<figure><img src="https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-8210b9cb518719ca3ab0b9c3ae61cbbda1ee8fa6%2FScreenshot%202025-06-25%20at%201.07.10%E2%80%AFPM.png?alt=media" alt=""><figcaption></figcaption></figure>

In your app you'll have a button or step in your signup flow where you send your users to this authorization page when they link your app to their bunq account.

#### Step 1: Redirect Users to the Authorization Page

To begin, redirect your users to bunq's authorization endpoint where they can grant your app access to their account:

```
https://oauth.bunq.com/auth?response_type=code&client_id={client_id}&redirect_uri={redirect_uri}&state={state}&scope={scope}
```

* `response_type=code` — Indicates that you're using the authorization code flow.
* `client_id` — Your OAuth client ID.
* `redirect_uri` — Must match the URL registered with your OAuth client.
* `state` — Optional, but highly recommended for CSRF protection.

#### Example Authorization URL

```plaintext
https://oauth.bunq.com/auth?response_type=code&client_id=abc123xyz&redirect_uri=https://myapp.com/oauth/callback&state=xyz789
```

#### What Happens Next?

The user will scan the QR code with their bunq app and grant access to bank accounts. If you want to recreate this step you can use to get a sandbox version of the bunq app.

Once the user completes the flow, bunq will redirect back to your `redirect_uri` with a temporary authorization code and the associated state that you sent along:

```
https://myapp.com/oauth/callback?code=AUTH_CODE&state=xyz789
```

You will then exchange this code for an access token to make authenticated API requests on the user's behalf. We'll handle that in the next section


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/authentication/oauth/redirect-users-to-authorize-your-app.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
