> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/draft-payment.md).

# Draft Payment

A draft payment allows you to prepare a payment that the user must accept in the bunq app before it is executed.

Each draft payment can include details such as the amount, currency, description, and counterparty information. To streamline larger workflows, you can send up to **350 draft payments in a single request** by providing an array of draft payment objects. Like so:

```
[
  {
    "monetary_account_id": "3362415",
    "status": "PENDING",
    "amount": "10.00",
    "currency": "EUR",
    "description": "Payment 1",
    "receiver_type": "EMAIL",
    "receiver_value": "sugardaddy@bunq.com",
    "receiver_name": "Best Friend",
    "previous_updated_timestamp": "2024-05-01 12:00:00.000",
    "number_of_required_accepts": 1
  },
  {
    "monetary_account_id": "3362415",
    "status": "PENDING",
    "amount": "15.50",
    "currency": "EUR",
    "description": "Payment 2",
    "receiver_type": "EMAIL",
    "receiver_value": "sugardaddy@bunq.com",
    "receiver_name": "Alice",
    "previous_updated_timestamp": "2024-05-01 12:00:00.000",
    "number_of_required_accepts": 1
  },
  {
    "monetary_account_id": "3362415",
    "status": "PENDING",
    "amount": "15.50",
    "currency": "EUR",
    "description": "Payment 3",
    "receiver_type": "IBAN",
    "receiver_value": "NL14RABO0169202917",
    "receiver_name": "Peter",
    "previous_updated_timestamp": "2024-05-01 12:00:00.000",
    "number_of_required_accepts": 1
  }
]
```

{% hint style="info" %}
Payment Service Providers (PSPs) must use draft payments, as **PSD2 regulations prohibit them from executing payments directly** via the standard `/payments` endpoint. This ensures that every payment still requires the end user’s approval in the app. check [Payment Initiation Service Provider (PISP)](/psd2/payment-initiation-service-provider-pisp.md)for more information
{% endhint %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/draft-payment" method="post" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/draft-payment/{itemId}" method="get" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/draft-payment" method="get" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/draft-payment/{itemId}" method="put" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/draft-payment.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
