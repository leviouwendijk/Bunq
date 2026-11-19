> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/callbacks-webhooks.md).

# Callbacks (Webhooks)

Looking for Webhooks? You're on the right page!

Callbacks are used to send real-time notifications on the events that happen on a bunq account. To receive notifications for certain events on a bunq account, you need to create notification filters. It is possible to send the notifications to a provided URL and/or the user's phone as push notifications.

## Notification Filters

Use the `notification-filter-push` resource to create and manage push notification filters. Provide the type of events you want to receive notifications about in the `category` field.

Example request body:

```json
{
   "notification_filters":[
      {
         "category":"SCHEDULE_RESULT"
      }
   ]
}
```

Use the `notification-filter-url` resource to create and manage URL notification filters. The callback URL you provide in the `notification_target` field must use HTTPS.

Example request body:

```json
{
   "notification_filters":[
      {
         "category":"PAYMENT",
         "notification_target":"{YOUR_CALLBACK_URL}"
      }
   ]
}
```

## Callback categories

The `category` field determines which events trigger a callback. Categories are grouped below by domain.

### Payments & mutations

| Category            | Description                                                                                                                                                       |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `MUTATION`          | Any change in the balance of a monetary account. Fired for all payment-like objects (payments, requests, iDEAL, etc.). Use this to track account balance changes. |
| `PAYMENT`           | Payment created or received on a bunq account                                                                                                                     |
| `INSTANT_PAYMENT`   | Instant payment (SCT Inst) created or received                                                                                                                    |
| `PAYMENT_DELAYED`   | Payment is delayed and not yet processed                                                                                                                          |
| `PAYMENT_SUSPENDED` | Payment has been suspended                                                                                                                                        |
| `PAYMENT_UPDATED`   | Payment status has been updated                                                                                                                                   |
| `DRAFT_PAYMENT`     | Draft payment created or updated                                                                                                                                  |
| `REQUEST`           | Incoming payment request, or update on an outgoing request                                                                                                        |
| `SCHEDULE_RESULT`   | Scheduled payment has been executed                                                                                                                               |
| `SCHEDULE_STATUS`   | Scheduled payment status update or cancellation                                                                                                                   |
| `IDEAL`             | iDEAL deposit towards a bunq account                                                                                                                              |
| `SOFORT`            | SOFORT deposit towards a bunq account                                                                                                                             |

### Cards

| Category                                   | Description                                                               |
| ------------------------------------------ | ------------------------------------------------------------------------- |
| `CARD_TRANSACTION_SUCCESSFUL`              | Successful card transaction                                               |
| `CARD_TRANSACTION_FAILED`                  | Failed card transaction                                                   |
| `CARD_TRANSACTION_UPDATED`                 | Card transaction updated (e.g. amount change after pre-authorization)     |
| `CARD_TRANSACTION_REFUND`                  | Card transaction refunded                                                 |
| `CARD_TRANSACTION_TOKENIZED`               | Card transaction made via a digital wallet token (Apple Pay / Google Pay) |
| `CARD_DYNAMIC_CURRENCY_CONVERSION_WARNING` | Dynamic currency conversion (DCC) warning issued before authorization     |
| `CARD_EXPIRY`                              | Card is nearing or has reached its expiry date                            |
| `CARD_REPLACEMENT`                         | Card replacement has been initiated                                       |
| `CARD_COUNTRY_PERMISSION`                  | Card country permissions have changed                                     |
| `CARD_TOKENIZATION`                        | Card tokenization event (token created or updated)                        |
| `MASTERCARD_IDENTITY_CHECK`                | Mastercard Identity Check (3D Secure) authentication event                |

### Monetary accounts

| Category                            | Description                                       |
| ----------------------------------- | ------------------------------------------------- |
| `MONETARY_ACCOUNT_BALANCE`          | Account balance crossed a configured threshold    |
| `MONETARY_ACCOUNT_JOINT`            | Joint account event (e.g. created or updated)     |
| `CO_OWNER_INVITE`                   | Co-owner invitation sent or received              |
| `APPROVAL_REQUEST_USER`             | User-level approval request created or updated    |
| `APPROVAL_REQUEST_MONETARY_ACCOUNT` | Account-level approval request created or updated |

### Auto-payments (Whitelist)

| Category           | Description                                     |
| ------------------ | ----------------------------------------------- |
| `WHITELIST`        | Auto-payment whitelist entry created or updated |
| `WHITELIST_RESULT` | Auto-payment whitelist rule executed            |

### Tabs & bunq.me

| Category                     | Description                                            |
| ---------------------------- | ------------------------------------------------------ |
| `TAB_RESULT`                 | Tab payment received or updated                        |
| `BUNQME_TAB`                 | bunq.me Tab (open request) payment received or updated |
| `BUNQME_TAB_RESULT_INQUIRY`  | bunq.me Tab result inquiry                             |
| `BUNQME_TAB_RESULT_RESPONSE` | bunq.me Tab result response                            |

### OAuth & security

| Category | Description              |
| -------- | ------------------------ |
| `OAUTH`  | OAuth connection revoked |

## Receiving Callbacks

Callbacks for the sandbox environment will be made from different IP's at AWS.

Callbacks for the production environment will be made from `185.40.108.0/22`.

> The IP addresses might change. We will notify you in a timely fashion if such a change is planned.

## Removing callbacks

To remove callbacks for an object, send a POST request to the `notification_filters` endpoint with a JSON request body with an empty list.

```json
{
    "notification_filters": []
}
```

## Retry Mechanisms

When the execution of a callback fails (e.g. the callback server is down or the response contains an error), we try to resend it for a maximum of 5 times, with an interval of one minute between each try. If your server is not reachable by the callback after the 6th total try, the callback is not sent anymore.

## Listing of failed callbacks

After the sixth attempt of callback executing, the failed entry is stored and can be listed by UserApiKey.

```
GET /v1/user/762/notification-filter-failure
```

```json
{
    "Response": [
        {
            "NotificationFilterFailure": {
                "id": 1,
                "created": "2023-05-22 06:47:22.043906",
                "updated": "2023-05-22 06:47:22.043906",
                "category": "MUTATION",
                "event_type": "MUTATION_CREATED",
                "object_id": 1278,
                "notification_filters": [
                    {
                        "notification_delivery_method": "URL",
                        "notification_target": "https://coolbank.com/notification",
                        "category": "MUTATION"
                    },
                    {
                        "notification_delivery_method": "URL",
                        "notification_target": "https://coolbank.com/notification",
                        "category": "CARD_TRANSACTION_SUCCESSFUL"
                    }
                ]
            }
        }
    ],
    "Pagination": {
        "future_url": "/v1/user/762/notification-filter-failure?newer_id=1",
        "newer_url": null,
        "older_url": null
    }
}
```

* The `category` and `object_id` can be used to verify if the callback has failed and should be retried.
* The `id` of the `NotificationFilterFailure` object should be used to trigger the retry.

## Retry of failed callbacks

```
POST /v1/user/762/notification-filter-failure
```

```json
{
    "notification_filter_failed_ids": "1"
}
```

* Multiple ids can be given in the same field, comma separated. Maximum of 100 ids are allowed.
* Response will be empty with code 200 (OK).

## Setting up a callback

Check the callback categories above for all possible callbacks. Here we show one example API call to set up a new URL notification filter for successful card transactions:

```json
{
    "notification_filters": [
        {
            "category": "CARD_TRANSACTION_SUCCESSFUL",
            "notification_target": "https://webhook.site/994966bb-7a4c-4be3-836a-da65231b907d"
        }
    ]
}
```

## Certificate Pinning

We recommend that you use certificate pinning as an extra security measure. We will check if the certificate of the recipient server matches the pinned certificate that you provided and cancel the callback if the check fails or we detect a mismatch.

### How to set up certificate pinning

Retrieve the SSL certificate of your server using the following command:

```bash
openssl s_client -servername www.example.com -connect www.example.com:443 < /dev/null | sed -n "/-----BEGIN/,/-----END/p" > www.example.com.pem
```

POST the certificate to the `certificate-pinned` endpoint.

Once ready, every callback will be checked against the pinned certificate that you provided. Note that if the SSL certificate on your server expires or is changed, our callbacks will fail.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/callbacks-webhooks.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
