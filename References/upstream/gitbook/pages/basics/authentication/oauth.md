> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/authentication/oauth.md).

# OAuth

{% hint style="danger" %}
**Important Note**\
If you, as a developer, intend to access data belonging to **other bunq users** (e.g., account information, transaction history, or initiate payments on their behalf), you must ensure that you:

* ✅ **Fully comply with** [**bunq's Terms and Conditions**](https://static.bunq.com/framer/documents/Terms-Conditions-API-EN-20200805.pdf) for API usage.
* ✅ **Obtain explicit user consent** as required.
* ⚖️ **May be subject to** [**PSD2 regulations**](https://eur-lex.europa.eu/legal-content/EN/LSU/?uri=oj:JOL_2015_337_R_0002), including registration as an AISP (Account Information Service Provider) or PISP (Payment Initiation Service Provider) with your national competent authority.

Misuse or non-compliance may lead to access being revoked or legal consequences.
{% endhint %}

## OAuth Authentication

OAuth 2.0 is an industry-standard protocol that allows third-party applications to securely access bunq user accounts without exposing credentials. This method enables seamless authorization while maintaining user control over permissions.

### **How OAuth Works**

OAuth lets your app request access to a bunq user's account. If the user grants permission, your app receives an **access token**, which functions similarly to an API key but with predefined scopes. Depending on your use case, you may need a **PSD2 permit** to access sensitive financial data or initiate payments on behalf of users.

### **Getting Started with OAuth**

To integrate OAuth authentication, follow these steps:

1. – Create an app in bunq Developer and add at least one Redirect URL.
2. **Get OAuth Credentials** – Retrieve your `client_id` and `client_secret` from the app settings in bunq Developer.
3. &#x20;– Send users to the OAuth authorization URL.
4. &#x20;– If the user grants access, they are redirected to your `redirect_uri` with an authorization code.
5. **Exchange the Code for an Access Token** – Use the token endpoint to retrieve an access token. You should safely store these access tokens in a database. You will need them to create a session on behalf of the end-user.
6. &#x20;– Authenticate API calls with the received access token, similar to a users API key.
7. **Use the Session Token to authenticate the API calls -** These are the actual calls your app makes to interact with the API.

{% hint style="info" %}
In practice you'll do steps 1 and 2 only once. Your user will do steps 3 through 5 only once. From that point on you have stored an access token for your user and whenever you want to act on behalf of the user you use that access token to get a session token and make API calls.
{% endhint %}

OAuth credentials and redirect URLs can also be managed via API endpoints for automated setup.

### **OAuth Scopes & Permissions**

By default, bunq OAuth grants access to:\
✔ Read and create **Monetary Accounts**\
✔ Read **Payments & Transactions**\
✔ Create **Payments** within a user's accounts\
✔ Create **Draft-Payments** (approval required in the bunq app)\
✔ Assign a **Monetary Account** to a **Card**\
✔ Read, create, and manage **Cards**\
✔ Read and create **Request-Inquiries**\
✔ Read **Request-Responses**

PSD2-licensed developers have scope limitations based on their regulatory role.

### **OAuth Authorization Request**

Your web or mobile app must redirect users to the following authorization URL:

```
https://oauth.bunq.com/auth
```

With the following parameters:

| Parameter       | Description                                                                         |
| --------------- | ----------------------------------------------------------------------------------- |
| `response_type` | Set to `code` for authorization code grant (required)                               |
| `client_id`     | Your OAuth Client ID from bunq Developer (required)                                 |
| `redirect_uri`  | The URL users are redirected to after authorization (must be registered) (required) |
| `state`         | Unique string for request validation (optional)                                     |

For sandbox testing, use:

```
https://oauth.sandbox.bunq.com/auth
```

#### **Example Authorization Request**

```plaintext
https://oauth.bunq.com/auth?response_type=code
&client_id=YOUR_CLIENT_ID
&redirect_uri=https://yourapp.com/callback
&state=unique_string
```

If the user grants access, they are redirected with an authorization code:

```plaintext
https://yourapp.com/callback?code=AUTHORIZATION_CODE&state=unique_string
```

### **Exchanging the Authorization Code for an Access Token**

To obtain an access token, make a `POST` request to:

```
https://api.oauth.bunq.com/v1/token
```

With the following parameters:

| Parameter       | Description                                                        |
| --------------- | ------------------------------------------------------------------ |
| `grant_type`    | Must be `authorization_code` (required)                            |
| `code`          | The authorization code received (required)                         |
| `redirect_uri`  | The same redirect URL used in the authorization request (required) |
| `client_id`     | Your OAuth Client ID (required)                                    |
| `client_secret` | Your OAuth Client Secret (required)                                |

For sandbox testing, use:

```
https://api-oauth.sandbox.bunq.com/v1/token
```

#### **Example Token Exchange Request**

```plaintext
https://api.oauth.bunq.com/v1/token?grant_type=authorization_code
&code=AUTHORIZATION_CODE
&redirect_uri=https://yourapp.com/callback
&client_id=YOUR_CLIENT_ID
&client_secret=YOUR_CLIENT_SECRET
```

#### **Successful Token Response**

```json
{
    "access_token": "ACCESS_TOKEN",
    "token_type": "bearer",
    "state": "unique_string"
}
```

Use the `access_token` for authenticated API requests.

### Store the access\_token and using it to obtain a session

The access token you obtained in the previous step is now your token to act on behalf of the user. This means that the access token you obtained has the same powers as an API key the end-user would generate for himself .

Similar to that user API key you can't use it directly. a user API key is used to create a session, that will result in a session token that you'll use for the actual API calls.\
\
In practice, once you have stored the access token a API interaction will work like this:

1. Your user interacts with your app and now your server wants to retrieve information from bunq
2. You look up the access token you have stored for that user in your database
3. You request a new session at bunq using the access token
4. You use the session token to actually retrieve the information you are after

#### Example response

When you request a session you'll see you'll receive a token and a reference to both the application as well as the end user. Also note the timeout of this session, you may want to keep the token in short-term memory for this user for subsequent calls, until it expires.

```json
{
  "Response": [
    {
      "Id": {
        "id": 26271775
      }
    },
    {
      "Token": {
        "id": 26271775,
        "created": "2025-06-25 09:03:11.377820",
        "updated": "2025-06-25 09:03:11.377820",
        "token": "0fedc50610b2dcc61997bd817c9b824263ff6fe315234e2a2f0c7e357a3f22a9"
      }
    },
    {
      "UserApiKey": {
        "id": 1964683,
        "created": "2025-06-25 09:03:00.448648",
        "updated": "2025-06-25 09:03:00.448648",
        "requested_by_user": {
          "UserPaymentServiceProvider": {
            "id": 1963873,
            "display_name": "Test PISP AISP 42CF4DAF-898A-44C7-B32C-233CD19D107F",
            "session_timeout": 324000
          }
        },
        "granted_by_user": {
          "UserPerson": {
            "id": 1864430,
            "display_name": "Jodi",
            "session_timeout": 604800
          }
        }
      }
    }
  ]
}
```

### **Making API Calls on behalf of the user**

In the previous section we have shown how you use an access token to receive a session token. This session token is the API key you'll use in requests. For example if you'd want to list the monetary accounts for a user:

```bash
curl -X GET "https://public-api.sandbox.bunq.com/v1/user/{user_apikey_id}/monetary-account-bank" \
  -H "User-Agent: text" \
  -H "X-Bunq-Client-Authentication: {session_token}" \
  -H "Content-Type: application/json"
```


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/authentication/oauth.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
