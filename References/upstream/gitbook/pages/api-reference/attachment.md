> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/api-reference/attachment.md).

# Attachment

**Attachments** in the bunq app allow users to attach images or text to payments, making it easy to reference receipts, invoices, or any relevant information later. Each attachment is linked to a Monetary account. Each attachment must have a specific file type, such as JPEG, PNG, or PDF, and the file is first uploaded to a monetary account before it can be linked to any payment.

The process involves multiple steps:

1. **Create the attachment -That is this page-.**\
   Users must first upload the file to the monetary account. This step requires providing the file itself along with a brief description. Bunq stores the attachment securely and returns a unique attachment ID, which will be used in the next step.
2. **Link the attachment to a payment:** Once the attachment exists, it can be linked to a specific payment as a **note-attachment**. This allows users to associate files like receipts or invoices directly with a transaction for easy retrieval. An optional description can also be added to give context to the attachment within the payment. To see how to do this reference [Payment](/note-text-and-attachment/payment.md)
3. **Add text notes (optional):** Separately, users can also add plain text notes to a payment as a **note-text**, without uploading a file. This is useful for quick comments, explanations, or any textual reference that supplements the payment. [Note Text & Attachment](/note-text-and-attachment.md)

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/attachment" method="post" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/attachment/{itemId}" method="get" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/api-reference/attachment.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
