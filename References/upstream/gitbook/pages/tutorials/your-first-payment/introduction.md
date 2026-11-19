> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/your-first-payment/introduction.md).

# Introduction

### What You'll Learn in this tutorial

In this tutorial, we'll walk through the process of making a payment using the bunq API. Including obtaining the API key, getting sandbox money and making your first call.

* **Phase: Orientation**
  * Determine if you have the skills and tools needed for the task.
  * Explore resources like Tinker, SDKs, and Postman.
* **Phase: Obtain Your API Key**
  * Secure your API key to start interacting with the bunq API.
* **Phase: Setting Up Your Sandbox User**
  * Learn to set up a sandbox user and understand your user object.
  * Obtain sandbox money for testing transactions.
  * Refresh your API session efficiently from your script.
  * Set up a device with the bunq app to verify your operations.
* **Phase: List Your Stuff**
  * Make GET requests to list monetary accounts, cards, and transactions.
* **Phase: Payments**

  * Execute POST requests to make payments, drafts, and requests.
  * Transition to production and explore more advanced endpoints.

  By following these steps, you will gain practical experience with the bunq API and be prepared to handle real-world banking operations through your application.

### What You'll Need

Before you begin, ensure you have the following:

* A bunq account to access the API.
* Basic programming knowledge and understanding of HTTP requests.
* Familiarity with tools like Postman for testing API calls.

### What is next

Up next we'll generate a sandbox user and obtaining a API key


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/your-first-payment/introduction.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
