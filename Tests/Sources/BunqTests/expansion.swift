import Bunq
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

actor BunqReadServer {
    private var sessions = 0
    private var reads: [String] = []

    func send(_ request: URLRequest) throws -> (Data, HTTPURLResponse) {
        guard let url = request.url else { throw Bunq.Failure.invalidResponse }
        let payload: String
        let status: Int
        if url.path == "/v1/session-server" {
            sessions += 1
            payload = sessions == 1
                ? #"{"Response":[{"Token":{"token":"expired-token"}}]}"#
                : #"{"Response":[{"Token":{"token":"fresh-token"}}]}"#
            status = 200
        } else {
            reads.append(url.path)
            if request.value(forHTTPHeaderField: "X-Bunq-Client-Authentication") == "expired-token" {
                status = 401
                payload = #"{"Error":[{"error_description":"expired"}]}"#
            } else {
                status = 200
                switch url.path {
                case "/v1/user/5/monetary-account/23", "/v1/user/5/monetary-account/999":
                    payload = #"{"Response":[{"MonetaryAccountBank":{"id":23,"description":"Operations","display_name":"Operations","status":"ACTIVE","alias":[{"iban":"NL91ABNA0417164300","display_name":"Operations"}],"balance":{"value":"123.45","currency":"EUR"}}}]}"#
                case "/v1/user/5/monetary-account/23/payment/17", "/v1/user/5/monetary-account/23/payment/99":
                    payload = #"{"Response":[{"Payment":{"id":17,"monetary_account_id":23,"amount":{"value":"-12.50","currency":"EUR"},"type":"EBA_SCT","sub_type":"PAYMENT","created":"2026-11-05 13:00:00.000000","counterparty_alias":{"iban":"NL35RABO0117713678","display_name":"Vendor"}}}]}"#
                default:
                    throw Bunq.Failure.invalidResponse
                }
            }
        }
        guard let response = HTTPURLResponse(
            url: url, statusCode: status, httpVersion: nil,
            headerFields: ["X-Bunq-Server-Signature": "fixture-server-signature"]
        ) else { throw Bunq.Failure.invalidTransportResponse }
        return (Data(payload.utf8), response)
    }

    func check() throws {
        guard sessions == 2,
              reads.contains("/v1/user/5/monetary-account/23"),
              reads.contains("/v1/user/5/monetary-account/23/payment/17")
        else { throw Bunq.Failure.invalidResponse }
    }
}

func runExpansionTests() async throws {
    let server = BunqReadServer()
    let signer = FixtureSigner()
    let installation = try Bunq.Installation(
        environment: .sandbox,
        token: Bunq.Token("installation-token"),
        serverPublicKey: "fixture-server-key",
        clientPublicKey: signer.publicKeyPEM
    )
    let client = try await Bunq.Client.open(
        environment: .sandbox,
        apiKey: Bunq.APIKey("fixture-api-key"),
        signing: signer,
        registration: .reuse(installation),
        transport: .init { request in try await server.send(request) }
    )
    let user = client.user(try Bunq.User.ID(5))
    let accountID = try Bunq.MonetaryAccount.ID(23)
    let account = try await user.accounts.get(accountID)
    guard account.id == accountID,
          account.display_name == "Operations",
          account.status == "ACTIVE",
          account.alias?.first?.iban == "NL91ABNA0417164300",
          account.balance?.value == Decimal(string: "123.45")
    else { throw Bunq.Failure.invalidResponse }

    let payment = try await user.account(accountID).payments.get(Bunq.Payment.ID(17))
    guard payment.id.raw == 17,
          payment.counterparty_alias?.iban == "NL35RABO0117713678",
          payment.type == "EBA_SCT",
          payment.sub_type == "PAYMENT"
    else { throw Bunq.Failure.invalidResponse }

    var rejectedAccount = false
    do {
        _ = try await user.accounts.get(Bunq.MonetaryAccount.ID(999))
    } catch Bunq.Failure.invalidResponse {
        rejectedAccount = true
    }
    guard rejectedAccount else { throw Bunq.Failure.invalidResponse }

    var rejectedPayment = false
    do {
        _ = try await user.account(accountID).payments.get(Bunq.Payment.ID(99))
    } catch Bunq.Failure.invalidResponse {
        rejectedPayment = true
    }
    guard rejectedPayment else { throw Bunq.Failure.invalidResponse }

    try await server.check()
}
