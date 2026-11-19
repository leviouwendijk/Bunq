> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/user-provisioning/chapter-3-onboarding/creating-user-onboarding.md).

# Creating User Onboarding

**Endpoint:**

```http
POST /v1/user/{user_api_key_id}/user-onboarding
{
    "type": "PARTNER_USER"
}
```

**Response:**

<pre class="language-json"><code class="lang-json"><strong>{
</strong>    "Response": [
        {
            "Id": {
                "id": 260
            }
        }
    ]
}
</code></pre>

Now the provisioned user has an Onboarding model which can be updated to be completed.

## Step 2: Update Onboarding model

The response to this endpoint gives you all the information you have to provide to have a verified and active user. All the fulfillments should be completed before the user is fully verified and can create Monetary Accounts, Cards, Payments etc.

**Endpoint:**

```http
PUT /v1/user/{user_api_key_id}/user-onboarding/{user_onboarding_id}
```

*The* `user_api_key_id` *is obtained from the ID of the* `UserApiKey` *object when creating a session on behalf of the user.*

**Request body:**

```json
{
    "user_status_desired": "ACTIVE",
    "user_verification_status_desired": "VERIFIED"
}
```

**Response:**

```json
{
    "Error": [
        {
            "error_description": "You need to provide additional information in order to perform this action.",
            "error_description_translated": "You need to provide additional information in order to perform this action.",
            "error_additional_parameter": [
                {
                    "AdditionalFulfillmentParameter": {
                        "all_fulfillment": [
                            {
                                "type": "ADDRESS_MAIN",
                                "reason": "",
                                "reason_translated": "",
                                "user_id": 877,
                                "status": null,
                                "time_mandatory": null,
                                "all_status_allowed": [
                                    "FULFILLED"
                                ],
                                "id": null,
                                "created_timestamp": null,
                                "updated_timestamp": null
                            },
                            {
                                "type": "DATE_OF_BIRTH",
                                "reason": "Let's make this account truly yours.",
                                "reason_translated": "Let's make this account truly yours.",
                                "user_id": 877,
                                "status": null,
                                "time_mandatory": null,
                                "all_status_allowed": [
                                    "FULFILLED"
                                ],
                                "id": null,
                                "created_timestamp": null,
                                "updated_timestamp": null
                            },
                            {
                                "type": "EMAIL",
                                "reason": "Get notified instantly on important matters.",
                                "reason_translated": "Get notified instantly on important matters.",
                                "user_id": 877,
                                "status": null,
                                "time_mandatory": null,
                                "all_status_allowed": [
                                    "FULFILLED",
                                    "IN_PROGRESS"
                                ],
                                "id": null,
                                "created_timestamp": null,
                                "updated_timestamp": null
                            },
                            {
                                "type": "ADDRESS_MAIN",
                                "reason": "",
                                "reason_translated": "",
                                "user_id": 877,
                                "status": null,
                                "time_mandatory": null,
                                "all_status_allowed": [
                                    "FULFILLED"
                                ],
                                "id": null,
                                "created_timestamp": null,
                                "updated_timestamp": null
                            },
                            {
                                "type": "ADDRESS_POSTAL",
                                "reason": "So we know where to send your card.",
                                "reason_translated": "So we know where to send your card.",
                                "user_id": 877,
                                "status": null,
                                "time_mandatory": null,
                                "all_status_allowed": [
                                    "FULFILLED"
                                ],
                                "id": null,
                                "created_timestamp": null,
                                "updated_timestamp": null
                            },
                            {
                                "type": "IDENTIFICATION_VERIFICATION",
                                "reason": "It takes just a few seconds to take a picture and complete your account.",
                                "reason_translated": "It takes just a few seconds to take a picture and complete your account.",
                                "user_id": 877,
                                "status": null,
                                "time_mandatory": null,
                                "all_status_allowed": [
                                    "FULFILLED",
                                    "IN_PROGRESS"
                                ],
                                "id": null,
                                "created_timestamp": null,
                                "updated_timestamp": null
                            }
                        ],
                        "all_fulfillment_fulfilled": [
                            {
                                "type": "PHONE_NUMBER",
                                "reason": "Secure your account with a phone number. You’ll use this to login.",
                                "reason_translated": "Secure your account with a phone number. You’ll use this to login.",
                                "user_id": 877,
                                "status": "FULFILLED",
                                "time_mandatory": null,
                                "all_status_allowed": [
                                    "FULFILLED"
                                ],
                                "id": 3573,
                                "created_timestamp": null,
                                "updated_timestamp": null
                            }
                        ]
                    }
                }
            ]
        }
    ]
}
```

The Response body below is an example. For the `user_verification_status_desired` that was used in the POST call, the system will respond with the fulfillments that are required to be completed before the user is fully verified.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/user-provisioning/chapter-3-onboarding/creating-user-onboarding.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
