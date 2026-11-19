> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/your-first-payment/creating-the-api-context/creating-the-installation.md).

# Creating the Installation

### 1. Installation

Installation is the first step in activating your API key!

It creates an **API context**, which is a secure foundation for all future interactions. This step ensures that the API key is properly registered and associated with a trusted user, reducing the risk of unauthorized access. Without installation, the API key alone could be misused if leaked. This is similar to setting up encryption keys before securely exchanging data.

Firstly, you'll need to generate a public-private key pair using OpenSSL following these steps:

1. Open a terminal.
2. Run the following command to generate the key pair:

   ```powershell
   openssl genrsa -out installation.key && openssl rsa -in installation.key -outform PEM -pubout -out installation.pub
   ```
3. Your installation key pair will be stored as:

   ```powershell
   $(pwd)/installation.pub #your public-key
   $(pwd)/installation.key #your private-key
   ```
4. Copy the installation.pub value

   ```powershell
   cat ~(pwd)/installation.pub | pbcopy #this command can be different depending on your Operating System.
   ```

After generating your key pair, you'll be able to pass the `installation.pub` in the request body as value for the field `client_public_key`.

Here you can find all required fields for the installation endpoint:

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/installation" method="post" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}

### Retrieving Server Public Key

If at any point you want to retrieve the public key of the server you simply make a GET rquest on the installation.

## GET /installation/{installationID}/server-public-key

> Show the ServerPublicKey for this Installation.

```json
{"openapi":"3.0.0","info":{"title":"bunq API","version":"1.0"},"tags":[{"name":"server-public-key","description":""}],"servers":[{"url":"https://public-api.sandbox.bunq.com/{basePath}","description":"Sandbox server","variables":{"basePath":{"default":"v1"}}},{"url":"https://api.bunq.com/{basePath}","description":"Production server","variables":{"basePath":{"default":"v1"}}}],"paths":{"/installation/{installationID}/server-public-key":{"get":{"tags":["server-public-key"],"summary":"","operationId":"List_all_ServerPublicKey_for_Installation","description":"Show the ServerPublicKey for this Installation.","parameters":[{"in":"path","name":"installationID","description":"","required":true,"schema":{"type":"integer"}},{"$ref":"#/components/parameters/Cache-Control"},{"$ref":"#/components/parameters/User-Agent"},{"$ref":"#/components/parameters/X-Bunq-Language"},{"$ref":"#/components/parameters/X-Bunq-Region"},{"$ref":"#/components/parameters/X-Bunq-Client-Request-Id"},{"$ref":"#/components/parameters/X-Bunq-Geolocation"},{"$ref":"#/components/parameters/X-Bunq-Client-Authentication"}],"responses":{"200":{"description":"Using /installation/_/server-public-key you can request the ServerPublicKey again. This is done by referring to the id of the Installation.","content":{"application/json":{"schema":{"type":"array","items":{"$ref":"#/components/schemas/InstallationServerPublicKeyListing"}}}},"headers":{"X-Bunq-Client-Response-Id":{"$ref":"#/components/headers/X-Bunq-Client-Response-Id"},"X-Bunq-Client-Request-Id":{"$ref":"#/components/headers/X-Bunq-Client-Request-Id"},"X-Bunq-Server-Signature":{"$ref":"#/components/headers/X-Bunq-Server-Signature"}}},"400":{"$ref":"#/components/responses/GenericError"}}}}},"components":{"parameters":{"Cache-Control":{"description":"The standard HTTP Cache-Control header is required for all signed requests.","schema":{"type":"string"},"required":false,"in":"header","name":"Cache-Control"},"User-Agent":{"description":"The User-Agent header field should contain information about the user agent originating the request. There are no restrictions on the value of this header.","schema":{"type":"string"},"required":true,"in":"header","name":"User-Agent"},"X-Bunq-Language":{"description":"The X-Bunq-Language header must contain a preferred language indication. The value of this header is formatted as a ISO 639-1 language code plus a ISO 3166-1 alpha-2 country code, separated by an underscore. Currently only the languages en_US and nl_NL are supported. Anything else will default to en_US.","schema":{"type":"string"},"required":false,"in":"header","name":"X-Bunq-Language"},"X-Bunq-Region":{"description":"The X-Bunq-Region header must contain the region (country) of the client device. The value of this header is formatted as a ISO 639-1 language code plus a ISO 3166-1 alpha-2 country code, separated by an underscore.","schema":{"type":"string"},"required":false,"in":"header","name":"X-Bunq-Region"},"X-Bunq-Client-Request-Id":{"description":"This header must specify an ID with each request that is unique for the logged in user. There are no restrictions for the format of this ID. However, the server will respond with an error when the same ID is used again on the same DeviceServer.","schema":{"type":"string"},"required":false,"in":"header","name":"X-Bunq-Client-Request-Id"},"X-Bunq-Geolocation":{"description":"This header must specify the geolocation of the device. The format of this value is longitude latitude altitude radius country. The country is expected to be formatted of an ISO 3166-1 alpha-2 country code. When no geolocation is available or known the header must still be included but can be zero valued.","schema":{"type":"string"},"required":false,"in":"header","name":"X-Bunq-Geolocation"},"X-Bunq-Client-Authentication":{"description":"The authentication token is used to authenticate the source of the API call. It is required by all API calls except for POST /v1/installation. It is important to note that the device and session calls are using the token from the response of the installation call, while all the other calls use the token from the response of the session-server call","schema":{"type":"string"},"required":true,"in":"header","name":"X-Bunq-Client-Authentication"}},"schemas":{"InstallationServerPublicKeyListing":{"type":"object","properties":{"server_public_key":{"type":"string","description":"The server's public key for this Installation.","readOnly":true,"writeOnly":false}}},"Error":{"type":"array","items":{"type":"object","properties":{"error_description":{"type":"string","description":"The error description in English."},"error_description_translated":{"type":"string","description":"The error description translated to the user's language."}}}}},"headers":{"X-Bunq-Client-Response-Id":{"description":"A unique ID for the response formatted as a UUID. Clients can use it to add extra protection against replay attacks.","schema":{"type":"string"}},"X-Bunq-Client-Request-Id":{"description":"This header must specify an ID with each request that is unique for the logged in user. There are no restrictions for the format of this ID. However, the server will respond with an error when the same ID is used again on the same DeviceServer.","schema":{"type":"string"},"required":false},"X-Bunq-Server-Signature":{"description":"The server's signature for this response. See the signing page for details on how to verify this signature.","schema":{"type":"string"}}},"responses":{"GenericError":{"description":"This is how the error response looks like for 4XX response codes","headers":{"X-Bunq-Client-Response-Id":{"$ref":"#/components/headers/X-Bunq-Client-Response-Id"},"X-Bunq-Client-Request-Id":{"$ref":"#/components/headers/X-Bunq-Client-Request-Id"},"X-Bunq-Server-Signature":{"$ref":"#/components/headers/X-Bunq-Server-Signature"}},"content":{"application/json":{"schema":{"type":"object","properties":{"Error":{"$ref":"#/components/schemas/Error"}}}}}}}}}
```

###

### What's next

With the `installation_token` and the `server_public_key` in hands, we are able to authenticate ourselves and register our device for future endpoint calls.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/your-first-payment/creating-the-api-context/creating-the-installation.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
