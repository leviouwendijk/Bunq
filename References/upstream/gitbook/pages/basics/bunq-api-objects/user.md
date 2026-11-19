> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/bunq-api-objects/user.md).

# User

At bunq, everything revolves around the **User**—it's the foundation of our app, services, and API. That’s why almost every endpoint you’ll use starts with `/user`.

There are **three types of users**, each with its own endpoints, permissions, and properties:

* **`user-person`** – for individual users (`/user-person`)
* **`user-company`** – for business users (`/user-company`)
* **`user-payment-service-provider`** – for PSD2-certified third-party providers (`/user-payment-service-provider`)

The general `/user` endpoint acts as a smart wrapper over all these types. So when you make a `GET /user` request after opening a session, you’ll receive your specific user ID and type—this is usually one of the first steps in any integration.

#### **👤 `user-person` and `user-company`**

These are regular bunq users with subscriptions. If you're a bunq customer, you'll fall into one of these categories. As a user, you can:

* Create **monetary accounts** (our term for bank accounts)
* Order **cards**
* Make and receive **payments**

These objects work together and have subtypes, which we’ll explain in the next sections.

#### **🏦 `user-payment-service-provider`**

This type of user is for companies certified under **PSD2** regulations. When a company registers a valid **eIDAS certificate**, we create a `user-payment-service-provider` account and return an API key.

These users:

* **Don’t have access to the bunq app**
* Can only operate via the API
* Can act **on behalf of bunq users**, within the scope of their PSD2 role:
  * AISP (Account Information Service Provider)
  * PISP (Payment Initiation Service Provider)
  * CBPII (Card-Based Payment Instrument Issuer)

## Example:

```
{
    "Response": [
        {
            "UserPerson": {
                "id": 2040503,
                "created": "2025-07-21 09:14:18.001154",
                "updated": "2025-07-21 09:14:18.048752",
                "status": "ACTIVE",
                "sub_status": "NONE",
                "public_uuid": "e52b4912-c314-423a-80a4-939f4c992d14",
                "display_name": "A. Visser",
                "public_nick_name": "Ayako",
                "language": "en_US",
                "region": "en_US",
                "session_timeout": 604800,
                "daily_limit_without_confirmation_login": {
                    "currency": "EUR",
                    "value": "250.00"
                },
                "relations": [],
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
                    }
                ],
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
                "tax_resident": null,
                "notification_filters": [
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BADGE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BANK_SWITCH_SERVICE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BANK_SWITCH_SERVICE_PAYMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BILLING"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BUNQME_TAB"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BUNQME_FUNDRAISER"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD_TRANSACTION_FAILED"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD_TRANSACTION_SUCCESSFUL"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CHAT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CO_OWNER_INVITE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "DRAFT_PAYMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "FEATURE_ANNOUNCEMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "FRIEND_SIGN_UP"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "PACK"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "IDEAL"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SOFORT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "INVITE_USER"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "MONETARY_ACCOUNT_JOINT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "MONETARY_ACCOUNT_PROFILE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "MUTATION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "PAYMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "PROMOTION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "REQUEST"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SCHEDULE_RESULT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SCHEDULE_STATUS"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SHARE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SUPPORT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "TAB_RESULT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "TAX_IDENTIFICATION_NUMBER_WARNING"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "USE_RESPONSE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "USE_RESPONSE_NATIVE_COMMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "USE_RESPONSE_NATIVE_TOPIC"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "USER_APPROVAL"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "WHITELIST"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "WHITELIST_RESULT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SLICE_BADGE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SLICE_CHAT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SLICE_REGISTRY_ENTRY"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SLICE_REGISTRY_MEMBERSHIP"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SLICE_REGISTRY_SETTLEMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "EXPERIENCE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "ACHIEVEMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "DIRECTOR"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "POPUP_NOTIFICATION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SUBSCRIPTION_TRIAL"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "FLARUM"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "REMINDER_REQUEST"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "INSTANT_PAYMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "PREMIUM_LIMITED"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD_TRANSACTION_UPDATED"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "REFERRAL"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "REWARD"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SELECT_USER"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "INTEREST"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "REMINDER_USER_IDENTIFICATION_VERIFICATION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "JOINT_MEMBERSHIP"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "RISK_INFORMATION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CHECKOUT_MERCHANT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BARZAHLEN"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "LOCATION_EVENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "TREE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD_TRANSACTION_REFUND"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "USER_REVIEW"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD_DYNAMIC_CURRENCY_CONVERSION_WARNING"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BANCONTACT_MERCHANT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "TRIBE_GREEN"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "TRIBE_RANK_GREEN"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "GREEN_O_METER"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD_TRANSACTION_TOKENIZED"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "MONETARY_ACCOUNT_BALANCE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SUPPORT_ANNOUNCEMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "GIROPAY_MERCHANT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "OAUTH"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "RELATION_USER_REQUEST"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "TRIBE_COMMON_GOAL"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "FULFILLMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "INVITE_REFERRAL_STREAK"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "OPEN_BANKING"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD_EXPIRY"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SAVINGS_BUDGET_WARNING"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "IDIN"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SECURE_CODE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "TRANSIT_TRIP"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "FEATURE_SUGGESTION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "USER_RECORDING"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "USER_IMPERSONATION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "INSIGHT_SUBSCRIPTION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SUBSCRIPTION_SWITCH"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "MASTERCARD_IDENTITY_CHECK"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "PAYSAFECASH"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SAVINGS_SMART_SAVE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SAVINGS_AUTO_ROUTE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BUNQME_TAB_RESULT_INQUIRY"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BUNQME_TAB_RESULT_RESPONSE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "TRANSLINK"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "PAYMENT_INVESTIGATION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD_REPLACEMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "MARKETING_COMMUNICATION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "JACKPOT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "JACKPOT_INVITE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "INCIDENT_USER_COMMUNICATION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "RELATION_USER_SUGGESTION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "DEBT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "WHEEL_OF_FORTUNE_PRIZE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CASHBACK"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CONTACT_PHONEBOOK_SIGNUP"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "REGISTRY_FEED"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "PAYDAY"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD_TOKENIZATION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD_TRANSACTION_AMOUNT_UPDATED"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "ADYEN_MERCHANT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "ADYEN_CARD_TRANSACTION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "USER_VISITED_DEVICE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "PAYMENT_DELAYED"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "TRAVEL_INSURANCE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "PAYMENT_SUSPENDED"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "USER_SETTING_PAYMENT_SUSPENDED"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "PAYMENT_UPDATED"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CREDIT_LINE_OFFER"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CREDIT_LINE_REPAYMENT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "REMINDER_WHEEL_OF_FORTUNE"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "GINMON_ACCOUNT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "GINMON_TRANSACTION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "DEBT_PREVENTION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "USER_MINOR_MATURITY"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "POINT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "POINT_SUMMARY"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "GINMON_ACCOUNT_VALUATION_WEEKLY"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "USER_INFORMATION_INQUIRY"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BIZUM_TRANSACTION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "BIZUM_REQUEST"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "ASSISTANT_CONVERSATION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "CARD_PERSONALIZATION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SIM_VIRTUAL"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "ASSISTANT_ACTION_SUGGESTION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "KRAKEN_TRANSACTION"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "KRAKEN_ASSET_ALERT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "KRAKEN_ACCOUNT"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "COMPANY_EMPLOYEE_CARD"
                    },
                    {
                        "notification_delivery_method": "PUSH",
                        "category": "SIM_VIRTUAL_PRODUCT_ORDER"
                    }
                ],
                "address_main": {
                    "street": "Doyle Close",
                    "house_number": "638",
                    "postal_code": "5269 FF",
                    "city": "Almere",
                    "country": "NL",
                    "province": null,
                    "extra": null,
                    "mailbox_name": null,
                    "is_user_address_updated": false,
                    "id": 12105450,
                    "created": "2025-07-21 09:14:18.307804",
                    "updated": "2025-07-21 09:14:18.307804"
                },
                "address_postal": {
                    "street": "Doyle Close",
                    "house_number": "638",
                    "postal_code": "5269 FF",
                    "city": "Almere",
                    "country": "NL",
                    "province": null,
                    "extra": null,
                    "mailbox_name": "Valentin Mitchell",
                    "is_user_address_updated": false,
                    "id": 12105451,
                    "created": "2025-07-21 09:14:18.318763",
                    "updated": "2025-07-21 09:14:18.318763"
                },
                "address_shipping": null,
                "first_name": "Ayako",
                "middle_name": "",
                "last_name": "Visser",
                "legal_name": "Ayako Visser",
                "date_of_birth": "1987-01-15",
                "place_of_birth": "Almere",
                "country_of_birth": "NL",
                "nationality": "NL",
                "all_nationality": [
                    "NL"
                ],
                "gender": "FEMALE",
                "version_terms_of_service": "1",
                "deny_reason": null,
                "document_issuing_authority": null,
                "document_expiry_date": "2035-07-21 00:00:00.000000",
                "document_status": "ACTIVE",
                "is_primary_document": true,
                "customer": {
                    "id": 1748581,
                    "created": "2025-07-21 09:14:18.907612",
                    "updated": "2025-07-21 09:14:18.907612",
                    "billing_account_id": 2428053,
                    "invoice_notification_preference": "NONE"
                },
                "customer_limit": {
                    "limit_monetary_account": 25,
                    "limit_monetary_account_remaining": 25,
                    "limit_card_debit_maestro": 1,
                    "limit_card_debit_mastercard": 2,
                    "limit_card_wildcard": 3,
                    "limit_card_debit_wildcard": 3,
                    "limit_card_debit_maestro_virtual_subscription": 5,
                    "limit_card_debit_maestro_virtual_total": 0,
                    "limit_card_debit_mastercard_virtual_subscription": 5,
                    "limit_card_debit_mastercard_virtual_total": 0,
                    "limit_card_replacement": 1,
                    "limit_amount_monthly": null,
                    "spent_amount_monthly": null,
                    "limit_card_credit_mastercard": 1
                },
                "billing_contract": [
                    {
                        "BillingContractSubscription": {
                            "id": 19330950,
                            "created": "2025-07-21 09:14:18.333150",
                            "updated": "2025-07-21 09:14:18.333150",
                            "contract_date_start": "2025-07-21",
                            "contract_date_end": null,
                            "contract_version": 1,
                            "subscription_type": "PERSON_PREMIUM_V1",
                            "subscription_type_downgrade": null,
                            "status": "ACTIVE",
                            "sub_status": "NONE"
                        }
                    }
                ],
                "pack_membership": null,
                "premium_trial": null
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
GET https://doc.bunq.com/basics/bunq-api-objects/user.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
