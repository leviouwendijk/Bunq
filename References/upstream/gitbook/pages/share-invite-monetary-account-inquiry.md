> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/share-invite-monetary-account-inquiry.md).

# Share Invite Monetary Account Inquiry

Use this endpoint to invite another bunq user to access your monetary account with configurable permissions.

### Endpoints

* `POST /v1/user/{userID}/monetary-account/{monetary-accountID}/share-invite-monetary-account-inquiry`
* `GET /v1/user/{userID}/monetary-account/{monetary-accountID}/share-invite-monetary-account-inquiry/{itemId}`
* `PUT /v1/user/{userID}/monetary-account/{monetary-accountID}/share-invite-monetary-account-inquiry/{itemId}`

### Sending an invite

Specify the invitee via `counter_user_alias` and configure permissions in `share_detail`:

```
{
  "counter_user_alias": {
    "type": "EMAIL",
    "value": "invitee@example.com"
  },
  "share_detail": {
    "ShareDetailPayment": {
      "make_payments": false,
      "make_draft_payments": false,
      "view_balance": true,
      "view_old_events": false,
      "view_new_events": true
    }
  },
  "status": "PENDING",
  "share_type": "STANDARD"
}
```

The invite starts with `status: PENDING` until the invitee accepts or rejects it via [Share Invite Monetary Account Response](https://doc.bunq.com/share-invite-monetary-account-response).

### ShareDetailPayment fields

| Field                 | Type    | Description                                          |
| --------------------- | ------- | ---------------------------------------------------- |
| `make_payments`       | boolean | Allow the invitee to make payments from this account |
| `make_draft_payments` | boolean | Allow the invitee to create draft payments           |
| `view_balance`        | boolean | Allow the invitee to see the account balance         |
| `view_old_events`     | boolean | Allow the invitee to see past transactions           |
| `view_new_events`     | boolean | Allow the invitee to see new transactions            |


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/share-invite-monetary-account-inquiry.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
