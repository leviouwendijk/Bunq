> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/getting-started/tools.md).

# Tools

To help you build smooth, reliable integrations with bunq's public API, we offer a set of developer-friendly tools designed to make your life easier — from setup to testing and deployment.

🔧 [**Postman Collection**](https://github.com/bunq/gitbook-documentation/tree/master/getting-started/tools/postman/README.md)\
Use our official Postman collection to explore the API, test requests, and inspect responses—all in an interactive, user-friendly interface. You can easily set headers, manage authentication, and automate tests. It's a great way to understand how the API behaves before diving into code.

📱 [**Android Emulator**](https://github.com/bunq/gitbook-documentation/tree/master/getting-started/tools/android-emulator/README.md)\
Want to see how the end user interacts with the bunq API without needing a physical device? The Android Emulator lets you test on different screen sizes, OS versions, and configurations. It's ideal for making sure your integration works smoothly across various user scenarios.

🤖 [**MCP**](https://github.com/bunq/gitbook-documentation/tree/master/getting-started/tools/mcp/README.md)\
Query the bunq API documentation directly from your AI assistant or MCP-compatible development tool. Connect to our MCP server at `https://doc.bunq.com/~gitbook/mcp` and get answers grounded in our official docs — without leaving your environment.

Together, these tools give you everything you need to develop, test, and maintain powerful applications on top of the bunq ecosystem—no stress, no guesswork. :rocket:


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/getting-started/tools.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
