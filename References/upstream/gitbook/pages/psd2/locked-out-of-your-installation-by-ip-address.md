> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/psd2/locked-out-of-your-installation-by-ip-address.md).

# Locked out of your installation by IP address

If your server's IP address has changed since you first registered, or you need to add new IPs to your integration, you will start receiving this error:

`User credentials are incorrect. Incorrect API key or IP address.`

This page explains why this happens and how to fix it.

***

Why this happens

When you [register a device-server](/tutorials/your-first-payment/creating-the-api-context/device-registration.md), the IP address you call from is whitelisted for that credential. Only requests from an ACTIVE [whitelisted IP](/basics/whitelisting-and-updating-ip-addresses.md) are accepted. If your server's IP has changed, or you need to add new IPs, you will be blocked until the new IPs are added to your credential's whitelist.

***

#### Option 1 — Add the new IP to your existing credential

If you can still make API calls from one of your currently whitelisted IPs, you can add new IPs directly using the credential IP management endpoint. No new installation or device-server is needed.

You will need your credential ID. You can retrieve it by listing your credentials:

▎ GET /v1/user/{userID}/credential-password-ip

Once you have it, add each new IP by posting to:

▎ POST /v1/user/{userID}/credential-password-ip/{credentialID}/ip

To deactivate an old IP you no longer use, update its status:

▎ PUT /v1/user/{userID}/credential-password-ip/{credentialID}/ip/{ipID}

Note: the IP address itself cannot be modified — only its status (ACTIVE or INACTIVE). To replace an IP, deactivate the old one and add the new one.

Reference : [Whitelisting and Updating IP addresses](/basics/whitelisting-and-updating-ip-addresses.md)

***

#### Option 2 — Fully locked out (can't call from any registered IP)

If you no longer have access from any of your registered IPs, you need to create a new credential using your existing qSEAL certificate and register a new device-server with the correct IPs.

This is the same process as [registering a new certificate](/psd2/rotating-your-qseal-certificate.md) — your existing qSEAL certificate can be reused and bunq will automatically link the new credential to your existing TPP account. Follow the steps in Rotating your qSEAL Certificate.

▎ Note: The old device-server does not need to be deleted. Your new credential is entirely independent and its IP rules are not affected by the old device-server.

***


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/psd2/locked-out-of-your-installation-by-ip-address.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
