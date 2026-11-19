> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/your-first-payment/setting-up-a-sandbox-user/getting-sandbox-money-on-the-user-account.md).

# Getting sandbox money on the user account

The easiest way to become a millionaire is in our sandbox. This is because we have 1 user in our sandbox called Sugar Daddy. This user will approve all requests for money up to €500 at a time.

## Call to SugarDaddy

As you can see in the response we'll need to pass in our user ID as well as monetary account ID. counterparty Alias is the alias (phone number, email address or IBAN) of the person you want money from. The amount and currency are €100.

{% hint style="info" %}
Sugardaddy hands out free money, it's not unlimited. Sugardaddy will only accept requests up to €500,- Any request above that amount will be rejected.
{% endhint %}

#### Example request body

```json
{
    "amount_inquired": {
        "value": "100",
    "currency": "EUR"
  },
    "counterparty_alias": {
      "type": "EMAIL",
      "value": "sugardaddy@bunq.com",
      "name": "Sugar Daddy"
  },
  "description": "You'\''re the best!",
  "allow_bunqme": false
}'
```

#### Example curl call to sugardaddy

```
curl --location 'https://public-api.sandbox.bunq.com/v1/user/1822179/monetary-account/2026814/request-inquiry' \
--header 'Content-Type: application/json' \
--header 'Cache-Control: no-cache' \
--header 'User-Agent: postman' \
--header 'X-Bunq-Language: en_US' \
--header 'X-Bunq-Region: nl_NL' \
--header 'X-Bunq-Client-Request-Id: c27ctel8WBQrleTTk4I8' \
--header 'X-Bunq-Geolocation: 0 0 0 0 000' \
--header 'X-Bunq-Client-Authentication: ce717b3001d979ff5e22bac13508b46e7ad740971d1d75c5371614e546ca8b83' \
--header 'X-Bunq-Client-Signature: IQmnUmd/DO8ELKBGKSuSdszxQmvBNA1s7ONHdmYU9glRs1kpaDnVmPyQgFL+mDffbdm5G4KsoI4Wvt07Cw1upYN8aPb0MEzpKL54F/1f2AZxWxUTGT+uBvdyCZuT609NJc279casOL1zm0XNo2i2Q8NiFKl0Y4eCmEOyErvxjAWuLObOW7VzXcWFN1LqXLC12sDGKTagbXtRrSS/mL5fsKYCxWQrb9mBsAWzmFWC0mGORrzrpUG24r+1qX/sRsH6wMKf5t8nUIsBeGtT0c724wM9M/Silp0OoZQ0w37nuiKGxPq+Awxx4//o2b09wIKyZUBEeFa1BQnrLdAIKvABLA==' \
--data-raw '{
	"amount_inquired": {
    "value": "100",
    "currency": "EUR"
  },
  "counterparty_alias": {
      "type": "EMAIL",
      "value": "sugardaddy@bunq.com",
      "name": "Sugar Daddy"
  },
  "description": "You'\''re the best!",
  "allow_bunqme": false
}'
```

#### Example response body

Sugardaddy just returns a response with a request ID. But since we don't see an error we know that Sugardaddy received the request

```json
{
    "Response": [
        {
            "Id": {
                "id": 1475092
            }
        }
    ]
}
```

#### Verification

If we want to double check that Sugar Daddy indeed paid us we'll have to double check our Monetary account again. Instead of listing all monetary accounts we can now also do a smaller API call to just get details for the monetary account in our request. Which should have our updated balance in the response

#### request

```http
curl --location 'https://public-api.sandbox.bunq.com/v1/user/1822179/monetary-account/2026814' 
\
--header 'Content-Type: application/json' \
--header 'Cache-Control: no-cache' \
--header 'User-Agent: postman' \
--header 'X-Bunq-Language: en_US' \
--header 'X-Bunq-Region: nl_NL' \
--header 'X-Bunq-Client-Request-Id: c27ctel8WBQrleTTk4I8' \
--header 'X-Bunq-Geolocation: 0 0 0 0 000' \
--header 'X-Bunq-Client-Authentication: ce718b3001d979ff5e22bac13508b46e7ad740971d1d75c5371614e546ca8b83' \
--header 'X-Bunq-Client-Signature: IQmnUmd/DO8EEKBGKSuSdszxQmvBNA1s7ONHdmYU9glRs1kpaDnVmPyQgFL+mDffbdm5G4KsoI4Wvt07Cw1upYN8aPb0MEzpKL54F/1f2AZxWxUTGT+uBvdyCZuT609NJc279casOL1zm0XNo2i2Q8NiFKl0Y4eCmEOyErvxjAWuLObOW7VzXcWFN1LqXLC12sDGKTagbXtRrSS/mL5fsKYCxWQrb9mBsAWzmFWC0mGORrzrpUG24r+1qX/sRsH6wMKf5t8nUIsBeGtT0c724wM9M/Silp0OoZQ0w37nuiKGxPq+Awxx4//o2b09wIKyZUBEeFa1BQnrLdAIKvABLA==' \
--data ''
```

#### Response

```
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
                        "value": "100.00"
                    },

        }
    ]
```

## Requesting money from other users

If you want to request money from other users then this is how you do it: Just be aware, sugardaddy is the only one who automatically transfers money to you.

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/master/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/request-inquiry" method="get" %}
<https://raw.githubusercontent.com/bunq/doc/master/swagger.json>
{% endopenapi %}

## Response

```json
{
    "Response": [
        {
            "Id": {
                "id": 1475092
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
GET https://doc.bunq.com/tutorials/your-first-payment/setting-up-a-sandbox-user/getting-sandbox-money-on-the-user-account.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
