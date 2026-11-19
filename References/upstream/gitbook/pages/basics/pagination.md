> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/pagination.md).

# Pagination

To control the size of the response of a list request, items can be paginated.

A **list request** is a request that is meant to retrieve a large number of items such as all payments of a certain monetary account `GET /v1/user/1/monetary-account/1/payment`. You can choose the maximum amount of items to be included in the response by adding a `count` query parameter with the number of items you want per page to the URL.

**Example:** `GET /v1/user/1/monetary-account/1/payment?count=25`

When no `count` is given, the default count is set to 10. The maximum `count` you can set is 200.

With every listing, a `Pagination` object will be added to the response. It will contain the URLs you need to use to get the next or previous set of items. You can also use these URLs to navigate through the listed resources.

Here is what a `Pagination` object looks like:

Copy

```
{
    "Pagination": {
        "future_url": null,
        "newer_url": "/v1/user/1/monetary-account/1/payment?count=25&newer_id=249",
        "older_url": "/v1/user/1/monetary-account/1/payment?count=25&older_id=224"
    }
}
```

The `newer_url` value can be used to get the next page.

* The `newer_id` is always the `id` of the last item in the current page.
* If `newer_url` is `null`, there are no more items to be listed on the next page. The next page thus does not exist.

The `older_url` value can be used to get the previous page.

* The `older_id` is always the `id` of the first item in the current page.
* If `older_url` is `null`, there are no items on the previous page. The previous page thus does not exist.

The `future_url` can be used to refresh the list and check for new items that didn’t exist when the listing was requested. The `future_url` will be `null` if the `newer_id` is already the ID of the latest item.

### Pagination Behavior Explained

When you request a paginated list of payments, the response includes a `Pagination` object with up to three navigation URLs:

| Key          | Purpose                                                            | Example URL                                                  |
| ------------ | ------------------------------------------------------------------ | ------------------------------------------------------------ |
| `newer_url`  | Fetches the next (more recent) page of payments                    | `null` means you're already viewing the most recent payments |
| `older_url`  | Fetches the previous (older) page of payments                      | `/payment?count=3&older_id=118`                              |
| `future_url` | Lets you refresh the list to check if new payments have been added | `/payment?count=3&newer_id=120`                              |

***

**Example**

Suppose you call:

```
GET /v1/user/1/monetary-account/1/payment?count=3
```

You receive:

```json
{
  "payments": [... 3 payment objects],
  "Pagination": {
    "future_url": "/v1/user/1/monetary-account/1/payment?count=3&newer_id=120",
    "newer_url": null,
    "older_url": "/v1/user/1/monetary-account/1/payment?count=3&older_id=118"
  }
}
```

**What this tells you:**

* `newer_url: null` → You're already seeing the **most recent** payments.
* `older_url` exists → There are **older payments** available. Follow this URL to go back in time.
* `future_url` exists → You can use this to **check later** if new payments were added **after ID 120**.

If you later follow the `future_url` and no new payments exist, it will return:

```json
"Pagination": {
  "future_url": null
}
```

This confirms your list is **up to date**.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/pagination.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
