> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/your-first-payment/creating-the-api-context/device-registration.md).

# Device Registration

Registering a device links the API key to a specific phone, computer, or in the case of the API a server.

By using `POST /device-server`, bunq ensures that only pre-approved machines can make API calls. This approach is crucial in banking, where unauthorized access could lead to financial fraud. Unlike simple API keys, this extra layer significantly **reduces attack surfaces** by restricting access to known, registered devices.

{% hint style="warning" %}
Ensure you have a **bunq API Key**. You can generate one from the bunq APP if you haven't already.
{% endhint %}

#### IP addresses

When you use a standard API Key, the `DeviceServer` and `Installation` are linked to the IP address where they were created. You won’t be able to add new IP addresses later.

Using a Wildcard API Key gives you the freedom to make API calls from any IP address after the `POST device-server`. You can switch to a Wildcard API Key by tapping on “Allow All IP Addresses” in your API Key menu inside the bunq app. You can also programatically switch to a Wildcard API Key by passing your current ip and a `*` (asterisk) in the `permitted_ips` field of the device-server POST call.

Payload example:

```json
{
	"description": "My awesome APP",
	"secret": "{api_key}",
	"permitted_ips": ["1.2.3.4", "*"]
}
```

{% hint style="info" %}
bunq currently only accepts IPV4 addresses. IPV6 is not supported right now.
{% endhint %}

#### Code samples for the device-server endpoint:

{% hint style="warning" %}
Pass the `installation_token` received in the last step as value for the header `X-Bunq-Client-Authentication` to authenticate yourself in this endpoint.
{% endhint %}

{% openapi src="/files/xJ3v0GinyfONRbxz8Srh" path="/device-server" method="post" %}
[swagger.json](https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-218d6e618d396b5e315e30f903e92e143f7a4cc1%2Fswagger.json?alt=media\&token=108cfcc1-06ec-4015-875d-12120194eb40)
{% endopenapi %}

### What's next

With the `installation_token` in hands, we are able to authenticate ourselves and register our device for future endpoint calls.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/your-first-payment/creating-the-api-context/device-registration.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
