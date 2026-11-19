> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/monetary-account/monetary-account-joint.md).

# Monetary Account Joint

A MonetaryAccountJoint is a shared monetary account co-owned by two or more bunq users. All co-owners have full access to the account and can send and receive payments on its behalf.

## Creating a joint account

Use the following endpoint to create a joint account as the initiating user. Invite the co-owner(s) by passing their alias (email, phone number, or IBAN) in the `all_co_owner` field.

`POST /v1/user/{userID}/monetary-account-joint`

Example request body:

```json
{
  "currency": "EUR",
  "description": "Joint Account",
  "all_co_owner": [
    {
      "alias": {
        "type": "EMAIL",
        "value": "co-owner@example.com"
      }
    }
  ]
}
```

The account is created with status `PENDING_ACCEPTANCE`. It transitions to `ACTIVE` once all invited co-owners have accepted the invite. Co-owners must accept through the bunq app — this step cannot be completed via the public API.

## Retrieving joint accounts

`GET /v1/user/{userID}/monetary-account-joint` `GET /v1/user/{userID}/monetary-account-joint/{itemId}`

## Updating a joint account

`PUT /v1/user/{userID}/monetary-account-joint/{itemId}`

## Webhooks

The following notification categories are relevant for joint accounts:

See [Callbacks (Webhooks)](https://doc.bunq.com/basics/callbacks-webhooks) for setup instructions.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/monetary-account/monetary-account-joint.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
