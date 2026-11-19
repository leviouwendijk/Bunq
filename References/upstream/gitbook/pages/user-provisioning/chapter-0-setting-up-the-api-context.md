> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/user-provisioning/chapter-0-setting-up-the-api-context.md).

# Chapter 0 setting up the API context

When integrating with the bunq API, security is a top priority. Instead of relying solely on API keys, bunq uses a **three-step authentication process:**

* installation,
* device registration,
* session creation

to ensure secure and controlled access. This approach prevents unauthorized use, protects sensitive financial data, and aligns with banking security standards like PSD2. Here’s how each step enhances security while keeping API access flexible and manageable.

{% hint style="info" %}
**Pro Tip: Simplify with Postman** Using our Postman examples makes API integration super easy. We've pre-filled all the requests with environment variables, streamlining the process and reducing the risk of errors. It's by far the quickest way to get a live session, to play around with until you fully commit to a integration in your own application.This setup allows you to focus more on development and less on configuration, ensuring a smoother experience

Check it out here : [Postman](/getting-started/tools/postman.md)
{% endhint %}

**Setting up the API context**

We documented the API context in the following pages

* [Creating the Installation](/tutorials/your-first-payment/creating-the-api-context/creating-the-installation.md)
* [Device Registration](/tutorials/your-first-payment/creating-the-api-context/device-registration.md)
* [Start a Session](/tutorials/your-first-payment/creating-the-api-context/start-a-session.md)

### Host URL for the API endpoints <a href="#host-url-for-the-api-endpoints" id="host-url-for-the-api-endpoints"></a>

One change for partners, compared to regular API users is the base URL. Make sure to target

* Sandbox: `https://partner-api.sandbox.bunq.com`
* Production: `https://api.partner.bunq.com`


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/user-provisioning/chapter-0-setting-up-the-api-context.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
