import Bunq
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

actor MemoryBunqContextStore: Bunq.ContextStore {
    private var stored: Bunq.StoredContext?
    private var leased = false

    func load() -> Bunq.StoredContext? { stored }
    func save(_ context: Bunq.StoredContext) { stored = context }
    func invalidate() { stored = nil }

    func withExclusiveLease<T: Sendable>(
        _ operation: @Sendable () async throws -> T
    ) async throws -> T {
        while leased {
            try await Task.sleep(for: .milliseconds(5))
        }
        leased = true
        defer { leased = false }
        return try await operation()
    }
}

actor BunqContextFixtureServer {
    private var installations = 0
    private var devices = 0
    private var sessions = 0
    private var reads = 0
    private var requireRenewal = false

    func expireSession() { requireRenewal = true }

    func send(_ request: URLRequest) throws -> (Data, HTTPURLResponse) {
        guard let url = request.url else { throw Bunq.Failure.invalidResponse }
        let payload: String
        let status: Int
        switch url.path {
        case "/v1/installation":
            installations += 1
            payload = #"{"Response":[{"Token":{"token":"installation-token"}},{"ServerPublicKey":{"server_public_key":"fixture-server-key"}}]}"#
            status = 200
        case "/v1/device-server":
            devices += 1
            payload = #"{"Response":[{"Id":{"id":20}}]}"#
            status = 200
        case "/v1/session-server":
            sessions += 1
            payload = #"{"Response":[{"Token":{"token":"session-\#(sessions)"}},{"UserCompany":{"id":5}}]}"#
            status = 200
        case "/v1/user/5/monetary-account":
            reads += 1
            let token = request.value(forHTTPHeaderField: "X-Bunq-Client-Authentication")
            if requireRenewal && token == "session-1" {
                status = 401
                payload = #"{"Error":[{"error_description":"Expired session"}]}"#
            } else {
                guard token == "session-1" || token == "session-2" else {
                    throw Bunq.Failure.invalidResponse
                }
                status = 200
                payload = #"{"Response":[{"MonetaryAccountBank":{"id":23}}]}"#
            }
        default:
            throw Bunq.Failure.invalidResponse
        }
        guard let response = HTTPURLResponse(
            url: url, statusCode: status, httpVersion: "HTTP/1.1",
            headerFields: ["X-Bunq-Server-Signature": "fixture-server-signature"]
        ) else { throw Bunq.Failure.invalidTransportResponse }
        return (Data(payload.utf8), response)
    }

    func counters() -> (installations: Int, devices: Int, sessions: Int, reads: Int) {
        (installations, devices, sessions, reads)
    }
}

func runContextLifecycleTests() async throws {
    let server = BunqContextFixtureServer()
    let transport = Bunq.Transport { request in try await server.send(request) }
    let store = MemoryBunqContextStore()
    let apiKey = try Bunq.APIKey("fixture-api-key")
    let signing = FixtureSigner()
    let registration: Bunq.Registration = .register(try Bunq.Device(description: "Lifecycle fixture"))

    let first = try await Bunq.Client.open(
        environment: .sandbox, apiKey: apiKey, signing: signing,
        registration: registration, transport: transport, contextStore: store
    )
    guard let user = await first.authenticatedUser,
          user.kind == .company, user.id.raw == 5 else { throw Bunq.Failure.invalidResponse }
    var counters = await server.counters()
    guard counters.installations == 1, counters.devices == 1, counters.sessions == 1 else {
        throw Bunq.Failure.invalidResponse
    }

    // A second process with the same store restores without network bootstrap.
    let second = try await Bunq.Client.open(
        environment: .sandbox, apiKey: apiKey, signing: signing,
        registration: registration, transport: transport, contextStore: store
    )
    counters = await server.counters()
    guard counters.installations == 1, counters.devices == 1, counters.sessions == 1 else {
        throw Bunq.Failure.invalidResponse
    }
    let userID = try Bunq.User.ID(5)
    await server.expireSession()
    // Separate Client actors should coordinate the renewal through a single lease.
    try await withThrowingTaskGroup(of: Void.self) { group in
        for index in 0..<10 {
            let client = index.isMultiple(of: 2) ? first : second
            group.addTask {
                let accounts = try await client.user(userID).accounts.list()
                guard accounts.items.count == 1 else { throw Bunq.Failure.invalidResponse }
            }
        }
        try await group.waitForAll()
    }
    counters = await server.counters()
    guard counters.sessions == 2, counters.installations == 1, counters.devices == 1 else {
        throw Bunq.Failure.invalidResponse
    }
    let third = try await Bunq.Client.open(
        environment: .sandbox, apiKey: apiKey, signing: signing,
        registration: registration, transport: transport, contextStore: store
    )
    guard (await third.authenticatedUser)?.id.raw == 5 else {
        throw Bunq.Failure.invalidResponse
    }
    let result = try await third.user(userID).accounts.list()
    guard result.items.count == 1, (await server.counters()).sessions == 2 else {
        throw Bunq.Failure.invalidResponse
    }

    // A different API key or environment cannot silently reuse saved credentials.
    do {
        _ = try await Bunq.Client.open(
            environment: .sandbox, apiKey: Bunq.APIKey("wrong-key"), signing: signing,
            registration: registration, transport: transport, contextStore: store
        )
        throw Bunq.Failure.invalidResponse
    } catch Bunq.Failure.contextMismatch {}
    do {
        _ = try await Bunq.Client.open(
            environment: .production, apiKey: apiKey, signing: signing,
            registration: registration, transport: transport, contextStore: store
        )
        throw Bunq.Failure.invalidResponse
    } catch Bunq.Failure.contextMismatch {}
    counters = await server.counters()
    guard counters.installations == 1, counters.devices == 1, counters.sessions == 2 else {
        throw Bunq.Failure.invalidResponse
    }

    // Persist a context on disk, then restore it through another FileContextStore instance.
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent("bunq-context-\(UUID().uuidString)", isDirectory: true)
    defer { try? FileManager.default.removeItem(at: directory) }
    let url = directory.appendingPathComponent("context.json")
    let fileStore = Bunq.FileContextStore(url: url)
    _ = try await Bunq.Client.open(
        environment: .sandbox, apiKey: apiKey, signing: signing,
        registration: registration, transport: transport, contextStore: fileStore
    )
    let onDisk = Bunq.FileContextStore(url: url)
    _ = try await Bunq.Client.open(
        environment: .sandbox, apiKey: apiKey, signing: signing,
        registration: registration, transport: transport, contextStore: onDisk
    )
    let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
    let permissions = attributes[.posixPermissions] as? NSNumber
    guard permissions?.intValue == 0o600 else { throw Bunq.Failure.invalidResponse }

    // Malformed persisted data must fail closed, not create another device.
    try Data("not JSON".utf8).write(to: url)
    do {
        _ = try await Bunq.Client.open(
            environment: .sandbox, apiKey: apiKey, signing: signing,
            registration: registration, transport: transport, contextStore: onDisk
        )
        throw Bunq.Failure.invalidResponse
    } catch Bunq.Failure.contextStore {}
    counters = await server.counters()
    guard counters.installations == 2, counters.devices == 2, counters.sessions == 3 else {
        throw Bunq.Failure.invalidResponse
    }
}
