> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/your-first-payment/creating-the-api-context/start-a-session.md).

# Start a Session

Sessions provide **temporary authentication**, meaning that even if a session token is exposed, it will automatically expire after a set period. This balances security with usability—developers don’t need to constantly re-authenticate, but access remains limited to prevent long-term misuse. The session timeout can be adjusted in the bunq app, giving users control over their security settings. This session-based approach is common in **high-security environments**, ensuring that access is time-limited and reducing persistent threats.

Once you have a session we'll return you the user object. So you have all details of your user.

The response of the session API call is a object with a **session token**, this is the token we'll use in subsequent requests to authenticate requests. There is also a **userid** in this response. Which we will use in the next calls.

```json

{
    "Response": [
        {
            "Id": {
                "id": 25536694
            }
        },
        {
            "Token": {
                "id": 25536694,
                "created": "2025-03-05 16:12:11.918100",
                "updated": "2025-03-05 16:12:11.918100",
                "token": "ce717e3001d979ff5e22bac13508b46e7ad740971d1d75c5371614e546ca8b83"
            }
        },
        {
            "UserPerson": { "id": 1822179,
                            "rest of the user object":...  }
        }
    ]
}

```

{% hint style="info" %}
**If your session expires you simply call the /session-server endpoint again. This gives you a new session token to use**
{% endhint %}

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/session-server" method="post" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}

### What's next:

You'll see that with the session we obtained the details of your user. If you look closely you can see that the [User](/basics/bunq-api-objects/user.md) object is also returned with this call. If you're still using Postman it's a good idea to already note the user ID as that is used in many of the subsequent API calls.

Up next we'll set up this user object so that you can use it in your sandbox.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/your-first-payment/creating-the-api-context/start-a-session.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
