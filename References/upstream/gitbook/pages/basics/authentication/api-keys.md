> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/authentication/api-keys.md).

# API Keys

Guard your API key carefully, as it provides access to sensitive financial information similar to actual banking details. Make sure not to commit it to your source control. If you end up doing so you can always revoke the key from your bunq app.

API Key Authentication The easiest way to authenticate with the bunq API is by using an API key. This key acts as a secret credential that identifies your application. To use an API key, you must: Obtain an API Key – Generate one from the bunq app or request a sandbox API key via POST /sandbox-user. Or grab one from your bunq app in production.

Register Your Device and starting a session – Before making API calls, your device must be registered with POST /device-server. This binds the API key to your device and its IP address. We dedicated a whole page on registering your installation, your device and starting a session here

Session Management Auto Logout: The auto-logout time set in the bunq app applies to all sessions, including API sessions.

Session Extension: If a request is made within 30 minutes of expiration, the session is automatically extended.

Get your sandbox API Key Our tutorial walks you through setting up API keys step by step, and also shows you how to do the subsequent steps.

You can get your API key for the sandbox through a Curl command. The Production API key can be taken from our App. Curl call to obtain API key To create a user and obtain an API key you can just run 1 command from your terminal: Run this command to obtain a user person. It will return just a API key, but in the background we generated a dummy user for you to play around with in the sandbox. curl --location --request POST '<https://public-api.sandbox.bunq.com/v1/sandbox-user-person>'

Run this command to obtain a business user curl --location --request POST '<https://public-api.sandbox.bunq.com/v1/sandbox-user-company>'

This request will create a new user in the system. The response will give you the API key that belongs to this user. Store it somewhere safe.

{ "Response": \[ { "ApiKey": { "api\_key": "sandbox\_a918ac413524f2bf56ceb740595e01839dd7f0321ca08e4c4ea93349" } } ] }

Getting your production API key Be aware that a production API key can be used to control your bank account and make payments on your behalf.

Go to your bunq app

In the settings screen look for the heading 'Developers'

There you select API keys

and click add an API key


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/authentication/api-keys.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
