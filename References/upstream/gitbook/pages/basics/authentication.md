> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/authentication.md).

# Authentication

When integrating with the bunq API, you can authenticate using either an **API key** or **OAuth**, depending on your use case. **API keys** provide a straightforward way to authenticate, making them ideal for server-to-server communication and automated scripts. They offer fast access but come with security risks if exposed, as they grant broad permissions. **OAuth**, on the other hand, is designed for third-party applications that need user-specific access. It allows fine-grained permissions and secure authentication without sharing credentials but requires a more complex authorization flow. Choose the method that best fits your needs:

{% hint style="info" %}
OAuth is the obligatory authentication method for public projects whereas using API keys is allowed as long as only you have access to your application.
{% endhint %}

{% content-ref url="/pages/sY7NIUhQd0YOhIITR7nE" %}
[API Keys](/basics/authentication/api-keys.md)
{% endcontent-ref %}

{% content-ref url="/pages/nQpuM79hqrXIE9iNgCIm" %}
[OAuth](/basics/authentication/oauth.md)
{% endcontent-ref %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/authentication.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
