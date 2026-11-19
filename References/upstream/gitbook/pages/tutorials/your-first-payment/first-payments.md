> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/your-first-payment/first-payments.md).

# First Payments

In the previous chapter you already made a request to Sugar Daddy to get money on your sandbox account and you made API calls to retrieve the balance on your accounts. If you have that implemented in your application you're already well on your way to manipulate the majority of objects in the bunq API. We highly recommend you take a look at [API Reference](/api-reference/hidden-references.md) to see all the endpoints we offer.

But before we let you go we have to get to the good stuff: making a payment. The reason we make it a separate topic is that we got quite some feedback that people get stuck on something called 'signing'.

### What is signing and why does it matter

In short: if you use our API to make a payment you don't want a man-in-the-middle to be able to meddle with your request. If you made a payment for let's say €10, then you don't want anyone to hijack that request and make the payment €12. Signing prevents that from happening as we create a signature that allows the bunq backend to validate that the content of the request has not been tampered with. You can read much more about signing here [Signing](/basics/signing.md). In this tutorial we'll just show you how.

## Making a Payment

The API call for making a payment is nothing special (except for the signing) so you can just make a call using the method described below.

Some points of attention:

* The counterparty is a pointer towards a user [bunq API Objects](/basics/bunq-api-objects.md)
* You can construct your own using json

<pre class="language-json"><code class="lang-json">      {
            "amount": {
                "value": 10,
                "currency": "EUR"
            },
            "counterparty_alias": {
                "type": "EMAIL",
                "value": "sugardaddy@bunq.com",
                "name": "Sugar Daddy"
            },
            "description": "here is your money back"
    }
<strong>    
</strong></code></pre>

## Signing

Now one of the things we need to do before we can actually make the API call is to generate a signature and add it to our \`'X-Bunq-Client-Signature' in the header of the API call.

The specifics on how to do that are in [Signing](/basics/signing.md) on that page you'll also find some coding examples. For instance in python [Full signing.py](/basics/signing/python-code-example/full-signing.py.md)

From there it's nothing different than a normal API call and you just post to the endpoint and will receive a ID of the generated payment.

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/user/{userID}/monetary-account/{monetary-accountID}/payment" method="post" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/your-first-payment/first-payments.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
