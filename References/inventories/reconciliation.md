# Bunq GitBook OpenAPI reconciliation

Parses `{% openapi ... %}` directives, not incidental prose mentions.

- gitbook pages: 222
- pages with directives: 119
- openapi directives: 487
- matched directives: 487
- directives not in swagger: 0
- invalid directives: 0
- gitbook attachment directives unverified: 14
- unknown spec sources: 0
- unique referenced operations: 431
- swagger operations: 480
- swagger without directive: 49

## Directives absent from pinned Swagger

None.

## GitBook attachments not independently verified

- `/files/xJ3v0GinyfONRbxz8Srh`: POST /attachment-public (References/upstream/gitbook/pages/psd2/are-you-a-third-party-provider-tpp-start-here/change-your-avatar.md:23)
- `/files/xJ3v0GinyfONRbxz8Srh`: POST /avatar (References/upstream/gitbook/pages/psd2/are-you-a-third-party-provider-tpp-start-here/change-your-avatar.md:39)
- `/files/xJ3v0GinyfONRbxz8Srh`: POST /user/{userID}/confirmation-of-funds (References/upstream/gitbook/pages/psd2/card-based-payment-instrument-issuer-cbpii.md:19)
- `/files/xJ3v0GinyfONRbxz8Srh`: GET /user/{itemId} (References/upstream/gitbook/pages/psd2/payment-initiation-service-provider-pisp.md:53)
- `/files/xJ3v0GinyfONRbxz8Srh`: POST /user/{userID}/confirmation-of-funds (References/upstream/gitbook/pages/psd2/payment-initiation-service-provider-pisp.md:67)
- `/files/xJ3v0GinyfONRbxz8Srh`: POST /user/{userID}/card-credit (References/upstream/gitbook/pages/tutorials/how-to-manage-your-cards/ordering-a-card.md:13)
- `/files/xJ3v0GinyfONRbxz8Srh`: PUT /user/{userID}/card/{itemId} (References/upstream/gitbook/pages/tutorials/how-to-manage-your-cards/setting-the-card-limit-and-changing-the-pin-code.md:29)
- `/files/xJ3v0GinyfONRbxz8Srh`: POST /user/{userID}/notification-filter-url (References/upstream/gitbook/pages/tutorials/how-to-manage-your-cards/setting-the-card-limit-and-changing-the-pin-code.md:80)
- `/files/xJ3v0GinyfONRbxz8Srh`: POST /user/{userID}/monetary-account/{monetary-accountID}/bunqme-tab (References/upstream/gitbook/pages/tutorials/receiving-payments-on-your-website-using-bunq.me.md:61)
- `/files/xJ3v0GinyfONRbxz8Srh`: GET /user/{userID}/monetary-account/{monetary-accountID}/bunqme-tab/{itemId} (References/upstream/gitbook/pages/tutorials/receiving-payments-on-your-website-using-bunq.me.md:75)
- `/files/xJ3v0GinyfONRbxz8Srh`: POST /installation (References/upstream/gitbook/pages/tutorials/your-first-payment/creating-the-api-context/creating-the-installation.md:35)
- `/files/xJ3v0GinyfONRbxz8Srh`: POST /device-server (References/upstream/gitbook/pages/tutorials/your-first-payment/creating-the-api-context/device-registration.md:39)
- `/files/xJ3v0GinyfONRbxz8Srh`: POST /session-server (References/upstream/gitbook/pages/tutorials/your-first-payment/creating-the-api-context/start-a-session.md:41)
- `/files/xJ3v0GinyfONRbxz8Srh`: POST /user/{userID}/monetary-account/{monetary-accountID}/payment (References/upstream/gitbook/pages/tutorials/your-first-payment/first-payments.md:45)

## Invalid directives and unfamiliar sources

None.

## Scope

Swagger operations without a GitBook directive are not necessarily absent or unsupported. Attachment contents have not been independently verified. See reconciliation.json for detailed evidence.
