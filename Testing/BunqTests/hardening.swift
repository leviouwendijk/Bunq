import Bunq
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

actor ExpiringBunqServer {
    private var sessions = 0
    private var successfulReads = 0

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        guard let url = request.url else { throw Bunq.Failure.invalidResponse }
        let status: Int
        let body: String
        switch url.path {
        case "/v1/session-server":
            sessions += 1
            status = 200
            let token = sessions == 1 ? "expired-token" : "renewed-token"
            body = #"{"Response":[{"Token":{"token":"\#(token)"}}]}"#
        case "/v1/user/5/monetary-account":
            if request.value(forHTTPHeaderField: "X-Bunq-Client-Authentication") == "expired-token" {
                try await Task.sleep(for: .milliseconds(15))
                status = 401
                body = #"{"Error":[{"error_description":"Expired session"}]}"#
            } else {
                successfulReads += 1
                status = 200
                body = #"{"Response":[{"MonetaryAccountBank":{"id":23}}]}"#
            }
        default:
            throw Bunq.Failure.invalidResponse
        }
        guard let response = HTTPURLResponse(
            url: url,
            statusCode: status,
            httpVersion: "HTTP/1.1",
            headerFields: ["X-Bunq-Server-Signature": "fixture-server-signature"]
        ) else { throw Bunq.Failure.invalidTransportResponse }
        return (Data(body.utf8), response)
    }

    func check() throws {
        guard sessions == 2, successfulReads == 12 else {
            throw Bunq.Failure.invalidResponse
        }
    }
}

func runHardeningTests() async throws {
    let decoder = JSONDecoder()
    let account = try decoder.decode(
        Bunq.MonetaryAccount.self,
        from: Data(#"{"MonetaryAccountFuture":{"id":23}}"#.utf8)
    )
    guard case .unknown("MonetaryAccountFuture") = account.kind else {
        throw Bunq.Failure.invalidResponse
    }
    guard (try? Bunq.Currency("EUR"))?.raw == "EUR",
          (try? Bunq.Currency("EU")) == nil,
          (try? Bunq.Currency("éUR")) == nil,
          (try? Bunq.Currency("eur")) == nil else {
        throw Bunq.Failure.invalidResponse
    }
    let malformed = #"{"older_url":"/v1/user/5/monetary-account?older_id=2&older_id=3"}"#
    guard (try? decoder.decode(Bunq.Pagination.self, from: Data(malformed.utf8))) == nil else {
        throw Bunq.Failure.invalidCursor
    }

    let signing = FixtureSigner()
    let installation = try Bunq.Installation(
        environment: .sandbox,
        token: Bunq.Token("installation-token"),
        serverPublicKey: "fixture-server-key",
        clientPublicKey: signing.publicKeyPEM
    )
    let server = ExpiringBunqServer()
    let transport = Bunq.Transport { request in try await server.send(request) }
    let apiKey = try Bunq.APIKey("fixture-api-key")
    do {
        _ = try await Bunq.Client.open(
            environment: .production,
            apiKey: apiKey,
            signing: signing,
            registration: .reuse(installation),
            transport: transport
        )
        throw Bunq.Failure.invalidResponse
    } catch Bunq.Failure.installationMismatch {}

    let client = try await Bunq.Client.open(
        environment: .sandbox,
        apiKey: apiKey,
        signing: signing,
        registration: .reuse(installation),
        transport: transport
    )
    let userID = try Bunq.User.ID(5)
    try await withThrowingTaskGroup(of: Void.self) { group in
        for _ in 0..<12 {
            group.addTask {
                let page = try await client.user(userID).accounts.list()
                guard page.items.count == 1 else { throw Bunq.Failure.invalidResponse }
            }
        }
        try await group.waitForAll()
    }
    try await server.check()

    let foreignCursor = try decoder.decode(
        Bunq.Pagination.self,
        from: Data(#"{"older_url":"/v1/user/6/monetary-account?older_id=10"}"#.utf8)
    )
    guard let cursor = foreignCursor.older else { throw Bunq.Failure.invalidCursor }
    do {
        _ = try await client.user(userID).accounts.list(cursor: cursor)
        throw Bunq.Failure.invalidResponse
    } catch Bunq.Failure.invalidCursor {}
}
