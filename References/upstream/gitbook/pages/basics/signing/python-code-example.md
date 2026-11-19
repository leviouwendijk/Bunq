> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/signing/python-code-example.md).

# Python Code Example

## Introduction

Signing request is not hard, but it can be tricky if you don't understand the core concepts. That's why we provide example on how to implement this in Python. We'll do the following:

* Get a API key
* Get a Session, device and Installation on sandbox
* Get the monetary account and add some money
* Create a signature
* Use the signature to create a payment.

{% hint style="info" %}
Copy the files for [FastAPI](/basics/signing/python-code-example/full-main.py.md), [bunq\_lib](/basics/signing/python-code-example/full-bunq_lib.py.md) and [signing](/basics/signing/python-code-example/full-signing.py.md)
{% endhint %}

## What are we trying to achieve

Eventually we make an API call to create a payment. This is because this is one of the calls that requires us to generate a signature.

### What is a signature?

A signature is nothing more than a string of characters, but the exact string depends on what you use as input.

To give an example. Let's assume we want to sign the following payload:

```
{"hello":"World}
```

And now assume our signature for that payload is\
Signature: fafd6dad81f90a2d6f7d60a635f206188a54039ba07a84757cf9daf24a60b57a

bunq's backend can verify that that signature indeed belongs to that payload. Based on the public key that we shared earlier.

### How does this protect us?

If some attacker would send a different payload:

```
{"hello":"oops I changed the message"}
```

then that signature would change, and thus not be valid. A malicious attacker will also not be able to recreate a signature of his own, because they do not have our private\_key.pem.

## Getting started

we'll use the FastAPI framework. And will need FastApi, Cryptography and

We can install these by running: `pip install cryptography fastapi uvicorn`We'll have the following File structure

```
├── lib
│   └── bunq_lib.py
├── main.py
└── signing.py
```

### Let's create the main.py file first:

This is a quick scaffold that allows us to trigger actionts by visiting a endpoint in your browser.

{% hint style="info" %}
This file will not run on its own yet. We need the other files too.
{% endhint %}

Some things to note:

* You can see the bunq sandbox API key if you don't have one yet get yours here [API Keys](/basics/authentication/api-keys.md)
* You see we instantiate the Class BunqClient that we imported from \`the lib.bunq\_lib\`
* You'll only have to run \`uvicorn main:app --reload to start the server

```python
from fastapi import FastAPI
from lib.bunq_lib import BunqClient


USER_API_KEY = "sandbox_83f4f88a10706750ec2fdcbc1ce97b582a986f2846d33dcaaa974d95"

bunq_client = BunqClient(USER_API_KEY, service_name='signingScript')


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

### Let's add signing.py

{% hint style="info" %}
get the full files [here](/basics/signing/python-code-example/full-signing.py.md)
{% endhint %}

We do this in a few steps:

1 is adding the imports and writing a function that generates the RSA Key pair for us (The function in the example is set up to check if one is generated first, if it is it loads the existing one)

```python

import os
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding, rsa
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.serialization import load_pem_private_key
import base64
import hashlib

# Function to generate RSA key pair
def generate_rsa_key_pair():
    private_key_file = 'private_key.pem'
    public_key_file = 'public_key.pem'
    
    # Check if the key files exist
    if os.path.exists(private_key_file) and os.path.exists(public_key_file):
        # Read the existing keys from the text files
        with open(private_key_file, 'r') as private_file:
            private_key_pem = private_file.read()

        with open(public_key_file, 'r') as public_file:
            public_key_pem = public_file.read()

        print("bunq - using existing keypair")
    else:
        # Generate new RSA keys with 2048 bits as required by Bunq
        private_key = rsa.generate_private_key(
            public_exponent=65537,
            key_size=2048,
            backend=default_backend()
        )
        public_key = private_key.public_key()

        # Serialize private key to PEM format (PKCS#8 as required by Bunq)
        private_key_pem = private_key.private_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PrivateFormat.PKCS8,
            encryption_algorithm=serialization.NoEncryption()
        ).decode('utf-8')

        # Serialize public key to PEM format
        public_key_pem = public_key.public_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PublicFormat.SubjectPublicKeyInfo
        ).decode('utf-8')

        # Save the keys to text files
        with open(private_key_file, 'w') as private_file:
            private_file.write(private_key_pem)

        with open(public_key_file, 'w') as public_file:
            public_file.write(public_key_pem)

        print("bunq - creating new keypair [KEEP THESE FILES SAFE]")

    return private_key_pem, public_key_pem
    
    
```

The most important function in the signing.py file is our sign\_data() function that actually uses the generated keys and data we want to sign. Pay special attention to the specified hash and padding functions

```python
"""
This is a continuation of the signing.py file we were writting
"""
def sign_data(data, private_key_pem):
    """Signs the given data with the provided private key using SHA256 and PKCS#1 v1.5 padding.
    
    Args:
        data (str): The data to sign (should be the JSON request body)
        private_key_pem (str): The private key in PEM format
    
    Returns:
        str: Base64 encoded signature
    """
    private_key = load_private_key(private_key_pem)
    
    # Ensure the data is encoded in UTF-8 exactly as it will be sent
    encoded_data = data.encode('utf-8')

    # Debug: Print exact bytes being signed
    print("\n[DEBUG] Signing Data Bytes:", encoded_data)
    print("[DEBUG] SHA256 Hash of Data:", hashlib.sha256(encoded_data).hexdigest())

    # Generate signature using SHA256 and PKCS#1 v1.5 padding as required by Bunq
    signature = private_key.sign(
        encoded_data,
        padding.PKCS1v15(),
        hashes.SHA256()
    )

    # Encode in Base64 (as required by Bunq API)
    encoded_signature = base64.b64encode(signature).decode('utf-8')

    # Debug: Print signature
    print("[DEBUG] Base64 Encoded Signature:", encoded_signature)

    return encoded_signature
```

We can call this function from our bunq\_lib.py to generate a signature for each request we want to sign.

## Ok now let's make this in bunq\_lib.py

We start with the imports and creating a class, with variables for API keys, tokens and everything else we need. You can also see the 2 functions one to generate a device token, and one to load it if it already exists.

```python
import json
import requests
from signing import generate_rsa_key_pair, sign_data, verify_response
import uuid


class BunqClient:
    def __init__(self, api_key, service_name, base_url="https://public-api.sandbox.bunq.com/v1"):
        self.service_name = service_name
        self.api_key = api_key
        self.private_key_pem, self.public_key_pem = generate_rsa_key_pair()
        self.device_token = None
        self.server_public_key = None
        self.device_server_id = None
        self.session_token = None
        self.user_id = None
        self.base_url = base_url

        # Try to load device token from file
        self.load_device_token()
        
    def save_device_token(self):
        """Save the device token to a file."""
        with open('device_token.json', 'w') as file:
            json.dump({"device_token": self.device_token}, file)

    def load_device_token(self):
        """Load the device token from a file if it exists."""
        try:
            with open('device_token.json', 'r') as file:
                data = json.load(file)
                self.device_token = data.get("device_token")
                print(f"bunq - Loaded device token from file [KEEP THIS SAFE!]")
        except FileNotFoundError:
            print("bunq - No device token found, need to create a new one.")

```

## Creating installation, registering the device and getting a session

In the same file as above we add a few more functions that allow us to create a installation, device and session<br>

```python
    """
    This is a continuation of the bunq_lib.py file we were writting
    """
    
    def create_installation(self):
        if self.device_token is not None:
            print("bunq - Device token already created.")
            return

        url = f"{self.base_url}/installation"
        payload = json.dumps({"client_public_key": self.public_key_pem})

        headers = {
            'Content-Type': 'application/json',
            'User-Agent': self.service_name,
            'X-Bunq-Language': 'en_US',
            'X-Bunq-Region': 'nl_NL',
            'X-Bunq-Geolocation': '0 0 0 0 000',
        }

        response = requests.post(url, headers=headers, data=payload)
        data = response.json()

        self.device_token = next(item["Token"]["token"] for item in data["Response"] if "Token" in item)
        self.server_public_key = next(item["ServerPublicKey"]["server_public_key"] for item in data["Response"] if "ServerPublicKey" in item)
        self.save_device_token()  # Save the token for future use

    def create_device_server(self):
        if not self.device_token:
            print("bunq - Device token is required to create device server.")
            return

        url = f"{self.base_url}/device-server"
        payload = json.dumps({
            "description": self.service_name,
            "secret": self.api_key,
            "permitted_ips": ["*"]
        })
        signed_payload_signature = sign_data(payload, self.private_key_pem)

        headers = {
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache',
            'User-Agent': self.service_name,
            'X-Bunq-Language': 'en_US',
            'X-Bunq-Region': 'nl_NL',
            'X-Bunq-Geolocation': '0 0 0 0 000',
            'X-Bunq-Client-Authentication': self.device_token,
            'X-Bunq-Client-Signature': signed_payload_signature
        }

        response = requests.post(url, headers=headers, data=payload)
        self.device_server_id = response.text

    def create_session(self):
        if not self.device_token:
            print("bunq - Device token is required to create session.")
            return

        url = f"{self.base_url}/session-server"
        payload_dict = {"secret": self.api_key}
        payload_json = json.dumps(payload_dict, separators=(',', ':'))
        signed_payload_signature = sign_data(payload_json, self.private_key_pem)
        
        headers = {
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache',
            'User-Agent': self.service_name,
            'X-Bunq-Language': 'en_US',
            'X-Bunq-Region': 'nl_NL',
            'X-Bunq-Geolocation': '0 0 0 0 000',
            'X-Bunq-Client-Authentication': self.device_token,
            'X-Bunq-Client-Signature': signed_payload_signature
        }

        response = requests.post(url, headers=headers, data=payload_json)
        data = response.json()
        print(data)
        # Extract and save session token
        self.session_token = next(item["Token"]["token"] for item in data["Response"] if "Token" in item)
        self.user_id = next(item["UserPerson"]["id"] for item in data["Response"] if "UserPerson" in item)

        print(f"bunq - Session Token: {self.session_token}")
        print(f"bunq - User ID: {self.user_id}")
```

At this point your you could run the fastapi server with the command

```
uvicorn main:app --reload
```

That will start the server and will register your device and create the private and public keys. Your file tree should now look like this

```
├── device_token.json
├── lib
│   └── bunq_lib.py
├── main.py
├── private_key.pem
├── public_key.pem
└── signing.py
```

{% hint style="warning" %}
Be aware that both the device\_token.json as the private\_key.pem contain credentials that should not be commited to source control or be shared in general. We recommend adding them to your environment variables. We created them as files here to be transparent on what the content looks like
{% endhint %}

Given that we now have a session and can make calls we can finish the rest of our file.

## Let's make a payment and a request

In the rest of the file you can see 2 methods\
1\. request. This is just a generic function that can create a API call to a endpoint of your choosing.

2. The second function is to create a payment. This one is a bit more tricky as it requires us to sign.

```python
"""
This is a continuation of the bunq_lib.py file we were writting
"""
    def request(self, endpoint: str, method: str = "GET", data: dict = None):
        url = f"{self.base_url}/user/{self.user_id}/{endpoint}"
        print(f"[DEBUG] bunq - Requesting: {method} {url}")

        # Default headers
        headers = {
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache',
            'User-Agent': self.service_name,
            'X-Bunq-Language': 'en_US',
            'X-Bunq-Region': 'nl_NL',
            'X-Bunq-Geolocation': '0 0 0 0 000',
            'X-Bunq-Client-Authentication': self.session_token,
            'X-Bunq-Client-Request-Id': str(uuid.uuid4())  # Should be unique for each request
        }

        payload = None
            
        if data and method == "POST":
            # Ensure consistent JSON formatting by using separators
            payload = json.dumps(data, separators=(',', ':'))
            signed_payload_signature = sign_data(payload, self.private_key_pem)
            headers["X-Bunq-Client-Signature"] = signed_payload_signature

            print(f"[DEBUG] Request Payload: {payload}")
            print(f"[DEBUG] Signed Payload Signature: {signed_payload_signature}")

        try:
            response = requests.request(method, url, headers=headers, data=payload)
            print(f"[DEBUG] Response Status Code: {response.status_code}")

            if response.status_code == 401:
                print("[WARNING] Unauthorized (401) - Refreshing session...")
                self.refresh_session()
                response = requests.request(method, url, headers=headers, data=payload)
                print(f"[DEBUG] Retried Response Status Code: {response.status_code}")

            if response.status_code == 200:
                response_body = response.text
                server_signature = response.headers.get('X-Bunq-Server-Signature')
                
                if server_signature and self.server_public_key:
                    # Verify the response signature
                    if not verify_response(response_body, server_signature, self.server_public_key):
                        raise Exception("Response signature verification failed")
                    print("[DEBUG] Response signature verified successfully")
                
                return response.json()

            print(f"[ERROR] Request failed: {response.status_code} - {response.text}")
            response.raise_for_status()

        except requests.exceptions.RequestException as e:
            print(f"[ERROR] Request error: {e}")
            raise
    


    def create_payment(self, amount: str, recipient_iban: str, currency: str, from_monetary_account_id: str, description: str):
        url = f"{self.base_url}/user/{self.user_id}/monetary-account/{from_monetary_account_id}/payment"

        payload = json.dumps({
            "amount": {
                "value": str(amount),
                "currency": str(currency)
            },
            "counterparty_alias": {
                "type": "EMAIL",
                "value": "sugardaddy@bunq.com",
                "name": "Sugar Daddy"
            },
            "description": str(description)
        }, separators=(',', ':'))  # Ensure consistent JSON formatting
        
        signature = sign_data(payload, self.private_key_pem)
        headers = {
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache',
            'User-Agent': self.service_name,
            'X-Bunq-Language': 'en_US',
            'X-Bunq-Region': 'nl_NL',
            'X-Bunq-Client-Request-Id': str(uuid.uuid4()),
            'X-Bunq-Geolocation': '0 0 0 0 000',
            'X-Bunq-Client-Authentication': self.session_token,
            'X-Bunq-Client-Signature': signature
        }

        response = requests.post(url, headers=headers, data=payload)
        
        if response.status_code == 200:
            response_body = response.text
            server_signature = response.headers.get('X-Bunq-Server-Signature')
            
            if server_signature and self.server_public_key:
                # Verify the response signature
                if not verify_response(response_body, server_signature, self.server_public_key):
                    raise Exception("Response signature verification failed")
                print("[DEBUG] Response signature verified successfully")
        
        return response.json()

                
```

## Making a generic API call

In our main.py file we started a fastAPI server which has 2 endpoints\
1\. /get\_cards - Which returns the cards\
2\. /monetary-account which returns the monetary accounts of the user.

You can see they both use the .request() method that we defined in the bunq\_lib.py. They just call a different endpoint.

```python
@app.get("/get_cards")
def get_cards():
    response = bunq_client.request(endpoint='card',method='GET',data={})
    return response


@app.get("/monetary_account")
def get_monetary_account():
    response = bunq_client.request(endpoint='monetary-account',method='GET',data={})
    return response


```

If we go to our browser and type:\
<http://localhost:8000/monetary_account>

We'll get the response object with all our monetary accounts:

```
{
  "Response": [
    {
      "MonetaryAccountBank": {
        "id": 1989601,
        "created": "2025-02-26 16:14:21.031964",
        "updated": "2025-02-26 16:14:21.031964",
        "alias": [
          {
            "type": "PHONE_NUMBER",
            "value": "+31616459904",
            "name": "+31616459904"
          },
          {
            "type": "EMAIL",
            "value": "test+845d47ed-dced-4a0c-8b11-57b5e9ff7288@bunq.com",
            "name": "test+845d47ed-dced-4a0c-8b11-57b5e9ff7288@bunq.com"
          },
          {
            "type": "IBAN",
            "value": "NL80BUNQ2118573685",
            "name": "Donald Byrne"
          }
        ],
        "avatar": {
          "uuid": "b07adec4-2659-460b-869e-fa2fb96257e8",
          "image": [
            {
              "attachment_public_uuid": "03aab32d-26f6-48e2-8133-4e0c7ffb1dab",
              "height": 1023,
              "width": 1024,
              "content_type": "image/png",
              "urls": [
                {
                  "type": "ORIGINAL",
                  "url": "https://bunq-triage-model-storage-public.s3.eu-central-1.amazonaws.com/bunq_file/File/content/921ece497cd00f4e0cef3f0f63a962c31cf3f8e35311d127d5a7b23be3d074d5.png"
                }
              ]
            }
          ],
          "anchor_uuid": "392ee3d9-45b0-435f-bd0e-cd7e2e4b8b26",
          "style": "NONE"
        },
        "balance": {
          "currency": "EUR",
          "value": "998.30"
        },
        "country": "NL",
        "currency": "EUR",
        "display_name": "D. Byrne",
        "daily_limit": {
          "currency": "EUR",
          "value": "5000.00"
        },
        "description": "Main",
        "public_uuid": "392ee3d9-45b0-435f-bd0e-cd7e2e4b8b26",
        "status": "ACTIVE",
        "sub_status": "NONE",
        "timezone": "europe/amsterdam",
        "user_id": 1800297,
        "monetary_account_profile": {
          "profile_fill": {
            "status": "ACTIVE",
            "balance_preferred": {
              "currency": "EUR",
              "value": "100.00"
            },
            "balance_threshold_low": {
              "currency": "EUR",
              "value": "50.00"
            }
          },
          "profile_drain": null,
          "profile_action_required": "NO_ACTION_NEEDED",
          "profile_amount_required": {
            "currency": "EUR",
            "value": "0.00"
          }
        },
        "setting": {
          "color": "#FF7819",
          "icon": null,
          "default_avatar_status": "AVATAR_DEFAULT",
          "restriction_chat": "ALLOW_INCOMING",
          "sdd_expiration_action": "AUTO_ACCEPT"
        },
        "connected_cards": [],
        "budget": [],
        "overdraft_limit": {
          "currency": "EUR",
          "value": "0.00"
        },
        "all_auto_save_id": []
      }
    }
  ],
  "Pagination": {
    "future_url": "/v1/user/1800297/monetary-account?newer_id=1989601",
    "newer_url": null,
    "older_url": null
  }
}
```

## Now let's also make a payment:

The set up is the same we simply navigate to:\
<http://localhost:8000/payment> to trigger the call to the endpoint

and get a response with the payment ID:<br>

```
{
  "Response": [
    {
      "Id": {
        "id": 25083708
      }
    }
  ]
}
```

Let's go through it step-by step. To explain the signing in depth.

When we go to the /payment route we trigger this code:<br>

```python
@app.get("/payment")
def payment():
    payment = bunq_client.create_payment(
        amount='0.10', 
        recipient_iban='NL14RABO0169202917',
        currency='EUR',
        from_monetary_account_id='18375', 
        description='test'
    )
    return payment

```

This calls the create\_payment() function from the bunq\_client class in our bunq\_lib.py file. It sends along some payment details, like the receiver IBAN, the monetary account to pay from, a description and an amount.

Now what happens in the create\_payment() function<br>

```python
def create_payment(self, amount: str, recipient_iban: str, currency: str, from_monetary_account_id: str, description: str):
        url = f"{self.base_url}/user/{self.user_id}/monetary-account/{from_monetary_account_id}/payment"

        payload = json.dumps({
            "amount": {
                "value": str(amount),
                "currency": str(currency)
            },
            "counterparty_alias": {
                "type": "EMAIL",
                "value": "sugardaddy@bunq.com",
                "name": "Sugar Daddy"
            },
            "description": str(description)
        }, separators=(',', ':'))  # Ensure consistent JSON formatting
        
        signature = sign_data(payload, self.private_key_pem)
        headers = {
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache',
            'User-Agent': self.service_name,
            'X-Bunq-Language': 'en_US',
            'X-Bunq-Region': 'nl_NL',
            'X-Bunq-Client-Request-Id': str(uuid.uuid4()),
            'X-Bunq-Geolocation': '0 0 0 0 000',
            'X-Bunq-Client-Authentication': self.session_token,
            'X-Bunq-Client-Signature': signature
        }

        response = requests.post(url, headers=headers, data=payload)
        
        if response.status_code == 200:
            response_body = response.text
            server_signature = response.headers.get('X-Bunq-Server-Signature')
            
            if server_signature and self.server_public_key:
                # Verify the response signature
                if not verify_response(response_body, server_signature, self.server_public_key):
                    raise Exception("Response signature verification failed")
                print("[DEBUG] Response signature verified successfully")
        
        return response.json()

                
```

1. We first create a payload. We have to be very specific in the exact formatting of the payload. That's why we specify the separators. We do this to ensure the payload that we sign and the payload that we send with the request match exactly. Else the signature will fail.
2. Now we call the sign\_data() function from our signing.py file this will return a signature based on our private key and the payload.
3. We add that signature to our 'X-Bunq-Client-Signature'.
4. From there it is exactly like any API call where you wait for a 200 response status
5. We included 1 final step which is to also validate the 'X-Bunq-Server-Signature' signature. by calling the verify\_response() function and comparing the signature bunq returned to the public key we stored in the installation step.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/signing/python-code-example.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
