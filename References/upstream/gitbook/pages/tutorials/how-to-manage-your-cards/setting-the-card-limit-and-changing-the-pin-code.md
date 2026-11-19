> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/how-to-manage-your-cards/setting-the-card-limit-and-changing-the-pin-code.md).

# Setting the card Limit and changing the PIN code

In the last part we ordered a card that we want to lend to our friend. For this tutorial we want him to only make 1 purchase of maximum €100 and our friend can pick his own pincode.

Doing this is very simple using the PUT method on our cards endpoint.

We only have to pass the values we want to change. In our case we will chose a body like so:<br>

```json
{
    "pin_code": "1234",
    "card_limit": {
    "value": "100.00",
    "currency": "EUR"
    },
    "card_limit_atm": {
        "value": "0.00",
        "currency": "EUR"
    }
}
```

This sets our pincode to 1234 (assuming that's the code our friend wants). And we set the limit on the card to €100 , and €0 for ATM withdrawels so our friend does not grab a bunch of cash. If you want to change other values (e.g. allowed countries or the monetary account connected then we can but it's outside of the scope for this tutorial).

### Here is the the request with all parameters

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/user/{userID}/card/{itemId}" method="put" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}

## Now Let's assume our friend made his card payment, how will we know?

After our friend made his card payment we would like to revert back to our own spending limits and our own pin code. We can do this simply by redoing the API call we just did and updating the body. So

```json
{
    "pin_code": "your pin code",
    "card_limit": {
    "value": "your preferred limit",
    "currency": "EUR"
    },
    "card_limit_atm": {
        "value": "your ATM limit",
        "currency": "EUR"
    }
}
```

The issue is more, how will we know when to make that call, as in the ideal situation for this tutorial we want to make it as soon as the card payment comes in. As with everything at bunq we can do this near instant.

The crude way of doing it is by polling our payments with the GET [Payment](/payment.md)method, that returns a list of payments. There is a more sophisticated design pattern we could use which is using Callbacks. To set up callbacks we need to register a notification filter [Notification Filter](/notification-filter.md)

## Setting up a callback so we know when card transactions are made

Your app can subscribe to events that happen on the bunq API by using [Callbacks (Webhooks)](/basics/callbacks-webhooks.md). These are POST requests our server will make towards your server when an event happens.

One of the events we could listen to is `CARD_TRANSACTION_SUCCESSFUL` which will tell us about succesful card transactions. This is done by a POST request from bunq to a URL we specify (usually on our server).

To do this we can add a callback url by adding a notification filter url. And passing a body like:<br>

```json

{
    "notification_filters": [
        {"category": "CARD_TRANSACTION_SUCCESSFUL",
        "notification_target": "THE URL OF YOUR SERVER THAT WILL PROCESS THE POST REQUEST"}
    ]
}

```

This registers the URL and now bunq will call that endpoint everytime there's a successful card transaction. Your server will have to to check the `card_id`in the event to match it to the card ID that we borrowed our friend.

But if that matches you can simply make the API call that we did before, and revert to the pin\_code and card\_limits of your choice. And the card will be unusable by your friend after that.

## API Call and response for the notificiation filter

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/user/{userID}/notification-filter-url" method="post" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}

### The response of such a callback looks like this:

]

```
{
  "NotificationUrl": {
    "target_url": "https://webhook.site/994964bb-7a4c-4be3-836a-da65231b907d",
    "category": "CARD_TRANSACTION_SUCCESSFUL",
    "event_type": "CARD_PAYMENT_ALLOWED",
    "object": {
      "MasterCardAction": {
        "id": 491965,
        "created": "2025-04-09 14:14:27.584029",
        "updated": "2025-04-09 14:14:28.483979",
        "monetary_account_id": 2078790,
        "card_id": 449304,
        "card_authorisation_id_response": "FHF728",
        "amount_local": {
          "currency": "EUR",
          "value": "1.00"
        },
        "amount_converted": {
          "currency": "EUR",
          "value": "1.00"
        },
        "amount_billing": {
          "currency": "EUR",
          "value": "1.00"
        },
        "amount_original_local": {
          "currency": "EUR",
          "value": "1.00"
        },
        "amount_original_billing": {
          "currency": "EUR",
          "value": "1.00"
        },
        "amount_fee": {
          "currency": "EUR",
          "value": "0.00"
        },
        "decision": "ALLOWED",
        "payment_status": "PAYMENT_SUCCESSFUL_PENDING_SETTLEMENT",
        "decision_description": "Card transaction is successfully authorised. Your money has been reserved for the merchant to claim.",
        "decision_description_translated": "Card transaction is successfully authorized. Your money has been reserved for the merchant to claim.",
        "decision_together_url": "https://together.bunq.com/d/16793-what-does-the-status-of-my-card-payment-mean",
        "description": "CCV*KA Sloterdijk Amsterdam, NL\n",
        "authorisation_status": "AUTHORISED",
        "authorisation_type": "NORMAL_AUTHORISATION",
        "settlement_status": "OPEN",
        "clearing_status": "PENDING",
        "maturity_date": "2025-05-01",
        "city": "Amsterdam",
        "alias": {
          "iban": "NL52BUNQ2090374640",
          "is_light": false,
          "display_name": "A. Luu",
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
            "uuid": "a3f43087-9139-47ec-9453-0609afc0dbdd",
            "display_name": "A. Luu",
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
              "anchor_uuid": "a3f43087-9139-47ec-9453-0609afc0dbdd",
              "style": "EASY_GREEN"
            },
            "public_nick_name": "Ada",
            "type": "PERSON"
          },
          "country": "NL"
        },
        "counterparty_alias": {
          "iban": null,
          "is_light": null,
          "display_name": "Koffie Academie",
          "avatar": null,
          "label_user": {
            "uuid": null,
            "display_name": "Koffie Academie",
            "country": "NL",
            "avatar": null,
            "public_nick_name": "Koffie Academie",
            "type": null
          },
          "country": "NL",
          "merchant_category_code": "5411"
        },
        "label_card": {
          "uuid": "dee4bf0a-8f9c-4387-be82-db0b4d02c4d5",
          "type": "MASTERCARD",
          "second_line": "",
          "expiry_date": "2029-04-30",
          "status": "ACTIVE",
          "label_user": {
            "uuid": "a3f43087-9139-47ec-9453-0609afc0dbdd",
            "display_name": "Ada",
            "country": "000",
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
              "anchor_uuid": "a3f43087-9139-47ec-9453-0609afc0dbdd",
              "style": "EASY_GREEN"
            },
            "public_nick_name": "Ada",
            "type": "PERSON"
          },
          "label_user_owner": {
            "uuid": "a3f43087-9139-47ec-9453-0609afc0dbdd",
            "display_name": "Ada",
            "country": "000",
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
              "anchor_uuid": "a3f43087-9139-47ec-9453-0609afc0dbdd",
              "style": "EASY_GREEN"
            },
            "public_nick_name": "Ada",
            "type": "PERSON"
          },
          "label_user_holder": {
            "uuid": "a3f43087-9139-47ec-9453-0609afc0dbdd",
            "display_name": "A. Luu",
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
              "anchor_uuid": "a3f43087-9139-47ec-9453-0609afc0dbdd",
              "style": "EASY_GREEN"
            },
            "public_nick_name": "Ada",
            "type": "PERSON"
          },
          "label_primary_account_number": {
            "uuid": "d1e42007-a01e-497a-a88d-c40ca7abf154",
            "description": "",
            "last_four_digit": "8069",
            "mastercard_product": "MCS"
          }
        },
        "merchant_id": "21914428",
        "token_status": null,
        "reservation_expiry_time": null,
        "clearing_expiry_time": "2025-04-16 14:14:27.584029",
        "pan_entry_mode_user": "ICC",
        "secure_code_id": null,
        "wallet_provider_id": "420",
        "request_reference_split_the_bill": [],
        "card_tokenization_event": null,
        "all_auto_save_entry": [],
        "all_mastercard_action_refund": [],
        "applied_limit": "CARD_LIMIT_POS_ICC",
        "tree": null,
        "pos_card_presence": "0",
        "pos_card_holder_presence": "0",
        "eligible_whitelist_id": null,
        "cashback_payout_item": null,
        "point_mutation": {
          "id": 203039,
          "created": "2025-04-09 14:14:29.755610",
          "updated": "2025-04-09 14:14:29.755610",
          "number_of_point": 2
        },
        "blacklist": null,
        "transaction_dispute_available": "NONE",
        "additional_authentication_status": "NONE",
        "pin_status": "VALID_ONLINE",
        "mastercard_action_report": null,
        "merchant_category_code": "5411",
        "company_employee_card_receipt": null
      }
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
GET https://doc.bunq.com/tutorials/how-to-manage-your-cards/setting-the-card-limit-and-changing-the-pin-code.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
