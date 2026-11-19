> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/authentication/oauth/python-code-example-psd2-oauth-integration.md).

# Python Code Example PSD2 - OAuth integration

{% embed url="<https://github.com/two-trick-pony-NL/PSD2-Implementation-for-bunq-API>" %}

In the linked repository you'll find a example integration that has all the moving parts of setting up a bunq server and the oauth flow.

## Setting up the example

In order to use the code example we expect you have a python environment set up. Simply running `pip install -r requirements.txt` will take care of setting up dependencies.

If you are a PSD2 user you'll want to create a `UserPaymentServiceProvider` user. These are specific users that have no banking features attached to their bunq account. If that's the case you'll want to run the `create_psd2_user.sh` script. That will register a sandbox PSD2 user for you.

If you're just a bunq business user you can just paste your  in the `main.py` file.

From there you can run `uvicorn main:app --reload` this will kick off a uvicorn server, serving a FastAPI app on port 8000 to start the server

## Initializing your installation

We prepared a endpoint that you'll have to run 1x it will set up the . It will also register your client and register a .

You can do so by hitting the localhost:8000/setup\_one\_time it will take a minute.

Finally that script will create a .env file that can be used going forward.

This is a great step to remove your API key from the `main.py` file. From now on it will be read from the `.env` file.

## Using Oauth

You can now go to your localhost:8000/auth endpoint which will trigger a oauth request. If you have the  on a physical device you'll be able to scan the QR code that is generated and complete the oauth flow.

What happens in the background is:

1. The app created a oauth client in the set up. This allows us to now generate a oauth session. It is a screen with a QR code that the end-user scans with their bunq app
2. In the app the bunq user can select which monetary accounts they grant access to.
3. When the user completes the steps they are redirected to our app. With a authorization code from bunq. This code is immediately used by the app to request an access token. The app stores that access token in a database and associates it to a user. We did not build a pretty page but if the oauth flow was successful you'll see a json response with:

   ```
   {"message":"OAuth success","new_user_id":1}
   ```

   This means that we stored a user in our local database with id 1 that has a bunq oauth access token associated to it.
4. So now we can retrieve data on that user. One way to do that is to visit the /docs endpoint. FastApi offers a interactive API documentation. You can also simply visit the localhost:8000/user/1 url. If you request data on behalf of a user then this happens:\
   1\. We look up the bunq access token for that user 1 in our database\
   2\. We request a session token with the access token\
   3\. We make the API call we want with that session token\
   4\. Return the results to the end-user

For instance: if you go to the user/2/accounts endpoint you'll get a summary of the [Monetary Account](/monetary-account.md)for that user:

```json
{
  "Response": [
    {
      "MonetaryAccountBank": {
        "id": 2083712,
        "alias": [
          {"type": "IBAN", "value": "NL65BUNQ2090411945", "name": "Jodi Walker"}
        ],
        "balance": {"currency": "EUR", "value": "4118.00"},
        "currency": "EUR",
        "display_name": "J. Walker",
        "status": "ACTIVE",
        "user_id": 1864430
      }
    },
    "// ... additional accounts"
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
GET https://doc.bunq.com/basics/authentication/oauth/python-code-example-psd2-oauth-integration.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
