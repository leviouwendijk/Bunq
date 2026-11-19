> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/headers.md).

# Headers

#### Mandatory request headers

**Content-Type (for JSON requests)**

For all API calls that include a request body, set:

Content-Type: application/json

**Cache-Control**

Example:

`Cache-Control: no-cache`

The standard HTTP Cache-Control header is required for all requests.

**User-Agent**

Example:

`User-Agent: bunq-TestServer/1.00 sandbox/0.17b3`

The User-Agent header field must contain information about the user agent originating the request. There are no restrictions on the value of this header.

**X-Bunq-Client-Signature**

Signatures are only required for requests that create Payments or start a new session. For these calls, sign the request body as described in Signing.

Example:

X-Bunq-Client-Signature: XLOwEdyjF1d+tT2w7a7Epv4Yj7w74KncvVfq9mDJVvFRlsUaMLR2q4ISgT+5mkwQsSygRRbooxBqydw7IkqpuJay9g8eOngsFyIxSgf2vXGAQatLm47tLoUFGSQsRiYoKiTKkgBwA+/3dIpbDWd+Z7LEYVbHaHRKkEY9TJ22PpDlVgLLVaf2KGRiZ+9/+0OUsiiF1Fkd9aukv0iWT6N2n1P0qxpjW0aw8mC1nBSJuuk5yKtDCyQpqNyDQSOpQ8V56LNWM4Px5l6SQMzT8r6zk5DvrMAB9DlcRdUDcp/U9cg9kACXIgfquef3s7R8uyOWfKLSNBQpdVIpzljwNKI1Q

**X-Bunq-Client-Authentication**

`X-Bunq-Client-Authentication: 622749ac8b00c81719ad0c7d822d3552e8ff153e3447eabed1a6713993749440`

The authentication *Token* is used to identify the sender of the API call. It is required for all API calls except `POST /v1/installation`.

* Pass the **installation Token** you get in the response to the `POST /installation` call in the `/device-server` and `/session-server` calls.
* Pass the **session Token** you get in the response to the `POST /session-server` call in all the other calls.

**Optional request headers**

**X-Bunq-Language**

`X-Bunq-Language: en_US`

`en_US` is the default language setting for responses and error descriptions.

The X-Bunq-Language header must carry the preferred language indicator. The value of this header must follow this format: *an ISO 639-1 language code* plus *a ISO 3166-1 alpha-2 country code* separated by an underscore.

We currently only support *en\_US* and *nl\_NL*. Any other language will default to *en\_US*.

**X-Bunq-Region**

`X-Bunq-Region: en_US`

`en_US` is the default region for localization formatting.

The X-Bunq-Region header must contain the region (country) of the client device. The value of this header must follow this format: *an ISO 639-1 language code* plus *a ISO 3166-1 alpha-2 country code* separ

**X-Bunq-Client-Request-Id**

`X-Bunq-Client-Request-Id: a4f0de`

An optional identifier, echoed back in the \`X-Bunq-Client-Reqthat you can use to match a response to its request.

\*\*This header is not an idempotency or replay-protection mechot reject or deduplicate a repeated value — sending the samerequest twice with the same ID will carry it out twice (e.g. two payments). To prevent a request from being carried out more than once, use \[X-Bunq-Client-Idempotency-Key]\(#x-bunq-client-idempotency-ke

There are no restrictions on the format — a UUID is recommend

**X-Bunq-Client-Idempotency-Key**

\`X-Bunq-Client-Idempotency-Key: 3fa85f64-5717-4562-b3fc-2c963

Optional header for public and partner API calls that create PUT`). It has no effect on` GET`or`DELETE\` requests, and isnot used by the bunq apps.

Use it to guarantee a request is carried out only once, even if it's sent more than once:

* The first request with a given key is processed normally.
* Sending the same key again returns `409 Conflict`: The X-Bunq-Client-Idempotency-Key header value was already used. Use a unique value for each request. No second action (e.g. payment) is performed, and no money is
* If the request fails with a `4xx` (e.g. insufficient balance, validation error), the key is released — fix the issue and retry with the same key.
* If the request fails with a `5xx`, the key stays reserved, ther the action was carried out. Check whether the originalaction went through before retrying with a new key.

The key is scoped to the DeviceServer (API key installation) that sends it — different integrations can reuse the same value without conflict. A key is remembered for **24 hours**.

There are no restrictions on the format — a UUID is recommends header for any `POST`/`PUT` call where a duplicate wouldhave a real effect, especially payments — including protecting against a delegate (bookkeeper, employee) accidentally or deliberately resending an already-approved payment.

**X-Bunq-Geolocation**

`X-Bunq-Geolocation: 4.89 53.2 12 100 NL`

`X-Bunq-Geolocation: 0 0 0 0 000` \_(if no geolocation is avai

This header has to specify the geolocation of the device. Thelongitude latitude altitude radius country\_. The country isexpected to take the form of an *ISO 3166-1 alpha-2 country code*.

This header makes it possible for bunq to map the geolocation with the payment.

**Attachment headers**

**Content-Type**

`Content-Type: image/jpeg`

Use this header when uploading an attachment to pass its MIME type. We support the following content types:

* *image/png;*
* *image/jpeg;*
* *image/gif.*

**X-Bunq-Attachment-Description**

Use this header to provide a description of an attachment.

#### Response Headers

**All Responses**

**X-Bunq-Client-Request-Id**\
`X-Bunq-Client-Request-Id: a4f0de`\
The header contains the same `id` that was provided in the `X-Bunq-Client-Request-Id` header of the request. It is included in the response (and request) signature so it can be used to ensure this is the re **X-Bunq-Client-Response-Id** `X-Bunq-Client-Response-Id: 76cc7772-4b23-420a-9586-8721dcdde The header carries a unique` id\` of the response formatted asto add extra protection against replay attacks. **X-Bunq-Server-Signature** X-Bunq-Server-Signature: XBBwfDaOZJapvcBpAIBT1UOmczKqJXLSpX9ZWHsqXwrf1p+H+eON+TktYksAbmkSkI4gQghw1AUQSJh5i2c4+CTuKdZ4YuFT0suYG4sltiKnmtwODOFtu1IBGuE5XcfGEDDSFC+zqxypMi9gmTqjl1KI3WP2gnySRD6PBJCXfDxJnXwjRkk4kpG8Ng9nyxJiFG9vcHNrtRBj9ZXNdUEudW3rBefycL1DlpJZw6yRLoDltxeBo7MjgROBpIeElh5qAz9vxUFLqIQC7EDONBGbSBjaXS0wWrq9s2MGuOi9kJxL2LQm/Olj2g==

The header contains the signature of the bunq server for this response. See the signing page for details on how to verify this signature.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/headers.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
