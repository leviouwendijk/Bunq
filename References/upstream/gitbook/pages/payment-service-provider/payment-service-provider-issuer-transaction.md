> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/payment-service-provider/payment-service-provider-issuer-transaction.md).

# Payment Service Provider Issuer Transaction

The Payment Service Provider Issuer Transaction enables you to initiate a payment to any bank account of your choice. This feature is particularly useful if you want to allow bunq users to pay directly through your platform while providing a seamless, branded experience via a bunq-hosted payment portal—without relying on third-party payment providers. The typical flow works as follows: Create the payment You start by sending a POST request to the endpoint, including essential details such as the payment amount, a redirect URL, and the counterparty information. This request sets up the payment and its parameters in the bunq system.

Receive the payment ID The response will include a unique ID for the transaction. This ID allows you to retrieve the full details of the payment at any time using a GET request.

Retrieve the public UUID From the payment details response, you should capture the public\_uuid. This identifier is necessary to generate the direct link to the bunq payment portal.

Redirect your user Once you have the public\_uuid, you can redirect your users to the payment portal using the following URL structure:

For sandbox use: <https://psp.triage.bunq.com/?transactionId=\\>\<public\_uuid>

For Production <https://psp.bunq.com/?transactionId=\\>\<public\_uuid>

This portal provides a secure and user-friendly interface for completing the payment. Handle post-payment After the user completes the payment, they will be redirected to the URL you specified in the original request. You can then make another GET request to fetch the latest status and details of the payment, such as the payer information, payment status, and any other metadata.

This flow ensures that payments are both secure and easy to integrate into your platform, giving your users a smooth and reliable experience from initiation to completion.

## Transaction statuses

A transaction moves through the following statuses during its lifecycle:

| Status    | Description                                                             |
| --------- | ----------------------------------------------------------------------- |
| CREATED   | Transaction initiated by the PSP. No user interaction yet.              |
| CLAIMED   | A bunq user has opened or claimed the transaction.                      |
| ACCEPTED  | The bunq user approved the payment. This is the terminal success state. |
| REJECTED  | The user declined the payment.                                          |
| CANCELLED | The PSP cancelled the transaction before the user acted.                |
| EXPIRED   | The transaction timed out without a decision.                           |

The typical lifecycle is:

1. CREATED (after PSP creates the transaction)
2. CLAIMED (when a bunq user opens the payment portal)
3. ACCEPTED / REJECTED / CANCELLED / EXPIRED (terminal state)

Note: there is no COMPLETED status. ACCEPTED is the final state indicating the payment was approved.

This is the body you'll POST notice the expiry time

```json
{
  "counterparty_alias": {
    "type": "IBAN",
    "value": "NL52BUNQ2090374640",
    "name": "Jacob Bell"
  },
  "amount": {
    "value": "10.00",
    "currency": "EUR"
  },
  "description": "Payment description",
  "url_redirect": "https://yourapp.com/redirect",
  "time_expiry": "2025-08-15 14:07:01.397234",
  "status": "CREATED"
}

```

This is the object you'll get returned when you do the GET request

```json
{
  "Response": {
    "PaymentServiceProviderIssuerTransaction": {
      "id": 450,
      "created": "2025-08-15 13:57:11.163840",
      "updated": "2025-08-15 14:07:31.409463",
      "public_uuid": "7ee2dd93-9792-4faf-95a7-812bdf4b5961",
      "counterparty_alias": {
        "iban": "NL52BUNQ2090374640",
        "is_light": false,
        "display_name": "Jacob Bell",
        "avatar": {
          "uuid": "27234277-30d4-46c8-80cf-d975a6c6b21d",
          "image": [
            {
              "attachment_public_uuid": "60a6d2d5-5080-4c02-a2b6-52c8beeafd56",
              "height": 1023,
              "width": 1024,
              "content_type": "image/png",
              "urls": [
                {
                  "type": "ORIGINAL",
                  "url": "https://bunq-triage-model-storage-public.s3.eu-central-1.amazonaws.com/bunq_file/File/content/921ece497cd00f4e0cef3f0f63a962c31cf3f8e35311d127d5a7b23be3d074d5.png"
                }
              ]
            }
          ],
          "anchor_uuid": null,
          "style": "NONE"
        },
        "label_user": {
          "uuid": null,
          "display_name": "peter van doorn",
          "country": "NL",
          "avatar": null,
          "public_nick_name": "peter van doorn",
          "type": null
        },
        "country": "NL"
      },
      "amount": {
        "currency": "EUR",
        "value": "10.00"
      },
      "description": "Payment description",
      "url_redirect": "https://yourapp.com/redirect",
      "time_expiry": "2025-08-15 14:07:01.397234",
      "status": "EXPIRED",
      "alias": null
    }
  }
}

```


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/payment-service-provider/payment-service-provider-issuer-transaction.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
