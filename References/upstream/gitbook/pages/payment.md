> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/payment.md).

# Payment

The Payments API endpoints allow you to execute and manage payments from a monetary account. There are three main features:

1. **Payments**
2. **Payments Auto Allocate**,
3. **Payment Batch**.

Standard **Payments** are used for sending individual payments directly, while **Payments Auto Allocate** can automatically determine the appropriate monetary account for a payment based on predefined rules. **Payment Batch** enables sending multiple payments at once,

{% hint style="info" %}
Be aware that **Payment Service Providers (PSPs)** due to PSD2 restrictions, cannot **execute** transactions. They can initiate transactions but the user still has to confirm.

As such PSPs must instead use [Draft Payment](/draft-payment.md), which allow multiple payment entries in a single request while still requiring the end user to accept each payment in the app.
{% endhint %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/payment.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
