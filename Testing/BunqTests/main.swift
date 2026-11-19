import Foundation
import Bunq
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct FixtureSigner: Bunq.Signing {
    let publicKeyPEM = "test-public-key"

    func sign(_ body: Data) throws -> String { "fixture-client-signature" }

    func verify(_ body: Data, signature: String, publicKey: String) throws {
        guard signature == "fixture-server-signature", publicKey == "fixture-server-key" else {
            throw Bunq.Failure.invalidSignature
        }
    }
}

actor FixtureServer {
    private(set) var requests: [URLRequest] = []

    func send(_ request: URLRequest) throws -> (Data, HTTPURLResponse) {
        requests.append(request)
        guard let url = request.url else { throw Bunq.Failure.invalidResponse }
        let path = url.path
        let payload: String
        switch path {
        case "/v1/installation":
            payload = """
                {"Response":[{"Id":{"id":10}},{"Token":{"token":"installation-token"}},{"ServerPublicKey":{"server_public_key":"fixture-server-key"}}]}
                """
        case "/v1/device-server":
            payload = """
                {"Response":[{"Id":{"id":20}}]}
                """
        case "/v1/session-server":
            payload = """
                {"Response":[{"Token":{"token":"session-token"}},{"UserPerson":{"id":5}}]}
                """
        case "/v1/user/5/monetary-account":
            payload = """
                {"Response":[{"MonetaryAccountBank":{"id":23,"description":"Primary","balance":{"value":"12.50","currency":"EUR"}}}],"Pagination":{"older_url":"/v1/user/5/monetary-account?older_id=22","newer_url":null,"future_url":null}}
                """
        case "/v1/user/5/monetary-account/23/payment":
            payload = """
                {"Response":[{"Payment":{"id":17,"monetary_account_id":23,"amount":{"value":"-1.50","currency":"EUR"},"description":"Test payment"}}],"Pagination":{"older_url":"/v1/user/5/monetary-account/23/payment?count=25&older_id=16","newer_url":null,"future_url":null}}
                """
        default:
            throw Bunq.Failure.invalidResponse
        }
        guard let response = HTTPURLResponse(
            url: url, statusCode: 200, httpVersion: "HTTP/1.1",
            headerFields: ["X-Bunq-Server-Signature": "fixture-server-signature"]
        ) else { throw Bunq.Failure.invalidTransportResponse }
        return (Data(payload.utf8), response)
    }

    func check() throws {
        guard requests.count == 6 else { throw Bunq.Failure.invalidResponse }
        guard requests[0].value(forHTTPHeaderField: "X-Bunq-Client-Authentication") == nil else { throw Bunq.Failure.invalidResponse }
        guard requests[1].value(forHTTPHeaderField: "X-Bunq-Client-Authentication") == "installation-token" else { throw Bunq.Failure.invalidResponse }
        guard requests[1].value(forHTTPHeaderField: "X-Bunq-Client-Signature") == "fixture-client-signature" else { throw Bunq.Failure.invalidResponse }
        guard let deviceBody = requests[1].httpBody,
              let deviceObject = try JSONSerialization.jsonObject(with: deviceBody) as? [String: Any],
              deviceObject["description"] as? String == "SDK test",
              deviceObject["secret"] as? String == "fixture-api-key",
              deviceObject["permitted_ips"] == nil else {
            throw Bunq.Failure.invalidResponse
        }
        guard requests[2].value(forHTTPHeaderField: "X-Bunq-Client-Signature") == "fixture-client-signature" else { throw Bunq.Failure.invalidResponse }
        guard requests[3].value(forHTTPHeaderField: "X-Bunq-Client-Authentication") == "session-token" else { throw Bunq.Failure.invalidResponse }
        guard requests[4].url?.query == "count=25" else { throw Bunq.Failure.invalidResponse }
        guard requests[5].url?.query == "count=25&older_id=16" else { throw Bunq.Failure.invalidResponse }
    }

    func checkExplicitPermittedIPs() throws {
        guard requests.count == 3,
              let body = requests[1].httpBody,
              let object = try JSONSerialization.jsonObject(with: body) as? [String: Any],
              let permittedIPs = object["permitted_ips"] as? [String],
              permittedIPs == ["192.0.2.10"] else {
            throw Bunq.Failure.invalidResponse
        }
    }
}

func run() async throws {
    let server = FixtureServer()
    let transport = Bunq.Transport { request in try await server.send(request) }
    let apiKey = try Bunq.APIKey("fixture-api-key")
    let device = try Bunq.Device(description: "SDK test")
    let client = try await Bunq.Client.open(
        environment: .sandbox,
        apiKey: apiKey,
        signing: FixtureSigner(),
        registration: .register(device),
        transport: transport
    )
    let userID = try Bunq.User.ID(5)
    let accountID = try Bunq.MonetaryAccount.ID(23)
    let count = try Bunq.Count(25)
    let accounts = try await client.user(userID).accounts.list()
    guard accounts.items.count == 1, accounts.items[0].id == accountID,
          accounts.items[0].kind == .bank,
          accounts.items[0].balance?.value == Decimal(string: "12.50")
    else { throw Bunq.Failure.invalidResponse }
    let payments = try await client.user(userID).account(accountID).payments.list(count: count)
    guard payments.items.count == 1, payments.items[0].id.raw == 17,
          payments.items[0].amount.value == Decimal(string: "-1.50")
    else { throw Bunq.Failure.invalidResponse }
    guard let older = payments.pagination.older else { throw Bunq.Failure.invalidResponse }
    let preceding = try await client.user(userID).account(accountID).payments.list(count: count, cursor: older)
    guard preceding.items.count == 1 else { throw Bunq.Failure.invalidResponse }
    try await server.check()

    // An explicit IP restriction remains present on the wire.
    let restrictedServer = FixtureServer()
    _ = try await Bunq.Client.open(
        environment: .sandbox,
        apiKey: apiKey,
        signing: FixtureSigner(),
        registration: .register(Bunq.Device(description: "IP fixture", permittedIPs: ["192.0.2.10"])),
        transport: Bunq.Transport { request in try await restrictedServer.send(request) }
    )
    try await restrictedServer.checkExplicitPermittedIPs()

    guard (try? Bunq.Count(201)) == nil, (try? Bunq.Payment.ID(0)) == nil else {
        throw Bunq.Failure.invalidResponse
    }

    let invalidResponseTransport = Bunq.Transport { request in
        let (data, response) = try await server.send(request)
        guard let url = request.url,
              let unsigned = HTTPURLResponse(url: url, statusCode: response.statusCode, httpVersion: nil, headerFields: [:])
        else { throw Bunq.Failure.invalidResponse }
        return (data, unsigned)
    }
    do {
        _ = try await Bunq.Client.open(
            environment: .sandbox,
            apiKey: apiKey,
            signing: FixtureSigner(),
            registration: .register(device),
            transport: invalidResponseTransport
        )
        throw Bunq.Failure.invalidResponse
    } catch Bunq.Failure.invalidSignature {
        // Missing server signature must prevent successful bootstrap.
    }
    guard (try? JSONDecoder().decode(Bunq.Payment.self, from: Data(#"{"Payment":{"id":1,"monetary_account_id":23,"amount":{"value":1.5,"currency":"EUR"}}}"#.utf8))) == nil else {
        throw Bunq.Failure.invalidResponse
    }
    try await runHardeningTests()
    try await runContextLifecycleTests()
    try await runExpansionTests()
    try runWireKeyConvergenceTests()
    print("Bunq typed API, signed bootstrap and listing fixtures: PASS")
}

try await run()
