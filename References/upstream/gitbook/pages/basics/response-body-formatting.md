> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/response-body-formatting.md).

# Response body formatting

All JSON responses have one top level object. This object contains a Response field the value of which is always an array. This also applies to responses that contain only one object.

**Example** **response** **body structure:**

Copy

```
{
    "Response": [
        {
            "DataObject": {}
        }
    ]
}
```

#### Errors <a href="#errors" id="errors"></a>

* Error responses also have one top level Error object.
* The contents of the array is a JSON object with the *error\_description* and *error\_description\_translated* fields.
* The *error\_description* field contains the error explanation in the English language
* The *error\_description\_translated* field can be shown to the end users. It is automatically translated into the language specified in the `X-Bunq-Language` header. The default language is en\_US.
* If you are using one of the bunq SDKs, error responses will be always raised in form of an exception.

**Example response body:**

Copy

```
{
    "Error": [
        {
            "error_description": "Error description",
            "error_description_translated": "User facing error description"
        }
    ]
}
```

#### Object Type Indications <a href="#object-type-indications" id="object-type-indications"></a>

If the API returns different types of objects for the same field, they are nested in a group JSON object that, in its turn, contains a separate field for each of the objects. If you use one of the bunq SDKs, a BunqResponse object will be returned as the top level object.

**Example.** The *content* field can contain multiple types of objects such as ChatMessageContentText in this case. Be sure to follow this convention or use one of the bunq SDKs instead.

Copy

```
{
    "Response": [
        {
            "ChatMessage": {
                "id": 5,
                "content": {
                    "ChatMessageContentText": {
                        "text": "Hi! This is an automated security message. We saw you just logged in on an My Device Description. If you believe someone else logged in with your account, please get in touch with Support."
                    }
                }
            }
        }
    ]
}
```

#### &#x20;<a href="#time-formats" id="time-formats"></a>


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/response-body-formatting.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
