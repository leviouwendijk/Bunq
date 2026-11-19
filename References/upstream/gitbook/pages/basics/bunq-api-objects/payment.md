> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/bunq-api-objects/payment.md).

# Payment

Since all money is stored in **MonetaryAccounts**, every transaction—whether sending or receiving—flows through them. The **Payment** object represents these transactions, and includes both **incoming** and **outgoing** payments. When you list a user’s payments, you’ll get the full history of both.

While you can’t control incoming payments (surprise deposits are always welcome, right?), you *can* create outgoing payments in a few different ways using the API:

#### **🚀 Types of Outgoing Payments**

All outgoing payments are based on the core `Payment` object but are handled through different endpoints depending on the type:

* **Single Payment**\
  A standard payment to one counterparty.\
  `POST /user/{userId}/monetary-account/{monetaryAccountId}/payment`
* **Payment Batch**\
  A list of payments to be sent in one go.\
  `POST /user/{userId}/monetary-account/{monetaryAccountId}/payment-batch`
* **Draft Payment**\
  A payment that needs to be reviewed and accepted by the user.\
  `POST /user/{userId}/monetary-account/{monetaryAccountId}/draft-payment`
* **Scheduled Payment**\
  A payment set to be sent in the future.\
  `POST /user/{userId}/monetary-account/{monetaryAccountId}/schedule-payment`
* **Scheduled Payment Batch**\
  Multiple scheduled payments bundled together.\
  `POST /user/{userId}/monetary-account/{monetaryAccountId}/schedule-payment-batch`

{% hint style="info" %}
🔁 *Draft scheduled payments* (recurring payments pending approval) also fall under the `DraftPayment` endpoint, depending on how you want your UX to behave.
{% endhint %}

#### **🧾 What You Need to Create a Payment**

To make any outgoing payment, you’ll need two things:

* The **amount** to send
* The **receiver** (which we call `counterparty_alias`)

You can identify the receiver using one of the following pointer types:

* `EMAIL`
* `PHONE_NUMBER`
* `IBAN`

## Example

```json
{
    "Response": [
        {
            "Payment": {
                "id": 26174613,
                "created": "2025-07-21 09:16:50.008916",
                "updated": "2025-07-21 09:16:50.008916",
                "monetary_account_id": 2428053,
                "amount": {
                    "currency": "EUR",
                    "value": "-0.10"
                },
                "payment_fee": null,
                "description": "test",
                "type": "BUNQ",
                "merchant_reference": null,
                "alias": {
                    "iban": "NL51BUNQ2093937468",
                    "is_light": false,
                    "display_name": "A. Visser",
                    "avatar": {
                        "uuid": "659e794e-f55e-4cfe-9f6d-465622cf43da",
                        "image": [
                            {
                                "attachment_public_uuid": "523b48a0-7a77-4598-9920-86f26135fef0",
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
                        "uuid": "e52b4912-c314-423a-80a4-939f4c992d14",
                        "display_name": "A. Visser",
                        "country": "NL",
                        "avatar": {
                            "uuid": "9debf55b-70b1-4d43-8d51-d6e7bd42fb5b",
                            "image": [
                                {
                                    "attachment_public_uuid": "4b7e0d1d-9167-48ac-990a-70e342c87812",
                                    "height": 126,
                                    "width": 200,
                                    "content_type": "image/jpeg",
                                    "urls": [
                                        {
                                            "type": "ORIGINAL",
                                            "url": "https://bunq-triage-model-storage-public.s3.eu-central-1.amazonaws.com/bunq_file/File/content/6979a145b7ea9ecc3459358122cb560608f02d36d4b8cd6b770f50e36aa35512.jpg"
                                        }
                                    ]
                                }
                            ],
                            "anchor_uuid": "e52b4912-c314-423a-80a4-939f4c992d14",
                            "style": "NONE"
                        },
                        "public_nick_name": "Ayako",
                        "type": "PERSON"
                    },
                    "country": "NL"
                },
                "counterparty_alias": {
                    "iban": "NL32BUNQ2025313705",
                    "is_light": false,
                    "display_name": "Sugar Daddy",
                    "avatar": {
                        "uuid": "3fada745-8305-45ab-b8c2-09cc05a51b65",
                        "image": [
                            {
                                "attachment_public_uuid": "23f17b08-9ece-4c05-8dd8-4caf2b6ef549",
                                "height": 1023,
                                "width": 1024,
                                "content_type": "image/png",
                                "urls": [
                                    {
                                        "type": "ORIGINAL",
                                        "url": "https://bunq-triage-model-storage-public.s3.eu-central-1.amazonaws.com/bunq_file/File/content/a3fa4840d155cc0f474258d10eb307f5c673eecf7f6d596a56e71c625cbd8cee.png"
                                    }
                                ]
                            }
                        ],
                        "anchor_uuid": null,
                        "style": "NONE"
                    },
                    "label_user": {
                        "uuid": "297f4374-38c5-4611-9708-71297ab56a4b",
                        "display_name": "Sugar Daddy",
                        "country": "NL",
                        "avatar": {
                            "uuid": "2971760d-ee2d-4bfb-9ea0-22cafefe85c3",
                            "image": [
                                {
                                    "attachment_public_uuid": "060a6f77-773f-4501-a071-f8b8093b9c72",
                                    "height": 480,
                                    "width": 480,
                                    "content_type": "image/jpeg",
                                    "urls": [
                                        {
                                            "type": "ORIGINAL",
                                            "url": "https://bunq-triage-model-storage-public.s3.eu-central-1.amazonaws.com/bunq_file/File/content/e68628d7e39aa9f764999abfd8fc9c0ed2667560ca05f56b5bff6e4a30e7e80c.jpg"
                                        }
                                    ]
                                }
                            ],
                            "anchor_uuid": "297f4374-38c5-4611-9708-71297ab56a4b",
                            "style": "NONE"
                        },
                        "public_nick_name": "Sugar Daddy",
                        "type": "PERSON"
                    },
                    "country": "NL"
                },
                "attachment": [],
                "geolocation": null,
                "batch_id": null,
                "scheduled_id": null,
                "address_billing": null,
                "address_shipping": null,
                "sub_type": "PAYMENT",
                "payment_arrival_expected": {
                    "status": "ARRIVED",
                    "time": null
                },
                "request_reference_split_the_bill": [],
                "balance_after_mutation": {
                    "currency": "EUR",
                    "value": "3.90"
                },
                "payment_auto_allocate_instance": null,
                "payment_suspended_outgoing": null
            }
        }
    ]
}
```


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/bunq-api-objects/payment.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
