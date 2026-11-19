> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/psd2/rotating-your-qseal-certificate.md).

# Rotating your qseal certificate

When your qSEAL certificate is approaching its expiry date, or when your organisation needs to replace it (for example after a legal entity change or a new eIDAS issuance), you can register the new certificate without any interruption to your existing OAuth connections.

### How it works

Your OAuth connections are tied to your **TPP account**, not to any individual certificate. As long as your TPP account has at least one active certificate, all OAuth connections remain intact. This means you can register a new certificate while the old one is still active, verify everything works, and then let the old one expire — all without disrupting a single end-user connection.

bunq identifies your TPP account by the **organisation identifier** embedded in your qSEAL certificate (for example `PSDIE-CBI-C433487`). When you register a new certificate with the same organisation identifier, it is automatically linked to your existing TPP account.

### Step-by-step

#### Step 1 — Register the new certificate

Run the full TPP registration flow using your **new** qSEAL certificate. Use the same steps as your original registration: generate a new installation keypair, create an installation, sign with the new certificate's private key, and call `POST /v1/payment-service-provider-credential`.

See Register as a TPP for the full step-by-step.

Because the new certificate has the same organisation identifier as your existing registration, bunq links it to your existing TPP account automatically. You do not create a new TPP — you add a new credential to the existing one.

#### Step 2 — Register a device-server for the new credential

After receiving your new credential token, register a device-server with the permitted IPs you want to use:

{% code lineNumbers="true" %}

```bash
curl -X POST https://api.bunq.com/v1/device-server \
  -H "Content-Type: application/json
  -H "X-Bunq-Client-Request-Id: $(uuidgen)" \
  -H "X-Bunq-Client-Authentication:
  --data "{
    \"secret\": \"$NEW_CREDENTIAL_TO
    \"description\": \"My server (rotated cert)\",
    \"permitted_ips\": [\"*\"]
  }"
  
  

```

{% endcode %}

#### Step 3 — Verify the new certificate works

Create a session using the new credential and confirm your API calls succeed:

{% code lineNumbers="true" %}

```bash
SESSION_REQUEST_BODY="{\"secret\":\"$NEW_CREDENTIAL_TOKEN\"}"
echo -n "$SESSION_REQUEST_BODY" > session.request
openssl dgst -sign new_installation.key -keyform PEM -sha256 -out signature < session.request

curl -X POST https://api.bunq.com/v1/session-server \
  -H "Content-Type: application/json" \
  -H "X-Bunq-Client-Request-Id: $(uuidgen)" \
  -H "X-Bunq-Client-Authentication: $NEW_INSTALLATION_TOKEN" \
  -H "X-Bunq-Client-Signature: $(cat signature | base64)" \
  --data "$SESSION_REQUEST_BODY"
```

{% endcode %}

#### Step 4 — Let the old certificate expire

Once you have verified the new certificate is working, you can let the old one expire naturally. bunq's background process will clean up the old credential automatically. You do not need to delete or deactivate the old certificate manually.

{% hint style="info" %}

## Important: do not let all certificates lapse simultaneously

If your TPP account has no active certificates at all — because the old one expired before the new one was registered — bunq will block your OAuth clients and your TPP account. All end-user connections will be interrupted.
{% endhint %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/psd2/rotating-your-qseal-certificate.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
