> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/how-to-manage-your-cards/introduction.md).

# Introduction

## How to Temporarily Share Your bunq Card with a Friend (With Limits & PIN Control)

Have you ever wanted to lend your bunq card to a friend but still maintain full control over spending? With the bunq API, you can dynamically set spending limits, change the PIN code, and even revert everything back to normal once your friend is done using the card. So that's what we'll focus on in this tutorial. To give you a grasp on what is possible using our API.

In this tutorial, we’ll build a simple application that:

* Temporarily assigns your card to a friend’s account
* Sets a spending limit to prevent overspending
* Changes the PIN code for security
* Restores your original settings once the card is returned

By the end of this guide, you’ll understand how to programmatically control your bunq card with the API, ensuring security and flexibility. Step 1 is ordering a card, Let’s dive in!


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/how-to-manage-your-cards/introduction.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
