> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/signing.md).

# Signing

{% hint style="info" %}

## TL:DR On signing requests

#### Why we need signing

For some API calls we want to make sure the content tampered with. For instance making a payment, you would not want anyone to be able to change the amount or receiving party. Adding a signature allows bunq to detect whether the request body has been tampered with.

#### When do you need signing

Any request that creates or accepts a payment. If you forget to sign it we'll tell you with [error](/basics/errors.md) 466

#### What is a signature?

A signature is nothing more than a extra header: *X-Bunq-Client-Signature* that you add to your API call. You'll need to write some code in your application that takes in the request body and your private key (some examples are mentioned below)
{% endhint %}

**When Do You Need to Sign Requests?**

Most API calls don’t need signing, but **any request that creates or accepts a payment does**. If you forget to sign it, you’ll get a `466` error—so keep an eye out for that!

**How It Works**

* **You sign the request body** (not the whole request).
* **We verify the signature** on our end.
* **We sign our response**, so you can verify it too.

**What You Need**

* A **private key** (which you generate when installing your API connection).
* The **public key we send you**, which you’ll use to verify our responses.

## Example Curl request

This is a payment to Sugardaddy for €0,10. As you can see in the header we added the ***X-Bunq-Client-Signature*** header. This is just a Base64 encoded representation of the request body.

```
curl --location 'https://public-api.sandbox.bunq.com/v1/user/1800297/monetary-account/1989601/payment' \
--header [other headers]' \
--header 'X-Bunq-Client-Signature: eMymd9ynLx+j5tpcoPMlaJ7vEyxIZAXWInXIRxIOyP24KF7lpvNIwElB/wiQqVXr99pua4+onqvJUNiuceInAtohJnSGDEd58GjeBthz2OHTG5I0GZyJ9S8XAuBJYbqPgFaIk2m0VelPmjAHbiA3WSH0ASMDvcht/p4n60Y1GMVESXFovU2jUWX2X2k5QhowitIBJnsf4fkvYknbispFvUTn4ESU8QQVBgwR9QJ8DpxObGYbsTKQCyTzXoKNLM1mkw3pMwHn1EZ+AmOTx5iR/xXZLvvXWDmj9rEZWms7G1+drmhkK5aV8PuvR6s11mS6laRxyS1eoCaOcqeOZs1EcQ==' \
--data-raw '{
    "amount": {
        "value": "0.10",
        "currency": "EUR"
    },
    "counterparty_alias": {
        "type": "EMAIL",
        "value": "sugardaddy@bunq.com",
        "name": "Sugar Daddy"
    },
    "description": "My payment description :)"
}'
```

***

### Request signing example

Consider the following request, a `POST` to `/v1/user/126/monetary-account/222/payment` (the JSON is formatted with newlines and indentations to make it more readable - be careful to account for that when creating your signature):

| Header                        | Value                                                            |
| ----------------------------- | ---------------------------------------------------------------- |
| Cache-Control:                | no-cache                                                         |
| User-Agent:                   | bunq-TestServer/1.00 sandbox/0.17b3                              |
| X-Bunq-Client-Authentication: | f15f1bbe1feba25efb00802fa127042b54101c8ec0a524c36464f5bb143d3b8b |

```
{
    "amount": {
        "value": "12.50",
        "currency": "EUR"
    },
    "counterparty_alias": {
        "type": "EMAIL",
        "value": "bravo@bunq.com"
    },
    "description": "Payment for drinks."
}
```

Let's sign that request. First create a variable `$dataToSign` containing the body of the request:

```
{
    "amount": {
        "value": "12.50",
        "currency": "EUR"
    },
    "counterparty_alias": {
        "type": "EMAIL",
        "value": "bravo@bunq.com"
    },
    "description": "Payment for drinks."
}
```

Next, create the signature of `$dataToSign` using the SHA256 algorithm and the private key `$privateKey` of the Installation's key pair. In PHP, use the following to create a signature. The signature will be passed by reference into `$signature`.

`openssl_sign($dataToSign, $signature, $privateKey, OPENSSL_ALGO_SHA256);`

Encode the resulting `$signature` using base64, and add the resulting value to the request under the `X-Bunq-Client-Signature` header. You have just signed your request, and can send it!

## Troubleshooting

{% hint style="success" %}
If you struggle with signing you might want to try our [SDK's](broken://pages/ZOBhBQTwIMvx9EpWwDg6). They handle signing for you
{% endhint %}

If you are getting error 466 for invalid signatures then it's best to test these things:

Check list:

* [ ] Do you have a key pair generated?
* [ ] Are you using the correct encryption algorithms (Also check the padding algorithm)
* [ ] Sign ***only*** the request body (no headers, no URLs)
* [ ] Are you encoding your signature in base64 before sending
* [ ] There are no redundant characters (extra spaces, trailing line breaks, etc.) in the data to sign (Some programming languages or libraries might change the formatting to make it better human readable. This may cause the body to change and thus no longer match the signature)
* [ ] Make sure the body is appended to the data to sign exactly as you're adding it to the request.
* [ ] You have added the full body to the data to sign.
* [ ] You use the data to sign to create a SHA256 hash signature.
* [ ] You have base64 encoded the SHA256 hash signature before adding it to the request under `X-Bunq-Client-Signature`.

If you run into issues, double-check these points—or just use our SDKs, which handle all of this for you.

## Standards and formats

To ensure secure and valid request and response signatures, you should use the following standards: First, apply SHA256 as the cryptographic hash function to hash the data (either the request body or response body). For the signing process, use the private key with PKCS #1 v1.5 padding for RSA encryption to generate the signature. Once the signature is created, it must be base64-encoded to ensure proper transmission in HTTP headers. This ensures that the integrity and authenticity of the data are preserved, and the signature can be verified by the recipient using the corresponding public key.

## Response Signatures

In some cases you might also want to validate whether responses are actually sent by bunq. Here you can do the same thing. If you stored the public key of the bunq server (you received this during [installation](/tutorials/your-first-payment/creating-the-api-context.md)) you can verify the response sent by bunq and validate that the response body matches the signature.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/signing.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
