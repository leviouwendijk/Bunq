> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/psd2/are-you-a-third-party-provider-tpp-start-here.md).

# Are you a Third Party Provider (TPP)? Start here!

If you're a PSD2-certified third-party provider (TPP), you can integrate directly with the bunq Public API using your **eIDAS certificate**. This guide walks you through the step-by-step process to register and authenticate with the bunq environment.

{% hint style="danger" %}
PSD2 providers do **not** have access to the bunq Developers Portal. Integration is done entirely through API calls.
{% endhint %}

### 🚀 What Do You Need to Integrate with bunq?

Getting started with the bunq Public API is simple! Here’s what you’ll need to build, test, and simulate your integration from start to finish:

{% hint style="info" %}
If you get stuck or have questions, you can always reach out to [our support team](/support/api-support-team.md). We're here to help!
{% endhint %}

#### 🧪 Test Your Integration with Postman

Want to explore the API before writing a single line of code? We’ve got you covered.

Our official **Postman collection** lets you:

* Send requests to any bunq endpoint
* Simulate real API behavior
* Inspect responses and debug easily
* Automate tests as you go

Perfect for learning the API or validating your integration logic.

You can find more info here:

{% content-ref url="/pages/N4PEtvluykQpcB57RnKI" %}
[Postman](/getting-started/tools/postman.md)
{% endcontent-ref %}

#### 📱 Simulate User Behavior with Our APK

Need to see how things work from a user’s perspective? Use our **bunq APK** to simulate real user actions like logging in, approving payments, or accepting requests.

This is especially useful for:

* End-to-end testing
* Mimicking user approvals for DraftPayments or OAuth flows
* Validating UX before going live

Please check here how to use our Android APK:

{% content-ref url="/pages/cTVOKghIW3JAaoiKgWSA" %}
[Android Emulator](/getting-started/tools/android-emulator.md)
{% endcontent-ref %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/psd2/are-you-a-third-party-provider-tpp-start-here.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
