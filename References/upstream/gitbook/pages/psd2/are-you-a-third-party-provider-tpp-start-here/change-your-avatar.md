> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/psd2/are-you-a-third-party-provider-tpp-start-here/change-your-avatar.md).

# Change your avatar

### How to change your avatar

#### 1. POST attachment-public

Start by creating an attachment that will be used for the avatar.

**Header**

Make sure you set the `Content-Type` header to match the MIME type of the image. It is also required you pass a description of the image via the `X-Bunq-Attachment-Description` header.

**Body**

The payload of this request is the binary representation of the image file. Do not use any JSON formatting.

**Response**

Save the `uuid` of the posted attachment. You'll need it to create the avatar in the next step.

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/attachment-public" method="post" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}

#### 2. POST avatar

Make an avatar using the public attachment you've just created.

**Body**

The payload of this request is the `uuid` of the attachment public.

**Response**

In response, you’ll receive the UUID of the avatar created using the attachment. Save this UUID. You’ll use it as the avatar for the cash register you're about to create.

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/avatar" method="post" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/psd2/are-you-a-third-party-provider-tpp-start-here/change-your-avatar.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
