> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/psd2/payment-initiation-service-provider-pisp.md).

# Payment Initiation Service Provider (PISP)

{% hint style="success" %}
Heya! Before checking this page, make sure that you [registered yourself as a TPP](/psd2/are-you-a-third-party-provider-tpp-start-here/register-as-a-tpp.md) in our API first.
{% endhint %}

As a PISP, you are allowed to authenticate in a user’s account with the following permissions:

1. read account information:
   * legal name;
   * IBAN;
2. initiate draft payments and read their statuses;
3. confirm that the account balance is sufficient for covering the payment.

The bunq API provides endpoints for different scenarios of the implementation of the payment initiation functionality. In particular, as a PISP user, you can build applications that initiate and authorize one-off or multiple incoming payments. Depending on the use case you are intending to deploy, you might need to initiate the OAuth authorization either before or after the payment initiation.

### Authorization of multiple (scheduled) payments <a href="#authorization-of-multiple-scheduled-payments" id="authorization-of-multiple-scheduled-payments"></a>

It is possible to initiate payments from a bunq user's account having previously established an OAuth connection between your application and the bunq user's account. The bunq user will receive push notifications for each initiated payment.

Once a bunq user has [confirmed they want to make payments via your application](https://beta.doc.bunq.com/psd2/connect-as-a-psd2-service-provider#register-your-application), you can initiate the payment confirmation flow.

1. Create a draft payment via `POST /user/{userID}/monetary-account/{monetary-accountID}/draft-payment`

   passing the following parameters:

   1. `monetary-accountId and userId` (`userApiKey`'s `id`; see [OAuth](/oauth.md) for more information) in the endpoint URL;
   2. the customer’s email address, phone number, or IBAN in the `counterparty_alias` field of the request body.
2. If the user confirms their intent to make the payment, bunq carries out the transaction.
3. Check the status of the payment via `GET /user/{userID}/monetary-account/{monetary-accountID}/draft-payment`

   using the draft payment `id` parameter returned in the previous step.

### Single payment authorization <a href="#single-payment-authorization" id="single-payment-authorization"></a>

It is possible to initiate payments having only the IBAN of the payer using `POST /user/{userID}/payment-service-provider-issuer-transaction`. In this case, the bunq user will accept the payment along with the authorization request. No additional push notifications are sent to the user.

1. Collect the bunq user's IBAN (and name) in the UI of your application.
2. Create a draft payment via `POST /user/{userID}/payment-service-provider-issuer-transaction`. More details here: [Payment Service Provider Issuer Transaction](/payment-service-provider/payment-service-provider-issuer-transaction.md)
3. Initiate an [authorization request](/basics/authentication/oauth.md). Upon the QR-code scan, the bunq user will see and be able to either accept or reject the payment authorization request.
4. Check the status of the payment.

### Get the end user information

You can get the user information by sending a calling the following endpoint with the `user_id`

{% hint style="success" %}
If you have an open session on behalf of the user, just call `GET /v1/user` (with no `user_id`) to retrieve their info.
{% endhint %}

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/user/{itemId}" method="get" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}

### Confirm user account funds

You can check the availability of funds via `POST /user/{userID}/confirmation-of-funds` passing the following information:

* your `user_id`;
* the amount of money needed for the payment;
* the name of the bunq user and the IBAN of the account (email address or phone number pointing at the user are also possible).

Here the full specs of this endpoint:

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
GET https://doc.bunq.com/psd2/payment-initiation-service-provider-pisp.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
