> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/bunq-api-objects/attachment-and-note-attachment.md).

# Attachment and Note Attachment

Sometimes, a payment or request needs a little extra context—like an invoice, receipt, or a photo. That’s where **attachments** come in.

You can attach `.png` or `.jpeg` images to both **Payment** and **RequestInquiry** objects, either before or after they’re created:

* Use an **Attachment** when you want to upload a file first and then link it while creating a payment or request.
* Use a **NoteAttachment** when you want to add a file to an existing object (like a sent payment or draft).

### **🧩 What's the difference?**

* **Attachment**:\
  A general file upload linked directly to the **MonetaryAccount**.\
  Endpoint:\
  `POST /user/{userId}/monetary-account/{monetaryAccountId}/attachment`
* **NoteAttachment**:\
  A file added to a specific object (like a `Payment`, `RequestInquiry`, etc.) after it's been created.\
  Endpoints:
  * `/user/{userId}/monetary-account/{monetaryAccountId}/payment/{paymentId}/note-attachment`
  * `/user/{userId}/monetary-account/{monetaryAccountId}/request-inquiry/{requestInquiryId}/note-attachment`
  * `/user/{userId}/monetary-account/{monetaryAccountId}/draft-payment/{draftPaymentId}/note-attachment`
  * `/user/{userId}/monetary-account/{monetaryAccountId}/schedule-payment/{schedulePaymentId}/note-attachment`

This setup gives you flexibility—whether you're attaching a receipt during a payment, or adding an invoice afterward.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/bunq-api-objects/attachment-and-note-attachment.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
