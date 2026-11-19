> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/note-text-and-attachment.md).

# Note Text & Attachment

#### File Attachments

File attachments in the bunq app allow users to attach images or documents to payments, making it easy to reference receipts, invoices, or other relevant files later. Each attachment must have a specific file type, such as JPEG, PNG, or PDF. The file is first uploaded to a monetary account, where bunq stores it securely and returns a unique attachment ID. Once uploaded, the attachment can be linked to a specific payment as a **note-attachment**, optionally including a description to provide context. This ensures that all files are properly associated with their payments and easily retrievable.

#### Text Notes

In addition to file attachments, users can add plain text notes to payments as **note-text**. Text notes do not require file uploads and are useful for adding comments, explanations, or any textual reference that supplements a payment. You can add and retrieve text notes [direct through the API](/note-text-and-attachment/payment.md) By combining file attachments and text notes, users can maintain a fully annotated and organized payment history.

#### Getting started with files

This makes it easy to reference receipts, invoices, or any relevant information later. Each attachment must have a specific file type, such as JPEG, PNG, or PDF, and the file is first uploaded to a [monetary account](/api-reference/attachment.md) before it can be linked to any payment.

The process involves multiple steps:

1. **Create the attachment:** Users must first [upload the file to the monetary account](/api-reference/attachment.md). This step requires providing the file itself along with a brief description. bunq stores the attachment securely and returns a **unique attachment ID**, which will be used in the next step.
2. **Link the attachment to a payment:** Once the attachment exists, it can be linked to a specific payment as a [**note-attachment**](/note-text-and-attachment.md). This allows users to associate files like receipts or invoices directly with a transaction for easy retrieval. An optional description can also be added to give context to the attachment within the payment.
3. **Add text notes (optional):** Separately, users can also add plain text notes to a payment as a **note-text**, without uploading a file. This is useful for quick comments, explanations, or any textual reference that supplements the payment.

By following this multi-step approach—uploading the file, linking it to a payment, and optionally adding text—users can keep their payment history organized and fully annotated. This structured workflow ensures that all references to payments are clearly documented and easily retrievable within the bunq app.

#### Retrieving attachments

You can retrieve notes and attachments easily too simply use the GET endpoints too

```bash
GET /v1/user/{userID}/monetary-account/{monetary-accountID}/payment/{paymentID}/note-attachment HTTP/1.1
Host: public-api.sandbox.bunq.com
User-Agent: text
X-Bunq-Client-Authentication: text
Accept: */*

```

This will return you a attachment Object

```json
{
  "Response": [
    {
      "NoteText": {
        "id": 13602,
        "created": "2025-10-22 11:39:32.063494",
        "updated": "2025-10-22 11:39:32.063494",
        "label_user_creator": {
          "uuid": "7ce9f0d3-ccc8-434b-b3f2-490adb10e63e",
          "display_name": "V. Rosenstock",
          "country": "NL",
          "avatar": {
            "uuid": "9debf55b-70b1-4d43-8d51-d6e7bd42fb5b",
            "image": [
              {
                "attachment_public_uuid": "4b7e0d1d-9167-48ac-990a-70e342c87812",
                "height": 126,
                "width": 200,
                "content_type": "image/jpeg",
                "urls": [
                  {
                    "type": "ORIGINAL",
                    "url": "https://bunq-triage-model-storage-public.s3.eu-central-1.amazonaws.com/bunq_file/File/content/6979a145b7ea9ecc3459358122cb560608f02d36d4b8cd6b770f50e36aa35512.jpg"
                  }
                ]
              }
            ],
            "anchor_uuid": "7ce9f0d3-ccc8-434b-b3f2-490adb10e63e",
            "style": "NONE"
          },
          "public_nick_name": "Val",
          "type": "PERSON"
        },
        "content": "biierrr"
      }
    },
    {
      "NoteText": {
        "id": 13601,
        "created": "2025-10-22 11:39:27.952050",
        "updated": "2025-10-22 11:39:27.952050",
        "label_user_creator": {
          "uuid": "7ce9f0d3-ccc8-434b-b3f2-490adb10e63e",
          "display_name": "V. Rosenstock",
          "country": "NL",
          "avatar": {
            "uuid": "9debf55b-70b1-4d43-8d51-d6e7bd42fb5b",
            "image": [
              {
                "attachment_public_uuid": "4b7e0d1d-9167-48ac-990a-70e342c87812",
                "height": 126,
                "width": 200,
                "content_type": "image/jpeg",
                "urls": [
                  {
                    "type": "ORIGINAL",
                    "url": "https://bunq-triage-model-storage-public.s3.eu-central-1.amazonaws.com/bunq_file/File/content/6979a145b7ea9ecc3459358122cb560608f02d36d4b8cd6b770f50e36aa35512.jpg"
                  }
                ]
              }
            ],
            "anchor_uuid": "7ce9f0d3-ccc8-434b-b3f2-490adb10e63e",
            "style": "NONE"
          },
          "public_nick_name": "Val",
          "type": "PERSON"
        },
        "content": "HELLOOO"
      }
    },
    {
      "NoteText": {
        "id": 13600,
        "created": "2025-10-22 11:19:57.194687",
        "updated": "2025-10-22 11:19:57.194687",
        "label_user_creator": {
          "uuid": "7ce9f0d3-ccc8-434b-b3f2-490adb10e63e",
          "display_name": "V. Rosenstock",
          "country": "NL",
          "avatar": {
            "uuid": "9debf55b-70b1-4d43-8d51-d6e7bd42fb5b",
            "image": [
              {
                "attachment_public_uuid": "4b7e0d1d-9167-48ac-990a-70e342c87812",
                "height": 126,
                "width": 200,
                "content_type": "image/jpeg",
                "urls": [
                  {
                    "type": "ORIGINAL",
                    "url": "https://bunq-triage-model-storage-public.s3.eu-central-1.amazonaws.com/bunq_file/File/content/6979a145b7ea9ecc3459358122cb560608f02d36d4b8cd6b770f50e36aa35512.jpg"
                  }
                ]
              }
            ],
            "anchor_uuid": "7ce9f0d3-ccc8-434b-b3f2-490adb10e63e",
            "style": "NONE"
          },
          "public_nick_name": "Val",
          "type": "PERSON"
        },
        "content": "HELLOOO"
      }
    }
  ],
  "Pagination": {
    "future_url": "/v1/user/2580769/monetary-account/3320038/payment/28472876/note-text?newer_id=13602",
    "newer_url": null,
    "older_url": null
  }
}
```


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/note-text-and-attachment.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
