> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/banking-as-a-service/cards-as-a-service.md).

# Cards - As a Service

## Cards

bunq's card issuing API lets you create and manage Mastercard debit cards linked directly to your users' monetary accounts. Cards work everywhere Mastercard is accepted — online, in-store, and in digital wallets.

***

### The paradigm

In bunq, every card is linked to a monetary account. Spending on the card debits that account in real time. You control the card lifecycle — from creation and PIN management to spending limits, freezing, and cancellation — entirely through the API.

bunq issues two card types:

* **Virtual cards** — available immediately after creation, delivered as a card number, expiry, and CVC. Ideal for online purchases, subscriptions, and digital wallet provisioning.
* **Physical cards** — shipped to the cardholder's address. Same API creation flow; delivery typically takes 5–7 business days within the EU.

Key things to understand:

* **One card, one account.** A card is always linked to exactly one monetary account. Changing the linked account is supported — useful if you want to redirect spending to a different balance.
* **Spending limits.** You can set daily, weekly, or monthly spending limits per card via the API. You can also restrict the card to specific MCC (merchant category) codes.
* **CVC2 generation.** For virtual cards, you generate a fresh CVC2 on demand via API. CVC2s are valid for a short window and regenerated each time — there is no stored static CVC.
* **Freezing and unfreezing.** Cards can be frozen instantly via API (e.g. if a user reports it missing) and unfrozen just as quickly.
* **Callbacks.** Register a notification filter to receive real-time events for authorisations, settlements, and declines.

***

### Flow overview

**Issuing a virtual card:**

```
Your platform                    bunq API
─────────────                    ────────
POST /card-virtual           →   Creates card, returns PAN + expiry
POST /generated-cvc2         →   Returns a fresh CVC2 for the card
                             ←   Card ready for use
```

**Handling a transaction:**

```
Cardholder makes a purchase       bunq API         Your platform
──────────────────────────        ────────         ─────────────
Card presented at merchant    →   Authorisation
                              →   Callback: CARD_TRANSACTION_AUTHORISED → Your webhook
Settlement (T+1)              →   Payment object created on account
```

***

### Relevant API endpoints

| Action                                     | Endpoint                                                                                                                       |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| Issue a virtual card                       | [`POST /v1/user/{userID}/card-virtual`](https://doc.bunq.com/api-reference/cards)                                              |
| List cards for a user                      | [`GET /v1/user/{userID}/card`](https://doc.bunq.com/api-reference/cards)                                                       |
| Get card details                           | [`GET /v1/user/{userID}/card/{itemID}`](https://doc.bunq.com/api-reference/cards)                                              |
| Update card (limits, freeze, link account) | [`PUT /v1/user/{userID}/card/{itemID}`](https://doc.bunq.com/api-reference/cards)                                              |
| Generate a CVC2                            | [`POST /v1/user/{userID}/card/{cardID}/generated-cvc2`](https://doc.bunq.com/api-reference/generated-cvc2)                     |
| List card transactions                     | [`GET /v1/user/{userID}/monetary-account/{accountID}/mastercard-action`](https://doc.bunq.com/api-reference/mastercard-action) |
| Register card callbacks                    | [`POST /v1/user/{userID}/notification-filter-url`](https://doc.bunq.com/api-reference/notification-filter-url)                 |

***

### Card object highlights

The card object returned after creation includes:

* `id` — your persistent reference for this card
* `pan_link` — a link to the card's full PAN (fetched separately for PCI compliance reasons)
* `expiry_date` — in `YYYY-MM` format
* `status` — `ACTIVE`, `DEACTIVATED`, `SUSPENDED`, `EXPIRED`
* `limit` — array of spending limit objects, each with `value`, `currency`, and `type` (daily/weekly/monthly)
* `primary_account_number_four_digit` — last four digits, safe to display in your UI

***

### Common integration patterns

**Pattern 1 — Instant virtual card per user.** Issue a virtual card at the end of KYC + account creation. The user gets a card they can add to Apple Pay / Google Pay immediately, without waiting for a physical card.

**Pattern 2 — Expense cards with limits.** Issue cards to employees or contractors with a fixed monthly spending limit and MCC restrictions. Adjust limits dynamically as budgets change — no need to reissue the card.

**Pattern 3 — Disposable cards.** Issue a virtual card for a single transaction or campaign, then cancel it. Eliminates the risk of recurring merchant charges or data exposure from a compromised PAN.

**Pattern 4 — Freeze on suspicious activity.** Use your own fraud signals to freeze a card instantly via `PUT /card/{id}` with `status: SUSPENDED`. Unfreeze just as quickly once verified. Pair with transaction callbacks to act in near-real-time.

***

{% hint style="info" %}
Physical card orders require a verified postal address on the sub-user's profile. Make sure the user's address is set before calling the physical card creation endpoint.
{% endhint %}

{% hint style="info" %}
CVC2 values must not be stored. Generate them on demand and display them directly to the cardholder. Storing CVC2s violates PCI DSS requirements.
{% endhint %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/banking-as-a-service/cards-as-a-service.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
