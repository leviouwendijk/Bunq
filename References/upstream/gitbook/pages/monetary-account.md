> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/monetary-account.md).

# Monetary Account

### Monetary Accounts

A **Monetary Account** represents a bank account in bunq. Users can have multiple accounts of different types, depending on their needs.

The bunq API supports the following monetary account models:

#### `MonetaryAccountBank`

Standard bunq bank account. Fully featured and supports payments, deposits, budgeting, and more.

#### `MonetaryAccountJoint`

Shared account between two or more users. Ideal for households or joint financial management.

#### `MonetaryAccountSavings`

Savings account with interest.\
**Limited to 2 withdrawals per month**, as per savings account rules.

#### `MonetaryAccountExternal`

Linked account from another bank. Supports viewing balance and transaction history.

#### `MonetaryAccountExternalSavings`

External savings account linked from another bank. Similar to `MonetaryAccountExternalModel`, but categorized as a savings product.

#### `MonetaryAccountCard`

Represents prepaid cards or card-only products with limited banking functionality.

***

Each monetary account model shares common fields (like balance, description, and status), but some types include unique constraints or features.

You can retrieve a user's monetary accounts using:

```bash
GET /user/{user_id}/monetary-account
```

Use the `MonetaryAccountBank`, `MonetaryAccountJoint`, etc. endpoints to access specific account types.

Reference the API objects here: [Monetary Account](/basics/bunq-api-objects/monetary-account.md)


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/monetary-account.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
