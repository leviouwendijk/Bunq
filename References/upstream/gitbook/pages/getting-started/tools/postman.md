> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/getting-started/tools/postman.md).

# Postman

[Postman](https://www.postman.com/) is a powerful tool that lets you interact with the bunq API in a visual, no-code environment. You can send requests, tweak parameters, set headers, manage authentication, and inspect responses—all without writing a single line of code.

It’s perfect for:

* Exploring how endpoints work
* Testing different use cases before coding
* Debugging your integration
* Automating API tests

Find our postman collection here:

{% embed url="<https://github.com/bunq/postman>" %}

With our official Postman collection, you’ll hit the ground running—no setup headaches, just straight into experimenting with the API.

## Video instructions on how to make your first API call with postman

{% embed url="<https://youtu.be/wgURHBZIbiQ>" %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/getting-started/tools/postman.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
