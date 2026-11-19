> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/bunq-api-objects/card.md).

# Card

Cards are an essential part of the bunq experience—and just like everything else, each **Card** is directly linked to a **User**.

Every card must be connected to a **MonetaryAccount**, since that’s where the money comes from (and goes to). A single monetary account can be linked to multiple cards, but each card can only have **one primary account**. If there aren't enough funds in the primary account, bunq will check the **secondary account** (if set). If both are empty, the transaction will fail.

Cards also play a key role in **2-factor authentication**, using the user’s PIN to authorize payments. These card payments are stored as regular `Payment` records and can be viewed via:\
`GET /user/{userId}/monetary-account/{monetaryAccountId}/payment`

Want to see card-specific transaction details? You’ll need to query the `MasterCardAction` endpoint:\
`GET /user/{userId}/monetary-account/{monetaryAccountId}/mastercard-action`

## Example

```json
{
    "Response": [
        {
            "CardDebit": {
                "id": 475280,
                "created": "2025-07-21 09:21:53.715669",
                "updated": "2025-07-21 09:21:53.715669",
                "public_uuid": "c82f6de1-ff18-4f98-944e-d83e31b08c1f",
                "first_line": "",
                "second_line": "",
                "expiry_date": "2029-08-31",
                "status": "DEACTIVATED",
                "sub_status": "NONE",
                "order_status": "NEW_CARD_REQUEST_RECEIVED",
                "type": "MASTERCARD",
                "sub_type": "NONE",
                "product_type": "MASTERCARD_DEBIT",
                "product_sub_type": "NONE",
                "user_id": 2040503,
                "user_owner_id": 2040503,
                "user_holder_id": 2040503,
                "name_on_card": "A. Visser",
                "preferred_name_on_card": null,
                "card_limit": {
                    "currency": "EUR",
                    "value": "1000.00"
                },
                "card_limit_atm": {
                    "currency": "EUR",
                    "value": "1000.00"
                },
                "pin_code_assignment": [
                    {
                        "id": 476550,
                        "created": "2025-07-21 09:21:57.166688",
                        "updated": "2025-07-21 09:21:57.166688",
                        "type": "PRIMARY",
                        "monetary_account_id": 2428053,
                        "status": "ACTIVE",
                        "routing_type": "AUTOMATIC"
                    }
                ],
                "country": "NL",
                "country_permission": [
                    {
                        "country": "AT"
                    },
                    {
                        "country": "BE"
                    },
                    {
                        "country": "BG"
                    },
                    {
                        "country": "HR"
                    },
                    {
                        "country": "CY"
                    },
                    {
                        "country": "CZ"
                    },
                    {
                        "country": "DK"
                    },
                    {
                        "country": "EE"
                    },
                    {
                        "country": "FI"
                    },
                    {
                        "country": "GF"
                    },
                    {
                        "country": "FR"
                    },
                    {
                        "country": "DE"
                    },
                    {
                        "country": "GI"
                    },
                    {
                        "country": "GR"
                    },
                    {
                        "country": "GP"
                    },
                    {
                        "country": "HU"
                    },
                    {
                        "country": "IE"
                    },
                    {
                        "country": "IT"
                    },
                    {
                        "country": "LV"
                    },
                    {
                        "country": "LT"
                    },
                    {
                        "country": "LU"
                    },
                    {
                        "country": "MT"
                    },
                    {
                        "country": "NL"
                    },
                    {
                        "country": "PL"
                    },
                    {
                        "country": "PT"
                    },
                    {
                        "country": "RO"
                    },
                    {
                        "country": "SK"
                    },
                    {
                        "country": "SI"
                    },
                    {
                        "country": "ES"
                    },
                    {
                        "country": "SE"
                    },
                    {
                        "country": "AD"
                    },
                    {
                        "country": "AL"
                    },
                    {
                        "country": "AM"
                    },
                    {
                        "country": "AZ"
                    },
                    {
                        "country": "BA"
                    },
                    {
                        "country": "BY"
                    },
                    {
                        "country": "CH"
                    },
                    {
                        "country": "GB"
                    },
                    {
                        "country": "GE"
                    },
                    {
                        "country": "IS"
                    },
                    {
                        "country": "LI"
                    },
                    {
                        "country": "MC"
                    },
                    {
                        "country": "MD"
                    },
                    {
                        "country": "ME"
                    },
                    {
                        "country": "MK"
                    },
                    {
                        "country": "NO"
                    },
                    {
                        "country": "RS"
                    },
                    {
                        "country": "SM"
                    },
                    {
                        "country": "UA"
                    },
                    {
                        "country": "US"
                    },
                    {
                        "country": "VA"
                    }
                ],
                "label_monetary_account_ordered": {
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
                "label_monetary_account_current": {
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
                "monetary_account": null,
                "primary_account_numbers": [
                    {
                        "id": 478304,
                        "uuid": "078374fd-6a2b-4978-b291-1e246142b45d",
                        "description": "",
                        "four_digit": "6584",
                        "type": "CARD_MASTERCARD_DEBIT"
                    }
                ],
                "payment_account_reference": null,
                "monetary_account_id_fallback": null,
                "card_shipment_tracking_url": null,
                "is_card_eligible_for_free_replacement": true,
                "card_replacement": null,
                "is_limited_edition": false,
                "card_metal_member_since_date": null,
                "company_employee_card": null,
                "card_generated_cvc2": {
                    "CardGeneratedCvc2": {
                        "id": 373278,
                        "created": "2025-07-21 09:21:57.556343",
                        "updated": "2025-07-21 09:21:57.556343",
                        "cvc2": "582",
                        "status": "AVAILABLE",
                        "expiry_time": null,
                        "type": "STATIC"
                    }
                }
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
GET https://doc.bunq.com/basics/bunq-api-objects/card.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
