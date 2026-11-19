> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/sandbox-users-and-sandbox-money.md).

# Sandbox Users and Sandbox Money

For you to start building on top of the bunq API you need a sandbox user and sandbox money. Both are easy to obtain

## Sandbox user

Make a call to the[Sandbox Users](/sandbox-users.md) endpoint to get a sandbox [User](/basics/bunq-api-objects/user.md) returned. This user will also contain a API key.

## Sandbox Money

You can get sandbox money by making a [Request Inquiry](/request/request-inquiry.md)to <sugardaddy@bunq.com>. He will grant you money to your sandbox user for amounts up to €500.

## Full tutorial setting up your user

If you want a bit more context on setting up your user then please refer to our [Your first payment](/tutorials/your-first-payment.md) where we have a entire chapter on [Setting up a sandbox user](/tutorials/your-first-payment/setting-up-a-sandbox-user.md) including getting the account funded, but also on how to get a copy of the bunq sandbox app.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/sandbox-users-and-sandbox-money.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
