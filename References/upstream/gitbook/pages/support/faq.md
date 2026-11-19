> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/support/faq.md).

# FAQ

{% hint style="success" %}
Don't know what to do? You can always get in touch with us via support in your bunq app!
{% endhint %}

Welcome to our FAQ page! Here you'll find answers to the most common questions about integrating with the bunq API, including setup requirements, authentication, and support. Whether you're just getting started or looking for specific details, this page is here to help you build with confidence.

We are constantly updating this page, so keep a look out to the most common questions!

<details>

<summary>If you are a bunq user</summary>

#### What do I need to integrate bunq's API?

To integrate with bunq's API, you'll need:

* An **API key**, which you can generate from the bunq app.
* A **public/private key pair** to securely sign requests.
* To complete the **installation, device, and session setup** process to authenticate your API calls.

The API uses standard REST principles and communicates via JSON. You can find setup guides and examples here:

\
[bunq API documentation](https://doc.bunq.com/)

#### What is PSD2?

PSD2 (Payment Services Directive 2) is an EU regulation designed to make electronic payments more secure and to encourage innovation in financial services. It allows **licensed third-party providers (TPPs)**—such as fintech apps or financial aggregators—to access bank account information and initiate payments on behalf of users, with their explicit consent.

In the context of the **bunq API**, PSD2 is especially relevant if you plan to:

* Access **user account information** (AIS — Account Information Services)
* Initiate **payments on a user’s behalf** (PIS — Payment Initiation Services)

If you are a licensed TPP operating under PSD2, you can integrate with bunq using a **PSD2 certificate**. This grants you direct access to user accounts in a regulated and compliant way.

Alternatively, if you're **not a licensed TPP**, but still want users to connect their bunq accounts to your app (for example, to show their balance or history), keep in mind that you might need a certification for those operations.

</details>

<details>

<summary>If you are a PSD2 provider</summary>

#### **What certificate types does bunq accept?**

We accept QSEAL certificates.

#### **How do I get an API key as a PSD2 user?**

You’ll receive a token in return to passing your QSEAL certificate. You’ll then be able to use it as an API key.

#### **What do I need to register my QSEAL certificate?**

You need to send a POST /payment-service-provider-credential request passing your QSEAL certificate, QSEAL certificate chain, and a signature of the device registration key with the QSEAL private key. Check the full authentication flow here.

#### **How does the PSD2 API request signing work?**

The request signature requirement is the same for all types of API users. You can read more about it here.

#### **How do I get an OAuth client as a PSD2 user?**

You can create an OAuth Client using `POST /user/userId/oauth-client` and read it using its id (`GET /user/userId/oauth-client/oauth-clientId`). Once you have it, you can add a redirect url using `POST /user/{userID}/oauth-client/{oauth-clientID}/callback-url`. From there, you can move to creating an authorization request and token exchange.

Check more about it here:

[OAuth](/basics/authentication/oauth.md)

#### **Where do I find the AISP, PISP and CBPIII API reference?**

bunq offers one API to both our users and companies with PSD2 permit: <https://doc.bunq.com/>. As a PSD2 party, you can only access the endpoints that correspond with your permit level.

#### **Are the AISP, PISP and CBPIII APIs the same API as I use as a bunq user?**

Yes, the only thing that differs is the authentication flow. Everything else is the same.

#### **I need help with the PSD2 API. How do I get support?**

[Our API documentation](/psd2/are-you-a-third-party-provider-tpp-start-here.md) will help you get started. If you need dedicated guidance or troubleshooting for a problem you are experiencing, you can purchase a [10-hour dedicated support package](https://www.bunq.com/assets/media/legal/en/20200805_consumers_business_pricing_EN.pdf). You can request this service at <apipartner@bunq.com>.

</details>


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/support/faq.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
