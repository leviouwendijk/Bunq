> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/moving-to-production.md).

# Moving to production

Have you tested your bunq integration to the fullest and are now ready to introduce your application to the world? It's time to move it to the production environment!

Here is what you need to do to get started:

1. Generate a production API key via the bunq app. Go *Profile → Security & Settings → Developers → API keys*.
2. Change your API Key and redo the [sequence of calls to open a session](/tutorials/your-first-payment/creating-the-api-context/start-a-session.md).
3. Change the base url to: <https://api.bunq.com>.

We highly recommend using a standard production API Key instead of a [Wildcard API Key](https://together.bunq.com/d/1997-the-new-wildcard-api-key). The former is significantly safer and it protects you from malicious intrusions and attacks.

{% hint style="warning" %}
Please be aware that if you will gain access to account information of other bunq users or initiate a payment for them, you may be legally required to first obtain a PSD2 permit. More information on this can be found [here](/psd2/are-you-a-third-party-provider-tpp-start-here.md)
{% endhint %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/moving-to-production.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
