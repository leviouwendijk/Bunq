> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/bunq-api-objects/monetary-account.md).

# Monetary Account

The **MonetaryAccount** is the second most important object you’ll work with—it’s where the money lives. Think of it as a **bank account**, **sub-account**, or even a **pot**, depending on how you use it. Unlike wallets (which are tied directly to cards), a monetary account is always connected to a **legal owner**—a bunq user.

Most financial operations in the bunq API—like making payments or requesting money—require a `monetary-account-id`. You can retrieve it by listing all accounts under a user:\
`GET /user/{userId}/monetary-account`

#### **🏦 Types of Monetary Accounts**

Just like user types, monetary accounts come in a few flavors—each with its own endpoint to make things easier to manage:

* **MonetaryAccountBank** – classic personal or business bank accounts\
  `GET /user/{userId}/monetary-account-bank`
* **MonetaryAccountSavings** – regular or auto-savings accounts (including VAT accounts)\
  `GET /user/{userId}/monetary-account-savings`
* **MonetaryAccountJoint** – shared accounts with other bunq users (they’re also legal co-owners)\
  `GET /user/{userId}/monetary-account-joint`

Each type works slightly differently, but they all follow the same structure and principles. Once you know how to use one, the others are easy to pick up.

## Example

```json
{
    "Response": [
        {
            "MonetaryAccountBank": {
                "id": 2428053,
                "created": "2025-07-21 09:14:18.661006",
                "updated": "2025-07-21 09:14:18.661006",
                "alias": [
                    {
                        "type": "PHONE_NUMBER",
                        "value": "+31619257130",
                        "name": "+31619257130"
                    },
                    {
                        "type": "EMAIL",
                        "value": "test+41478d1b-7b9c-4d8e-9e32-860fa4cfde24@bunq.com",
                        "name": "test+41478d1b-7b9c-4d8e-9e32-860fa4cfde24@bunq.com"
                    },
                    {
                        "type": "IBAN",
                        "value": "NL51BUNQ2093937468",
                        "name": "Ayako Visser"
                    }
                ],
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
                    "anchor_uuid": "e2947f01-1ae1-4be3-a9e4-6605476ff843",
                    "style": "NONE"
                },
                "balance": {
                    "currency": "EUR",
                    "value": "0.00"
                },
                "balance_converted": {
                    "currency": "EUR",
                    "value": "0.00"
                },
                "country": "NL",
                "currency": "EUR",
                "display_name": "A. Visser",
                "daily_limit": {
                    "currency": "EUR",
                    "value": "5000.00"
                },
                "description": "Main",
                "public_uuid": "e2947f01-1ae1-4be3-a9e4-6605476ff843",
                "status": "ACTIVE",
                "sub_status": "NONE",
                "timezone": "europe/amsterdam",
                "user_id": 2040503,
                "monetary_account_profile": {
                    "profile_fill": {
                        "status": "ACTIVE",
                        "balance_preferred": {
                            "currency": "EUR",
                            "value": "100.00"
                        },
                        "balance_threshold_low": {
                            "currency": "EUR",
                            "value": "50.00"
                        }
                    },
                    "profile_drain": null,
                    "profile_action_required": "NO_ACTION_NEEDED",
                    "profile_amount_required": {
                        "currency": "EUR",
                        "value": "0.00"
                    }
                },
                "setting": {
                    "color": "#FF7819",
                    "icon": null,
                    "default_avatar_status": "AVATAR_DEFAULT",
                    "restriction_chat": "ALLOW_INCOMING",
                    "sdd_expiration_action": "AUTO_ACCEPT"
                },
                "connected_cards": [],
                "budget": [],
                "all_access": [
                    {
                        "MonetaryAccountAccess": {
                            "id": 2595530,
                            "created": "2025-07-21 09:14:18.742179",
                            "updated": "2025-07-21 09:14:18.742179",
                            "access_type": "FULL_PERMANENT"
                        }
                    }
                ],
                "overdraft_limit": {
                    "currency": "EUR",
                    "value": "0.00"
                },
                "all_auto_save_id": []
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
GET https://doc.bunq.com/basics/bunq-api-objects/monetary-account.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
