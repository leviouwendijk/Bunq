> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/your-first-payment/creating-a-sandbox-user-and-getting-an-api-key.md).

# Creating a sandbox user and getting an API key

## Creating a sandbox user

In order to use the bunq API you'll need a bunq user. While you are building and testing you don't want to use your own bunq account, as this contains your money, and mistakes have real consequences. To give you maximum flexibility we give you the option to generate a sandbox user.

A sandbox user behaves in very much the same way as your own bunq account. So when you generate one, your user will have a name place of birth, phone number and all other information that belongs to a bank account. From there you can use this user to build and test your app. If something ever goes wrong, you can simply generate a new user.

You can log into an app of your sandbox user [Sandbox version of the bunq app](/tutorials/your-first-payment/setting-up-a-sandbox-user/sandbox-version-of-the-bunq-app.md) and also get (fake) money on the sandbox bank account that belongs to your user [Getting sandbox money on the user account](/tutorials/your-first-payment/setting-up-a-sandbox-user/getting-sandbox-money-on-the-user-account.md). When you are ready to start using your app with real money you can start [Moving to production](/basics/moving-to-production.md).

It's good to know there are 2 types of users you can generate. One is user-person and the other is user-company. The difference is that a user person represents a bank account for an individual. User Company creates a business bank account.

## Sandbox API Keys

An API key is a unique identifier that grants access to our services and is linked to a specific user account. **Think of it like a key to your bank account**—keep it secure to prevent unauthorized access to your data and transactions.

For development and testing, we offer **sandbox users**, which simulate real accounts, including balances, cards, and payment capabilities. This allows you to test and integrate your system safely without impacting live data. You can find more details on how to create and use a sandbox user here.

{% hint style="danger" %}
**DO NOT** commit your API key into your source control provider (Github/Gitlab/etc).

If you end up doing so you can always revoke the key from your bunq app, or generate a new user here.
{% endhint %}

### Create a sandbox user

To create a user and obtain an API key you can just run 1 command from your terminal:

Run this command to obtain a user person. It will return just a API key, but in the background we generated a dummy user for you to play around with in the sandbox.

```bash
curl --location --request POST 'https://public-api.sandbox.bunq.com/v1/sandbox-user-person'
```

Run this command to obtain a business user

```bash
curl --location --request POST 'https://public-api.sandbox.bunq.com/v1/sandbox-user-company'
```

This request will create a new user in the system. The response will give you the API key that belongs to this user. Store it somewhere safe.

```json

{
    "Response": [
        {
            "ApiKey": {
                "api_key": "sandbox_a918ac413524f2bf56ceb740595e01839dd7f0321ca08e4c4ea93349"
            }
        }
    ]
}
```

## Code samples

#### Creating a user-person:

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/master/swagger.json>" path="/sandbox-user-person" method="post" %}
<https://raw.githubusercontent.com/bunq/doc/master/swagger.json>
{% endopenapi %}

#### Creating a user-company:

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/master/swagger.json>" path="/sandbox-user-company" method="post" %}
<https://raw.githubusercontent.com/bunq/doc/master/swagger.json>
{% endopenapi %}

### What's next

We can almost start making calls with this API key we now have. However because of PSD2 and security reasons we first will need to register a Installation and device. Once we have those we will get a session and our user details.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/your-first-payment/creating-a-sandbox-user-and-getting-an-api-key.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
