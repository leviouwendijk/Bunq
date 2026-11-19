> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/share-invite-monetary-account-response.md).

# Share Invite Monetary Account Response

Use this endpoint to list, view, and respond to incoming share invites from other bunq users.

### Endpoints

* `GET /v1/user/{userID}/share-invite-monetary-account-response`
* `GET /v1/user/{userID}/share-invite-monetary-account-response/{itemId}`
* `PUT /v1/user/{userID}/share-invite-monetary-account-response/{itemId}`

### Listing incoming invites

```
GET /v1/user/{userID}/share-invite-monetary-account-response
```

Returns all pending and historical share invites for the authenticated user.

### Accepting or rejecting an invite

```
{
  "status": "ACCEPTED"
}
```

Set `status` to `ACCEPTED` or `REJECTED`. Once accepted, the invitee can access the owner's monetary account according to the permissions defined in the invite.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/share-invite-monetary-account-response.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
