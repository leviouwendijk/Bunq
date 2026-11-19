> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/whitelisting-and-updating-ip-addresses.md).

# Whitelisting and Updating IP addresses

### Why Whitelist IP Addresses?

Whitelisting IP addresses is a critical security measure that restricts which API calls are accepted by our backend. By explicitly listing trusted IP addresses, you minimize the risk of unauthorized access from unknown or malicious locations. This ensures that even if someone obtains your password credential, they cannot authenticate unless their IP is authorized.

In short: **IP whitelisting helps protect your account by allowing server authentication only from trusted networks.**

### Default Behavior

The IP address you pass along in you  is automatically whitelisted to be used for API calls and set to ACTIVE. If you pass in a wildcard `["*"]` then we chose the IP address used for the API call. Whitelisting IP addresses is risky and only possible from within our app.

So if you don't change anything this will be the default behavior

* The IP address you use during device registration will be immediately usable.
* Other IPs are not allowed until explicitly added.
* This default auto-whitelisting ensures smooth onboarding without manual IP setup.

***

### Key Concepts

#### CredentialPasswordIp

This is your credential linked to your  used for server-side authentication. Each credential has IP addresses associated with it.

#### IP Entries

Each credential can have multiple IP addresses whitelisted, with the following attributes:

* **ip**: The IP address allowed to authenticate.
* **status**: Either
  * `ACTIVE`: This IP is allowed to authenticate (and will be billed).
  * `INACTIVE`: This IP is blocked and cannot be used.

> **Note:** IP addresses cannot be changed once created. To update an IP, you must mark the old one as `INACTIVE` and add a new one.

***

### Important Notes

* The wildcard IP `*` (which disables IP filtering, allowing all IPs) **cannot be created or managed via the API** — only via the bunq app. This is to prevent accidental security risks through API misuse.
* Only `ACTIVE` IP addresses can be used to authenticate.
* Carefully manage your IP whitelist to control access and reduce attack surface.

***

### API Operations Overview

#### Reference

Visit this page for all the API calls related to IP whitelisting:&#x20;

#### Credentials Management

* **List Credentials**\
  `GET /v1/user/{user_id}/credential-password-ip`\
  Lists all password credentials for your user.
* **Get Credential**\
  `GET /v1/user/{user_id}/credential-password-ip/{credential_password_ip_id}`\
  Retrieves details for a specific credential.

#### IP Addresses Management

* **List IPs for a Credential**\
  `GET /v1/user/{user_id}/credential-password-ip/{credential_password_ip_id}/ip`\
  Lists all IPs whitelisted for the credential.
* **Get a Single IP Entry**\
  `GET /v1/user/{user_id}/credential-password-ip/{credential_password_ip_id}/ip/{item_id}`\
  Retrieves details of a specific IP entry.
* **Add a New IP**\
  `POST /v1/user/{user_id}/credential-password-ip/{credential_password_ip_id}/ip`\
  Adds a new IP address with a status (`ACTIVE` or `INACTIVE`).
* **Update IP Status**\
  `PUT /v1/user/{user_id}/credential-password-ip/{credential_password_ip_id}/ip/{item_id}`\
  Updates the status from `ACTIVE` to `INACTIVE` of an existing IP.\
  \_Note:\_ The IP address itself **cannot** be changed.

***

### Security Best Practices

* Regularly review and update your IP whitelist to remove unused or suspicious IPs.
* Avoid using the wildcard IP `*` unless absolutely necessary and only via the bunq app.
* Set inactive IPs to `INACTIVE` rather than deleting immediately for audit trails.
* Use distinct credentials per environment (dev, staging, prod) with tailored IP whitelists.

***


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/whitelisting-and-updating-ip-addresses.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
