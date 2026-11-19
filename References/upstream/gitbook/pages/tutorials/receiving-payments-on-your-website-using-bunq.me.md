> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/receiving-payments-on-your-website-using-bunq.me.md).

# Receiving payments on your website using bunq.me

Imagine you're running a charity and want to collect donations directly through your website. After someone donates, you'd like to redirect them to a custom "Thank You" page— to show appreciation, share what their donation supports, or even offer a downloadable gift or receipt.

In this tutorial, you’ll learn how to use the bunq API to:

* Create a payment link you can share or embed on your site
* Add a redirect URL that sends users to a confirmation or thank-you page after payment
* Make the experience smooth, branded, and personal

This works great for charities, event registrations, fundraising campaigns, or any situation where you want to acknowledge someone after they’ve completed a payment.

Let’s dive in and build a seamless donation flow with a touch of gratitude 💚

***

## Let's create a link that we can embed in our own website

In order to create a custom link we'll need the bunq.me-tab endpoints. This allows you to create a payment request and embed the link on your site.

## We start by creating a bunq.me tab

We post the following body. Note that you can set a redirect URL to your own thank you page. You can use this can also be used to add url parameters, for example a user id so you can retrieve the user in your own database. For this example we'll just redirect to the bunq homepage

```json

{
  "bunqme_tab_entry": {
    "amount_inquired": {
      "value": "10.00",
      "currency": "EUR"
    },
    "description": "Donation",
    "redirect_url": "https://bunq.com"
  },
  "status": "string",
  "event_id": 0
}

```

This returns us a simple response with the ID of our new bunq.me tab

```json

{
    "Response": [
        {
            "Id": {
                "id": 7567
            }
        }
    ]
}
```

## API call

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-tab" method="post" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}

## So we created the tab, but what is the URL we can send our user to?

We'll need to make a second API call in order to retrieve all data. This one is simply a get request using the ID that we got from our POST message (see below. It returns us a object with one key called `bunq-me-tab-share-url`

This url is what you can add to your website. For instance on a button that says 'donate now' or 'go to checkout'.

When the user clicks on that link they will be send to a payment portal. That looks like this. The URL expires in 20 minutes and once the user pays they will be redirected to the redirect URL that we provided.

<figure><img src="https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-cd9256ac55de5364a6eaebdccbc7e19189c4aa45%2FScreenshot%202025-04-09%20at%2017.50.16.png?alt=media" alt=""><figcaption></figcaption></figure>

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-tab/{itemId}" method="get" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}

## Example response that shows the bunqme\_tab\_share\_url

```json

{
    "Response": [
        {
            "BunqMeTab": {
                "id": 7602,
                "created": "2025-04-16 11:34:47.843460",
                "updated": "2025-04-16 11:34:47.843460",
                "time_expiry": "2025-05-16 11:34:47.843107",
                "monetary_account_id": 2079522,
                "status": "WAITING_FOR_PAYMENT",
                "type": "BUNQ_ME",
                "alias_monetary_account": {
                    "iban": "NL53BUNQ2090359587",
                    "is_light": false,
                    "display_name": "N. Carter",
                    "avatar": {...},
                    "label_user": {... },
                "bunqme_tab_share_url": "https://bunqme.triage.bunq.net/o/6kwsisQcpUD4hWaBZUnuW4",
                "bunqme_tab_entry": {
                    "uuid": "de05a8a3-3257-4e73-a004-af3638251e5c",
                    "created": "2025-04-16 11:34:47.887847",
                    "updated": "2025-04-16 11:34:47.887847",
                    "amount_inquired": {
                        "currency": "EUR",
                        "value": "1.00"
                    },
                    "status": "WAITING_FOR_PAYMENT",
                    "description": "Donation",
                    "alias": {
                        "iban": "NL53BUNQ2090359587",
                        "is_light": false,
                        "display_name": "N. Carter",
                        "avatar": {
                            "uuid": "419bbe21-52d7-4037-8787-a57e4c649049",
                            "image": [
                                {
                                    "attachment_public_uuid": "ef1a52ce-6b3a-4357-b716-de91948b831d",
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
                            "uuid": "5f33833d-f416-428b-a654-d3b25bb3bc9d",
                            "display_name": "N. Carter",
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
                                "anchor_uuid": "5f33833d-f416-428b-a654-d3b25bb3bc9d",
                                "style": "NONE"
                            },
                            "public_nick_name": "Nicola",
                            "type": "PERSON"
                        },
                        "country": "NL"
                    },
                    "redirect_url": "https://bunq.com",
                    "merchant_available": [
                        {
                            "merchant_type": "IDEAL",
                            "available": true
                        },
                        {
                            "merchant_type": "SOFORT",
                            "available": true
                        },
                        {
                            "merchant_type": "CHECKOUT",
                            "available": true
                        },
                        {
                            "merchant_type": "BANCONTACT",
                            "available": true
                        },
                        {
                            "merchant_type": "BUNQ",
                            "available": true
                        }
                    ],
                    "invite_profile_name": "NicolaLilacGorilla"
                },
                "bunqme_tab_entries": [
                    {
                        "id": 7479,
                        "created": "2025-04-16 11:34:47.887847",
                        "updated": "2025-04-16 11:34:47.887847",
                        "amount_inquired": {
                            "currency": "EUR",
                            "value": "1.00"
                        },
                        "status": "WAITING_FOR_PAYMENT",
                        "description": "Donation",
                        "alias": {
                            "iban": "NL53BUNQ2090359587",
                            "is_light": false,
                            "display_name": "N. Carter",
                            "avatar": {
                                "uuid": "419bbe21-52d7-4037-8787-a57e4c649049",
                                "image": [
                                    {
                                        "attachment_public_uuid": "ef1a52ce-6b3a-4357-b716-de91948b831d",
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
                                "uuid": "5f33833d-f416-428b-a654-d3b25bb3bc9d",
                                "display_name": "N. Carter",
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
                                    "anchor_uuid": "5f33833d-f416-428b-a654-d3b25bb3bc9d",
                                    "style": "NONE"
                                },
                                "public_nick_name": "Nicola",
                                "type": "PERSON"
                            },
                            "country": "NL"
                        },
                        "redirect_url": "https://bunq.com"
                    }
                ],
                "result_inquiries": []
            }
        }
    ]
}




```

As we can see our URL Will be: "<https://bunqme.triage.bunq.net/o/6kwsisQcpUD4hWaBZUnuW4>", So we can add that to our own webpage. Sending the user to that page brings them to this page where they can make their payment.

{% hint style="warning" %}

## Be aware the URL to your tab eventually expires

It's good to know that bunq.me-tab links eventually expire. The bunqmetab object has a property **time\_expiry** that tells you when.

```json
{
    "Response": [
        {
            "BunqMeTab": {
                "id": 7602,
                "created": "2025-04-16 11:34:47.843460",
                "updated": "2025-04-16 11:40:34.412358",
                "time_expiry": "2025-05-16 11:34:47.843107",
                other properties...
                },
        }]
```

```json
}


```

{% endhint %}

## The Redirect to your thank you page

This is already set up. When you made the initial POST request to set up your bunq.me tab you added a redirect\_url and you can see it in the response. So when the user pays, they will be automatically forwarded to bunq.com which I specified in the initial POST request.

{% hint style="success" %}
If you want to retrieve the user of **your** system to the thank you page (or any redirect page for that matter) then you may want to construct a bunqme-tab for each individual user. Let's assume your system keeps track of a userid then you could construct a redirect URL like so:

* <https://redirecturl.com/checkout\\_completed/{userid\\_of\\_your\\_user}>
* This allows you to retrieve the userdetails from your database and enable a subscription, or send them an email as a result.
  {% endhint %}

## How do I get a list of payments?

If you wonder how you got paid they you can always check the payments in your monetary account. But there is a much easier way. Simply by doing another GET request on the /bunqme-tab endpoint gets you the object that we already showed above.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/receiving-payments-on-your-website-using-bunq.me.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
