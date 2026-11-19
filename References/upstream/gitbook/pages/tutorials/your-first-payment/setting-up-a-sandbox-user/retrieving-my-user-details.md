> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/your-first-payment/setting-up-a-sandbox-user/retrieving-my-user-details.md).

# Retrieving my user details

In the previous chapter you already requested a session and as a response received the user object. If you saved that in your app you already have a reference to who your user is. The most important item to keep track of is the userid. As that's what we'll need in the next few steps.

#### What we have done so far

* We have created a sandbox user, and generated an API key
* We have created a installation and registered a device
* We generated a session and now know the user ID and Session token

In the next chapter we'll use these to make our API calls

## Who is my user, and what is his current balance?

To retrieve our user we simply can do a API call to the user endpoint and this will return us our current user. We already had this information from the previous step. The important thing to save here is the user ID. We'll need to pass it as a url parameter in the next calls.

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/master/swagger.json>" path="/user" method="get" %}
<https://raw.githubusercontent.com/bunq/doc/master/swagger.json>
{% endopenapi %}

## So, what is the balance of our user?

We'll we need just one more step that is to call the monetary-account-bank endpoint. This endpoint lists all monetary accounts we know for this user. The response contains a list of monetary accounts.

Take note of the monetary account ID, most of the API calls reference both the user ID as well as the ID of the thing you are performing your actions on. To answer the question: what is the balance of our user. You can see that the newly created user comes with 1 monetary account, with a balance of €0.00. Let's add some money to the account!

```json
"Response": [
        {
            "MonetaryAccountBank": {
                "id": 2026814,
                "created": "2025-03-05 16:12:01.255073",
                "updated": "2025-03-05 16:12:01.255073",
                ... more key value pairs ... 
                }
                "balance": {
                        "currency": "EUR",
                        "value": "0.00"
                    },

        }
    ]
```

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/master/swagger.json>" path="/user/{userID}/monetary-account-bank" method="get" %}
<https://raw.githubusercontent.com/bunq/doc/master/swagger.json>
{% endopenapi %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/your-first-payment/setting-up-a-sandbox-user/retrieving-my-user-details.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
