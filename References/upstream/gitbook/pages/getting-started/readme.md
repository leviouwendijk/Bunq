> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/getting-started/readme.md).

# Welcome to the bunq API documentation

{% hint style="danger" %}
By integrating with bunq's Public API, you agree to comply with bunq’s [**Terms & Conditions**](https://static.bunq.com/website/documents/bunq-terms-conditions-api-en.pdf) and all applicable usage policies. Please **review them carefully** before getting started.
{% endhint %}

Hi there! Thanks for stopping by. The bunq API is a powerful way to automate your banking and build custom experiences around your finances—with over 300 available operations to play with.

We get it—because it’s so flexible, the API can feel a bit overwhelming at first. That’s why this guide is here: to help you understand how bunq works behind the scenes, so you can quickly find the right endpoints and build your integration with confidence.

Let’s start by exploring the key building blocks of the bunq API and how they relate to each other.

### Jump right in

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-cover data-type="files"></th><th data-hidden></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Tools</strong></td><td>These are the main tools we offer to help you get started right away!</td><td><a href="https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-92e8923c139b44e5df363524a7dcc145db961a5b%2FBriefcase%20and%20Laptop%20with%20bunq%20Web.svg?alt=media">Briefcase and Laptop with bunq Web.svg</a></td><td></td><td><a href="/getting-started/tools.md">Tools</a></td></tr><tr><td><strong>Basics</strong></td><td>Everything you need to start your integration</td><td><a href="https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-61a73b15f42539990d1409ac088580b798ce5b71%2FCode%20Gear.png?alt=media">Code Gear.png</a></td><td></td><td><a href="/basics/getting-started.md">Basics</a></td></tr><tr><td><strong>Tutorials</strong></td><td>Want a step-by-step of our implementations? Check it here!</td><td><a href="https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-2cbda0b1364bdbfdd85fa810dcb3b5d3ab9a1bd3%2FFlying%20Roller%20Skates.png?alt=media">Flying Roller Skates.png</a></td><td></td><td><a href="/tutorials/your-first-payment.md">TUTORIALS</a></td></tr><tr><td><strong>Third Party Providers</strong></td><td>Are you an Open Banking PSD2 certified partner trying to connect to bunq? Check how to do it here!</td><td><a href="https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-07a2341ed223c24d74ce6e42399da4e7daed897d%2FEU%20and%20bunq%20Flags.png?alt=media">EU and bunq Flags.png</a></td><td></td><td><a href="/psd2/are-you-a-third-party-provider-tpp-start-here.md">PSD2</a></td></tr><tr><td><strong>Need help?</strong></td><td>Check our FAQ and our support channels here!</td><td><a href="https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-ea40065f090c297841cefcdb5de7b0d01bb6d3b8%2FFinn.png?alt=media">Finn.png</a></td><td></td><td><a href="/support/api-support-team.md">API Support Team</a></td></tr></tbody></table>


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/getting-started/readme.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
