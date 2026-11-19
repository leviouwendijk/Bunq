> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/psd2/account-information-service-provider-aisp.md).

# Account Information Service Provider (AISP)

{% hint style="success" %}
Heya! Before checking this page, make sure that you [registered yourself as a TPP](/psd2/are-you-a-third-party-provider-tpp-start-here/register-as-a-tpp.md) in our API first.
{% endhint %}

As an AISP, you are allowed to authenticate in a user’s account and access (read) the following account information:

1. legal name
2. IBAN
3. nationality
4. card validity data
5. transaction history
6. account balance

To read the user's information, you need to establish a connection with their bunq account. You can do it using an **authorization request**. Once a bunq user has confirmed the authorization request and you have done the **token exchange**, you can activate the Access Token (use it as an API key).

Token activation happens when you create an API context (install it and link your IP adrress and device to it). See the [OAuth](/basics/authentication/oauth.md) page for the full flow illustration.

{% content-ref url="/pages/nQpuM79hqrXIE9iNgCIm" %}
[OAuth](/basics/authentication/oauth.md)
{% endcontent-ref %}

An active Access Token allows you to communicate with the bunq user’s account. You can use it to start a session to interact with the monetary accounts the user allows you to access.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/psd2/account-information-service-provider-aisp.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
