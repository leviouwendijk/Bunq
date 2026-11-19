> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/support/api-support-team.md).

# API Support Team

{% hint style="success" %}
**This support channel is only for API-related questions.**\
This means we can assist you only if you're building on top of the bunq API, have questions about OAuth, or are working with PSD2 integrations.

For anything else, please contact our [bunq Customer Support.](https://together.bunq.com/d/32181-how-do-i-contact-support)
{% endhint %}

If you have questions, encounter bugs, or need help integrating with our API, you can reach us directly via email: [**apipartner@bunq.com**](mailto:apipartner@bunq.com)\
To help us assist you faster, please include the following in your message:

* ✅ **Environment**: `production` or `sandbox`
* 🕒 **Timestamp** of the issue (preferably in UTC — you can find this in our response headers)
* 🔁 **Response ID** (from the API response headers)
* 👥 **How many users are affected** (especially relevant for PSD2 partners that grant access to third-party users)
* 🔍 **Endpoint or feature** involved
* 📝 A short description of the problem, including any **error messages or codes**


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/support/api-support-team.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
