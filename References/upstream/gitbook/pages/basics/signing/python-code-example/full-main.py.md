> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/signing/python-code-example/full-main.py.md).

# Full main.py

```python
from fastapi import FastAPI
from lib.bunq_lib import BunqClient


USER_API_KEY = "sandbox_83f4f88a10706750ec2fdcbc1ce97b582a986f2846d33dcaaa974d95"

bunq_client = BunqClient(USER_API_KEY, service_name='PeterScript')


# Run these 1x to initialize your application 
bunq_client.create_installation()
bunq_client.create_device_server()


bunq_client.create_session()

app = FastAPI()


@app.get("/monetary_account")
def get_monetary_account():
    response = bunq_client.request(endpoint='monetary-account',method='GET',data={})
    return response



@app.get("/request")
def request():
    endpoint = f"monetary-account/"
    response = bunq_client.request(endpoint=endpoint, method='GET', data=None)
    return response

@app.get("/payment")
def payment():
    payment = bunq_client.create_payment(
        amount='0.10', 
        recipient_iban='NL14RABO0169202917',
        currency='EUR',
        from_monetary_account_id='1989601', 
        description='test'
    )
    return payment

```


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/signing/python-code-example/full-main.py.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
