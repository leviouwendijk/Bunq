> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/user-provisioning/chapter-4-webhooks-callbacks.md).

# Chapter 4 Webhooks / Callbacks

On top of our regular [Callbacks (Webhooks)](/basics/callbacks-webhooks.md) documentation there are some special options for User Provision users.

**NotificationUrl Object:**

| `target_url` | Your configured webhook endpoint URL                     |
| ------------ | -------------------------------------------------------- |
| `category`   | Notification category (e.g., `USER_INFORMATION_INQUIRY`) |
| `event_type` | Specific event type within the category                  |
| `object`     | The actual object that triggered the notification        |

**UserInformationInquiry Object:**

| `id`                     | Unique identifier for the inquiry                                  |
| ------------------------ | ------------------------------------------------------------------ |
| `created`                | Timestamp when the inquiry was created                             |
| `updated`                | Timestamp when the inquiry was last updated                        |
| `user_id`                | ID of the user for whom the inquiry was created                    |
| `title`                  | Title of the inquiry (e.g., "We need additional information")      |
| `subtitle`               | Subtitle explaining the inquiry purpose                            |
| `purpose`                | Purpose of the inquiry (e.g., `COMPLIANCE_TRANSACTION_MONITORING`) |
| `all_entry`              | Array of inquiry entries with specific information requests        |
| `assistant_conversation` | Conversation details for user interaction                          |

**UserInformationInquiryEntry Object:**

| `id`                     | Unique identifier for the inquiry entry                            |
| ------------------------ | ------------------------------------------------------------------ |
| `type`                   | Type of information requested (e.g., `USER_PERSON_SOURCE_OF_FUND`) |
| `status`                 | Status of the entry (e.g., `PENDING`)                              |
| `all_data_submitted`     | Array of data submitted by the user                                |
| `assistant_conversation` | Conversation context for this specific entry                       |
| `context`                | Additional context information                                     |
| `reject_reason`          | Reason for rejection (if applicable)                               |

**Webhook Body Example (`PARTNER_USER_PROVISION`):**

```json
{
  "NotificationUrl": {
    "target_url": "https://webhook.site/73fef6b5-f7ba-419b-b65f-f66199489903",
    "category": "PARTNER_USER_PROVISION",
    "event_type": "PARTNER_USER_PROVISION_PROCESS_UPDATED",
    "object": {
      "PartnerUserProvision": {
        "id": 7,
        "created": "2025-09-03 08:24:13.795007",
        "updated": "2025-09-03 08:24:14.266407",
        "external_uuid": "f8b69bdd-e2fa-4161-9ff7-f4c597f8be8e",
        "status": "ACTIVE",
        "sub_status": "NONE",
        "action_required": "NONE",
        "products": [
          "USER_ANONYMOUS_TRANSACTION_AUDIT"
        ],
        "label_user": {
          "uuid": "ae92e7da-59d6-4dcd-a99b-0109baa5aebc",
          "display_name": "New bunqer",
          "country": "NL",
          "avatar": {
            "uuid": "353e5068-1254-4422-b949-596b9f86ebeb",
            "image": [
              {
                "attachment_public_uuid": "229705c3-9d5c-424f-abc4-3f84559abd6f",
                "height": 640,
                "width": 640,
                "content_type": "image/png",
                "urls": [
                  {
                    "type": "ORIGINAL",
                    "url": "https://bunq-triage-model-storage-public.s3.eu-central-1.amazonaws.com/bunq_file/File/content/e627dab1418debb69a8ab983e7cd99a7b0cb8c289892dde90a8b2f12d5e23140.png"
                  }
                ]
              }
            ],
            "anchor_uuid": "ae92e7da-59d6-4dcd-a99b-0109baa5aebc",
            "style": "NONE"
          },
          "public_nick_name": "New bunqer",
          "type": "PERSON"
        },
        "oauth_request": {
          "uuid": "c59a2b0d-1a16-4a5e-9ad7-93f4921d5b52",
          "created": "2025-09-03 08:24:14.110949",
          "updated": "2025-09-03 08:24:14.182413",
          "oauth_client_id": 13383,
          "oauth_client_display_name": null,
          "response_type": "code",
          "callback_url": "https://yourpartner.com/oauth/callback",
          "status": "ACCEPTED",
          "state": null,
          "authorization_code": "b967643d4c76956b550553a0ebd94f1024c734d0ebaefdca00d42d1f1bfae274",
          "user_alias_created": {
            "uuid": "490f019f-6e1c-4891-b2de-da9e85a12644",
            "display_name": "Sutton Onderlinge Waarborgmaatschappij",
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
              "anchor_uuid": "490f019f-6e1c-4891-b2de-da9e85a12644",
              "style": "NONE"
            },
            "public_nick_name": "Sutton Onderlinge Waarborgmaatschappij",
            "type": "COMPANY"
          },
          "redirect_url": "https://yourpartner.com/oauth/callback?code=b967643d4c76956b550553a0ebd94f1024c734d0ebaefdca00d42d1f1bfae274",
          "type": "BUNQ"
        },
        "credential": {
          "id": 2412203,
          "created": "2025-09-03 08:24:14.178726",
          "updated": "2025-09-03 08:24:14.178726",
          "status": "PENDING_FIRST_USE",
          "expiry_time": "2025-09-03 09:24:14.178685",
          "token_value": "a0239a79b1a8d4429062bbcbdccf30cfda06eb6a2a8effc041085135e36d63d4",
          "permitted_device": null
        }
      }
    }
  }
}
```

#### Callback categories <a href="#callback-categories" id="callback-categories"></a>

Category

Description

BILLING

notifications for all bunq invoices

CARD\_TRANSACTION\_SUCCESSFUL

notifications for successful card transactions

CARD\_TRANSACTION\_FAILED

notifications for failed card transaction

CHAT

notifications for received chat messages

DRAFT\_PAYMENT

notifications for creation and updates of draft payments

IDEAL

notifications for iDEAL-deposits towards a bunq account

SOFORT

notifications for SOFORT-deposits towards a bunq account

MUTATION

notifications for any action that affects a monetary account’s balance

OAUTH

notifications for revoked OAuth connections

PAYMENT

notifications for payments created from, or received on a bunq account (doesn’t include payments that result out of paying a Request, iDEAL, Sofort or Invoice). Outgoing payments have a negative value while incoming payments have a positive value

REQUEST

notifications for incoming requests and updates on outgoing requests

SCHEDULE\_RESULT

notifications for when a scheduled payment is executed

SCHEDULE\_STATUS

notifications about the status of a scheduled payment, e.g. when the scheduled payment is updated or cancelled

SHARE

notifications for any updates or creation of Connects (ShareInviteBankInquiry)

TAB\_RESULT

notifications for updates on Tab payments

BUNQME\_TAB

notifications for updates on bunq.me Tab (open request) payments

SUPPORT

notifications for messages received from us through support chat

#### Mutation Category <a href="#mutation-category" id="mutation-category"></a>

A *Mutation* is a change in the balance of a monetary account. A *Mutation* is created for each payment-like object, such as a request, iDEAL-payment or a regular payment. Therefore, the `MUTATION`category can be used to keep track of a monetary account's balance change.

#### Receiving Callbacks <a href="#receiving-callbacks" id="receiving-callbacks"></a>

* Callbacks for the sandbox environment will be made from different IP's at AWS.
* Callbacks for the production environment will be made from 185.40.108.0/22.

*The IP addresses might change*. We will notify you in a timely fashion if such a change is planned.

#### Removing callbacks <a href="#removing-callbacks" id="removing-callbacks"></a>

To remove callbacks for an object, send a POST request to the `notification_filters` endpoint with a JSON request body with an emtpy list.

```
{
    "notification_filters": []
}
```

### Retry Mechanisms <a href="#retry-mechanisms" id="retry-mechanisms"></a>

When the execution of a callback fails (e.g. the callback server is down or the response contains an error), we try to resend it for a maximum of 5 times, with an interval of one minute between each try. If your server is not reachable by the callback after the 6th total try, the callback is not sent anymore.

#### Listing of failed callbacks <a href="#listing-of-failed-callbacks" id="listing-of-failed-callbacks"></a>

After the sixth attempt of callback executing, the failed entry is stored and can be listed by UserApiKey

```
GET
/v1/user/762/notification-filter-failure
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

\* the category & object\_id can be used to verify if the callback has failed and should be retried

\*\* the id of the NotificationFilterFailure object should be used to trigger the retry

#### Retry of failed callbacks <a href="#retry-of-failed-callbacks" id="retry-of-failed-callbacks"></a>

Copy

```
POST
/v1/user/762/notification-filter-failure
{
    "notification_filter_failed_ids": "1"
}
```

\* multiple ids can be given in the same field, comma separated. Maximum of 100 ids are allowed

\*\* response will be empty with code 200 (OK)

#### Certificate Pinning <a href="#certificate-pinning" id="certificate-pinning"></a>

We recommend that you use certificate pinning as an extra security measure. We will check if the certificate of the recipient server matches the pinned certificate that you provided and cancel the callback if the check fails or we detect a mismatch.

#### How to set up certificate pinning <a href="#how-to-set-up-certificate-pinning" id="how-to-set-up-certificate-pinning"></a>

1. Retrieve the SSL certificate of your server using the following command:

   `openssl s_client -servername www.example.com -connect www.example.com:443 < /dev/null | sed -n "/-----BEGIN/,/-----END/p" > www.example.com.pem`
2. `POST` the certificate to the `certificate-pinned`endpoint.

Once ready, every callback will be checked against the pinned certificate that you provided. Note that if the SSL certificate on your server expires or is changed, our callbacks will fail.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/user-provisioning/chapter-4-webhooks-callbacks.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
