> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/psd2/card-based-payment-instrument-issuer-cbpii.md).

# Card-Based Payment Instrument Issuer (CBPII)

{% hint style="success" %}
Heya! Before checking this page, make sure that you [registered yourself as a TPP](/psd2/are-you-a-third-party-provider-tpp-start-here/register-as-a-tpp.md) in our API first.
{% endhint %}

As a CBPII, you are allowed to authenticate in a user’s account to validate the availability of funds for the payment in question.

1. Collect an alias for the bunq user's account (their name and IBAN, email address, or phone number).
2. Check the availability of funds via `POST /user/{userID}/confirmation-of-funds` passing the following information:
   * your `userId`;
   * the amount of money needed for the payment;
   * the name of the bunq user and the IBAN of the account (email address or phone number pointing at the user are also possible).

Here is the full specs of the endpoint:

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/user/{userID}/confirmation-of-funds" method="post" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/psd2/card-based-payment-instrument-issuer-cbpii.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
