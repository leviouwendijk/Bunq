> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/errors.md).

# Errors

We use the HTTP response codes to indicate the success or failure of an API request:

* codes in the 2xx range indicate success;
* codes in the 4xx range indicate an error having to do with the provided information (e.g. a required parameter was missing, insufficient funds, etc.);
* codes in the 5xx range indicate an error having to do with the bunq servers. If you get such an error, please report it to us via chat.

## Response Codes

| Code | Error                      | Description                                                       |
| ---- | -------------------------- | ----------------------------------------------------------------- |
| 200  | OK                         | Successful HTTP request                                           |
| 399  | NOT MODIFIED               | Same as 304. It implies you have a local cached copy of the data. |
| 400  | BAD REQUEST                | A parameter is missing or invalid.                                |
| 401  | UNAUTHORISED               | A token or signature provided is not valid.                       |
| 403  | FORBIDDEN                  | You're not allowed to make this call.                             |
| 404  | NOT FOUND                  | The object you're looking for cannot be found.                    |
| 405  | METHOD NOT ALLOWED         | The method you are using is not allowed for this endpoint.        |
| 429  | RATE LIMIT                 | Too many API calls have been made in a too short period of time.  |
| 466  | REQUEST SIGNATURE REQUIRED | Request signature is required for this operation.                 |
| 490  | USER ERROR                 | A parameter is missing or invalid.                                |
| 491  | MAINTENANCE ERROR          | bunq is in maintenance mode.                                      |
| 500  | INTERNAL SERVER ERROR      | Something went wrong on our end.                                  |

{% hint style="info" %}
All 4xx errors include a JSON body explaining what went wrong.
{% endhint %}

## Rate Limits

If you are receiving the 429 error, please make sure you are sending requests at rates that are below our rate limits.

Here are our **rate limits per IP address per endpoint:**

* **GET requests:** 3 requests within any 3 consecutive seconds
* **POST requests:** 5 requests within any 3 consecutive seconds
* **PUT requests:** 2 requests within any 3 consecutive seconds
* **Callbacks:** 2 callback URLs per notification category


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/errors.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
