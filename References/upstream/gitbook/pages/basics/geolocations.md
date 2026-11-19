> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/geolocations.md).

# Geolocations

### Overview

The bunq API allows you to attach a geolocation to a payment using the `X-Bunq-Geolocation` request header. This metadata can then be queried later via payment-related endpoints.

### Adding Geolocation to a Payment

To include geolocation data with a payment, set the `X-Bunq-Geolocation` header when making a payment request.

#### Header format

```
X-Bunq-Geolocation: {latitude} {longitude} {altitude} {radius} {country}
```

**Example:**

```
X-Bunq-Geolocation: 52.0907 5.1214 0 50 NL
```

| Field     | Type   | Description                         |
| --------- | ------ | ----------------------------------- |
| latitude  | float  | Latitude in decimal degrees         |
| longitude | float  | Longitude in decimal degrees        |
| altitude  | float  | Altitude in meters (can be `0`)     |
| radius    | float  | Accuracy radius in meters           |
| country   | string | 2-letter ISO country code (e.g. NL) |

### Example: Creating a Payment with Geolocation

```http
POST /v1/user/{userID}/monetary-account/{monetaryAccountID}/payment

Headers:
X-Bunq-Geolocation: 52.0907 5.1214 0 50 NL


Body:
{
  "amount": {
    "currency": "EUR",
    "value": "10.00"
  },
  "counterparty_alias": {
    "type": "EMAIL",
    "value": "john@doe.com"
  },
  "description": "Lunch"
}
```

***

### Retrieving Payments with Geolocation

Geolocation is attached to:

* `/payment`
* `/draft-payment`
* `/mastercard-action`

To fetch this metadata:

```http
GET /v1/user/{userID}/monetary-account/{monetaryAccountID}/payment/{paymentID}
```

#### Response (excerpt)

[Payment](/basics/bunq-api-objects/payment.md)s that do have a location will have a geolocation property filled like so:

```json
{
  "payment": {
    "description": "Lunch",
    ...
    "geolocation": {
      "latitude": 52.3676,
      "longitude": 4.9041,
      "altitude": 0,
      "radius": 30
    }
  }
}
```

> 🧠 Only payments made with the geolocation header will include this metadata.

***

### Limitations

* There is **no API** to retrieve the **current geolocation** of a user.
* There is no geolocation API. You'll have to collect all payments and filter in your own implementation for payments and locations you're interested in
* Geolocation is only stored **at the time of certain actions** (e.g. making a payment). bunq only adds the geolocation to payments where it is available. So account for the field missing even on payments made by bunq.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/geolocations.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
