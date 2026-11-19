> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/access-end-user-acount-information-through-oauth.md).

# Access end user acount information through OAuth

### Goal of this tutorial <a href="#oauth-authentication" id="oauth-authentication"></a>

In this tutorial we'll walk you through the steps to get access to a bunq users bank account. We'll register your application, create a OAuth client and set it up in such a way so that:

* You can generate a QR code - this QR code can be used by a bunq user to connect to the app you're building
* How to set up that connection between the bunq user and your app
* Retrieve end-user information

For OAuth to work there are 3 parties involved

* The bunq user - that is likely also a user of your app
* Your app - that is trying to access information about the end users' bunq account
* bunq - which stores all the information in our database and that your app wants to access on behalf of a end user.

{% hint style="info" %}
A common example for a usecase with oauth is if your app is an accounting tool. You want to be able to read transactions on the account of the end user. Connecting through oauth helps you get this set up.
{% endhint %}

At the end of this tutorial you'll have:

* An app with oauth client
* A way to retrieve payments on behalf of other users

### What is OAuth <a href="#oauth-authentication" id="oauth-authentication"></a>

OAuth 2.0 is an industry-standard protocol that allows third-party applications to securely access bunq user accounts without exposing credentials. This method enables seamless authorization while maintaining user control over permissions.6

{% hint style="danger" %}
**Important Note** If you, as a developer, intend to access data belonging to **other bunq users** (e.g., account information, transaction history, or initiate payments on their behalf), you must ensure that you:

* ✅ **Fully comply with** [**bunq’s Terms and Conditions**](https://static.bunq.com/framer/documents/Terms-Conditions-API-EN-20200805.pdf) for API usage.
* ✅ **Obtain explicit user consent** as required.
* ⚖️ **May be subject to** [**PSD2 regulations**](https://eur-lex.europa.eu/legal-content/EN/LSU/?uri=oj:JOL_2015_337_R_0002), including registration as an AISP (Account Information Service Provider) or PISP (Payment Initiation Service Provider) with your national competent authority.

Misuse or non-compliance may lead to access being revoked or legal consequences.

### &#x20;<a href="#oauth-authentication" id="oauth-authentication"></a>

{% endhint %}

### What is next

Next up we'll get started with setting up the OAuth client.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/access-end-user-acount-information-through-oauth.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
