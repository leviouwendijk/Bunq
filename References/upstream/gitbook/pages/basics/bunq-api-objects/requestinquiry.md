> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/bunq-api-objects/requestinquiry.md).

# RequestInquiry

Need to ask someone to pay you? That’s where **RequestInquiry** comes in.

With bunq, you can request money from anyone—bunq user or not—as long as you have their **IBAN**, **email**, or **phone number**. If they’re not a bunq user, they’ll get an email or SMS with a link to securely complete the payment from their own bank.

The `RequestInquiry` object handles this process. Like payments, it’s tied to a **MonetaryAccount**, and you can manage it through this endpoint:\
`POST /user/{userId}/monetary-account/{monetaryAccountId}/request-inquiry`

It’s a simple way to collect payments, whether you're splitting a bill, collecting rent, or invoicing a customer—no awkward follow-ups required.

## Example

```json
{
    "Response": [
        {
            "RequestInquiry": {
                "id": 2025724,
                "created": "2025-07-21 09:16:40.680832",
                "updated": "2025-07-21 09:16:43.715527",
                "time_responded": "2025-07-21 09:16:43.715420",
                "time_expiry": null,
                "monetary_account_id": 2428053,
                "amount_inquired": {
                    "currency": "EUR",
                    "value": "4.00"
                },
                "amount_responded": {
                    "currency": "EUR",
                    "value": "4.00"
                },
                "status": "ACCEPTED",
                "description": "4 chicken nuggets",
                "merchant_reference": null,
                "user_alias_created": {
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
                "user_alias_revoked": null,
                "counterparty_alias": {
                    "iban": "NL32BUNQ2025313705",
                    "is_light": false,
                    "display_name": "S. Daddy",
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
                "minimum_age": null,
                "require_address": null,
                "geolocation": null,
                "bunqme_share_url": null,
                "redirect_url": null,
                "reference_split_the_bill": null,
                "batch_id": null,
                "scheduled_id": null,
                "address_billing": null,
                "address_shipping": null,
                "bizum_request": null
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
GET https://doc.bunq.com/basics/bunq-api-objects/requestinquiry.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
