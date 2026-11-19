> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/note-text-and-attachment/bunqme-fundraiser-result.md).

# bunqme fundraiser result

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-fundraiser-result/{itemId}" method="get" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-fundraiser-result/{bunqme-fundraiser-resultID}/note-attachment" method="post" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-fundraiser-result/{bunqme-fundraiser-resultID}/note-attachment" method="get" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-fundraiser-result/{bunqme-fundraiser-resultID}/note-attachment/{itemId}" method="put" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-fundraiser-result/{bunqme-fundraiser-resultID}/note-attachment/{itemId}" method="delete" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-fundraiser-result/{bunqme-fundraiser-resultID}/note-attachment/{itemId}" method="get" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-fundraiser-result/{bunqme-fundraiser-resultID}/note-text" method="post" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-fundraiser-result/{bunqme-fundraiser-resultID}/note-text" method="get" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-fundraiser-result/{bunqme-fundraiser-resultID}/note-text/{itemId}" method="put" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-fundraiser-result/{bunqme-fundraiser-resultID}/note-text/{itemId}" method="delete" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}

{% openapi src="<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>" path="/user/{userID}/monetary-account/{monetary-accountID}/bunqme-fundraiser-result/{bunqme-fundraiser-resultID}/note-text/{itemId}" method="get" %}
<https://raw.githubusercontent.com/bunq/doc/refs/heads/develop/swagger.json>
{% endopenapi %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/note-text-and-attachment/bunqme-fundraiser-result.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
