> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/psd2/are-you-a-third-party-provider-tpp-start-here/register-as-a-tpp.md).

# Register as a TPP

## Register as a TPP

This guide will walk you through the steps to register as a Third-Party Provider (TPP) with bunq. If you're a PSD2-certified company, you'll learn how to authenticate with the bunq API, register your certificate, and start using your credentials to access the data and services you're authorized for. Pre-Requisite You must generate a 2048-bit RSA key pair beforehand.

You'll need your QSeal certificate (Qualified Seal Certificate), including intermediate and root certificate chain.

OpenSSL and curl installed

Basic knowledge of command line

The easiest way to register is via command line, but you can also implement this in your code. If you're in a hurry and just want to test in the Sandbox environment. We bundled all commands on this page into 1 bash script that creates a PSD2 user and registers it for you. You'll just get an API key for that created user that you can use for the rest of your implementation Although a script provides you with a quick way to get started, we do recommend you read this page thorougly before moving into production. Link to script

🛠️ Step-by-Step Integration

1. Generate Installation Key Pair These keys are used to register your app installation with bunq:

## Public key: installation.pub

## Private key: installation.key

openssl genrsa -out installation.key && openssl rsa -in installation.key -outform PEM -pubout -out installation.pub

2. (Sandbox only) Generate a test PSD2 Certificate The certificate is not validated in sandbox, so you can create as many as you need. Just make sure to use the qSEAL certificate when moving to production.

Replace the subject /CN=.../C=... with your own details as needed.

## Certificate: psd2.cert

## Private key: psd2.key

openssl req -x509 -newkey rsa:4096 -keyout psd2.key -out psd2.cert -days 365 -nodes -subj "/CN=Test PISP AISP $(uuidgen)/C=NL"

3. Create Installation This step registers your public key with bunq and returns an installation token. The client\_public\_key is the public part of the key pair you generated earlier using OpenSSL. This key is sent to bunq so we know how to verify future requests from your integration. What the API expects here is: A PEM-formatted public key (typically starting with -----BEGIN PUBLIC KEY----- and ending with -----END PUBLIC KEY-----)

All line breaks and formatting preserved correctly as a single escaped string (so it fits into the JSON payload)

Here's an example of a formatted public key: "-----BEGIN PUBLIC KEY-----\nMIIBITANBgkqhkiG9w0BAQEFAAOCAQ4AMIIBCQKCAQBKvVUm/gMi7NmTQImtpX1K\nTFMy3BQPvi6uYWMIIy/YHlZNGZbseKyo/dSa22VnFitjoJAt1S6iy04iuiYKCo4p\nUT9jNhn+JW7+U5Ptia6Y1yDwAqioeuL90suO6XLk35Vj7uuyXxlZO3u79/nPJrmp\nmYx2kEhEEISVWd9+TAFrFjImdGVd6DXK4d3D8/tH4GwILcmL7PbigbFLjeCVbkUi\nFqSiMgtQJkHVHhwedwLehuNg/oL3MRBw1bIxrYnjpO6qfyWoYNmCKYo3KgZYrQZ8\nVUjD0bpyfZEWX3+c849nemRdDa8eUZqjzneV2P/m96iiLWbve5KKSklSz2UtCecD\nAgMBAAE=\n-----END PUBLIC KEY-----\n"

You can call the installation endpoint by using the following command line: INSTALLATION=$(curl -X POST <https://public-api.sandbox.bunq.com/v1/installation\\>
-H "Accept: application/json"\
-H "Content-Type: application/json"\
-H "X-Bunq-Client-Request-Id: $(uuidgen)"\
\--data "{"client\_public\_key": "$(awk 'NF {sub(/\r/, ""); printf "%s\n", $0;}' installation.pub)"}")

Here is the full specification of the endpoint:

4. Generate the Signature This proves ownership of your PSD2 certificate by signing the public key and token. Make sure there is NO new line at the end of the file! Otherwise, the signature will be invalid.

Extract the installation\_token from the previous step:

TOKEN=$(echo $INSTALLATION | grep -o '"token":"\[A-Za-z0-9]\*"' | cut -d '"' -f 4) echo -n $TOKEN > installation.token

Take the server\_public\_key of the installation you also received in the previous step.

Append the token

Sign the string using the private key of your PSD2 certificate

openssl dgst -sign psd2.key -keyform PEM -sha256 -out signature <(cat installation.pub installation.token)

This base64 string should be passed as value of client\_public\_key\_signature in the next step.

6. Create Payment Service Provider Credential Use your certificate and signature to request your TPP credentials in bunq's API. Here is the command line code: CREDENTIAL=$(curl -X POST <https://public-api.sandbox.bunq.com/v1/payment-service-provider-credential\\>
   -H "Accept: application/json"\
   -H "Content-Type: application/json"\
   -H "X-Bunq-Client-Request-Id: $(uuidgen)"\
   -H "X-Bunq-Client-Authentication: $TOKEN"\
   \--data "{ "client\_payment\_service\_provider\_certificate": "$(awk 'NF {sub(/\r/, ""); printf "%s\n", $0;}' psd2.cert)", "client\_payment\_service\_provider\_certificate\_chain": "$(awk 'NF {sub(/\r/, ""); printf "%s\n", $0;}' psd2.cert)", "client\_public\_key\_signature": "$(cat signature | base64)" }")

You can repeat the same value on the client\_payment\_service\_provider\_certificate and client\_payment\_service\_provider\_certificate\_chain in sandbox, but please ensure you have your certificate chain ready when going to production, otherwise the call will fail.

Save the response for the next step: echo $CREDENTIAL > credential.json

Here is the full specification of the endpoint:

It's good to know that if you register as a Payment Server Provider you will not be a 'typical' USER\_PERSON or USER\_COMPANY ( ). Instead you'll become a UserPaymentServiceProvider - this is a special kind of user that only serves as a user for your OAuth installation. This user type will not have any bank accounts or payments of it's own. You can only manage that user through our API

> **Need to update your PSD2 certificate?** See the dedicated guide: [Rotating your qSEAL Certificate](https://github.com/bunq/gitbook-documentation/tree/master/psd2/are-you-a-third-party-provider-tpp-start-here/rotating-your-qseal-certificate/README.md)

7. Extract Credential Token and register Your Device After creating a credential in the previous step, you'll receive a credential\_token, which acts as a unique secret. This token is required when registering your device using POST /device-server. Registering the device is an important security step—it lets bunq know where the API calls are coming from and links your setup to a specific environment (like your server or app). By sending the credential token as the secret, you're proving that your device is authorized to operate under your PSD2 certificate and credentials. Without this step, bunq can't associate API activity with a verified, trusted source. Here's the bash code to extract your credential\_token from the credential.json (saved in the last step): CREDENTIAL\_TOKEN=$(cat credential.json | grep -o '"token\_value":"\[A-Za-z0-9]\*"' | cut -d '"' -f 4)

With that value in hands, you can then call the endpoint POST /device-server and register your device: curl -X POST <https://public-api.sandbox.bunq.com/v1/device-server\\>
-H "Accept: application/json"\
-H "Content-Type: application/json"\
-H "X-Bunq-Client-Request-Id: $(uuidgen)"\
-H "X-Bunq-Client-Authentication: $TOKEN"\
\--data "{"secret":"$CREDENTIAL\_TOKEN", "description": "My server"}"

IP addresses When using a standard API Key the DeviceServer and Installation that are created in this process are bound to the IP address they are created from. Using a Wildcard API Key gives you the freedom to make API calls from any IP address after the POST device-server. You can switch to a Wildcard API Key by tapping on "Allow All IP Addresses" in your API Key menu inside the bunq app. You can also programatically switch to a Wildcard API Key by passing your current ip and a \* (asterisk) in the permitted\_ips field of the device-server POST call. E.g: \["1.2.3.4", "\*"].

Here is the full specification of the endpoint:

9. Sign the Session Request We are legally required to protect our users and their data from malicious attacks and intrusions. That is why we beyond having a secure https connection, we use asymmetric cryptography for signing requests that create a session or payment. The use of signatures ensures the data is coming from the trusted party and was not modified after sending and before receiving. In this step, you're preparing to create a session with bunq's API, which requires proving your identity using a digital signature. SESSION\_REQUEST\_BODY="{"secret":"$CREDENTIAL\_TOKEN"}" echo -n $SESSION\_REQUEST\_BODY > session.request

Make sure there is NO new line at the end of the file! Otherwise, the signature will be invalid.

Then you'll digitally sign the contents of the request body using your installation private key. This proves to bunq that the request really comes from someone in control of the private key tied to your public key. After, you'll encode the binary signature into base64 so it can be safely sent in the signature HTTP header from the next step. openssl dgst -sign installation.key -keyform PEM -sha256 -out signature < session.request SESSION\_REQUEST\_SIGNATURE=$(cat signature | base64)

Troubleshooting If you get an error telling you "The request signature is invalid", please check the following: There are no redundant characters (extra spaces, trailing line breaks, etc.) in the data to sign.

Make sure the body is appended to the data to sign exactly as you're adding it to the request.

You have added the full body to the data to sign.

You use the data to sign to create a SHA256 hash signature.

You have base64 encoded the SHA256 hash signature before adding it to the request under X-Bunq-Client-Signature.

You can find more info about signing the request body in this link here.

11. Create Session The POST /session-server endpoint is used to start a new session with the bunq API. Once your device is registered and you've created a valid credential, this call creates an authenticated session. The session ensures secure, time-limited access to the bunq API on behalf of your registered device and credentials. curl -X POST <https://public-api.sandbox.bunq.com/v1/session-server\\>
    -H "Accept: application/json"\
    -H "Content-Type: application/json"\
    -H "X-Bunq-Client-Request-Id: $(uuidgen)"\
    -H "X-Bunq-Client-Signature: $SESSION\_REQUEST\_SIGNATURE"\
    -H "X-Bunq-Client-Authentication: $TOKEN"\
    \--data "$SESSION\_REQUEST\_BODY"

The response will contain a session\_token. Use this token in the X-Bunq-Client-Authentication header for all subsequent API calls.

Here is the full specification of the endpoint:

✅ You're Ready! You've now successfully authenticated with the bunq Public API as a PSD2-certified provider. Now you're ready to set up the OAuth with your end user and start using the API in accordance with your certified roles (AISP, PISP, or CBPII). Please refer to this page on how to set up OAuth:

📝 Reminder All integration steps must be repeated in the production environment with your real eIDAS certificate when you're ready to go live.

Ready to continue? You can check what you can do with bunq's API according to your role in these pages here:


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/psd2/are-you-a-third-party-provider-tpp-start-here/register-as-a-tpp.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
