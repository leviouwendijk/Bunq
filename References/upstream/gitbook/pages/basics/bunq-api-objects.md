> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/bunq-api-objects.md).

# bunq API Objects

No matter what kind of integration you’re building, you’ll be working with a few essential objects that make up the bunq ecosystem. While the general idea behind each one is straightforward, some names or relationships might seem a little unexpected—mainly because the public API is built on top of the same system that powers the bunq app itself.

Here are the main objects you’ll need to get familiar with (by ID):

* [**User**](/basics/bunq-api-objects/user.md)
* [**MonetaryAccount**](/basics/bunq-api-objects/monetary-account.md)
* [**Payment**](/basics/bunq-api-objects/payment.md)
* [**RequestInquiry**](/basics/bunq-api-objects/requestinquiry.md)
* [**Card**](/basics/bunq-api-objects/card.md)
* [**Attachment**](/basics/bunq-api-objects/attachment-and-note-attachment.md)
* [**NoteAttachment**](/basics/bunq-api-objects/attachment-and-note-attachment.md)

Let’s take a closer look at each of them and see how they fit together.

<figure><img src="https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-a78d2588b8e6c2eb24ae27257b903e9ba1fa9a7f%2F68747470733a2f2f7777772e62756e712e636f6d2f6173736574732f6d656469612f646576656c6f7065722f62756e712d4150492d67656e6572616c697a65642e6a7067.jpg?alt=media" alt=""><figcaption><p>Entity relation graph</p></figcaption></figure>


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/bunq-api-objects.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
