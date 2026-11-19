> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/how-to-manage-your-cards/ordering-a-card.md).

# Ordering a card

So we want to lend out our bunq card to a friend but still maintain full control over spending. The first thing we need is, in fact a card. So let's order one.

## What card do we want?

There are several different types of card available within bunq. You can check out our [Cards](/api-reference/cards.md) section in the API reference. The first pick is between [Card Credit](/api-reference/cards/card-credit.md) or [Card Debit](/api-reference/cards/card-debit.md). Once you have chosen one we can start constructing the API call to order a card. Pay attention to the Alias that the card is connected to. This is the pointer to the monetary account that will be connected at first with the card. Its IBAN code is also the one that will be printed on the card itself. The pointer must be of type IBAN.

For this example we'll use the credit card API endpoint like so:

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/user/{userID}/card-credit" method="post" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}

#### Now once we have created the card we can move on to the next step: setting a pin code and a limit for our friend. So that they can only use the card 1x within those limits. Let's go to setting Limits and updating the pin


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/how-to-manage-your-cards/ordering-a-card.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
