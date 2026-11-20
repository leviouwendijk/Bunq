import Foundation
import Bunq
import Milieu
import Darwin

enum LiveFailure: Error {
    case unavailableFile(String)
    case invalidUserID
    case unexpectedAuthenticationFlow
}

func diagnose(_ error: any Error) -> String {
    if case let LiveFailure.unavailableFile(variable) = error {
        return "PEM path from \(variable) is not readable on this machine; no Bunq request was made"
    }
    if case LiveFailure.invalidUserID = error {
        return "BUNQ_SANDBOX_USER_ID must match the authenticated session user ID"
    }
    if case LiveFailure.unexpectedAuthenticationFlow = error {
        return "unexpected bootstrap request sequence; inspect session lifecycle behavior"
    }
    if case let Bunq.Failure.http(status, message) = error {
        // Provider error descriptions can contain request-specific data.
        // Classify without printing the description or any credential material.
        let description = message?.lowercased() ?? ""
        let category: String
        if description.contains("signature") {
            category = "signature rejected"
        } else if description.contains("permitted_ips") {
            category = "permitted_ips rejected"
        } else if description.contains("ip address") || description.contains("ip restriction") {
            category = "IP restriction rejected"
        } else if description.contains("api key") || description.contains("api_key") || description.contains("apikey") {
            category = "API key rejected or expired"
        } else if description.contains("secret") {
            category = "credential secret rejected"
        } else if description.contains("expired") {
            category = "credential expired"
        } else if description.contains("device") {
            category = "device registration rejected"
        } else if message == nil {
            category = "no decoded provider error description"
        } else {
            category = "unclassified provider rejection"
        }
        return "provider returned HTTP \(status): \(category)"
    }
    if case let DecodingError.keyNotFound(key, context) = error {
        let path = context.codingPath.map(\.stringValue).joined(separator: ".")
        return "missing documented JSON key \(key.stringValue) at \(path)"
    }
    if error is DecodingError {
        return "provider JSON does not match an SDK response model"
    }
    if case Bunq.Failure.contextMismatch = error {
        return "stored Bunq context does not match the environment or credentials; explicit reset required"
    }
    if case Bunq.Failure.contextStore = error {
        return "stored Bunq context could not be securely read or written"
    }
    if error is Bunq.Failure {
        return "Bunq protocol or response-signature verification failed (\(error))"
    }
    return "error type: \(type(of: error))"
}

private struct BootstrapCounts: Sendable {
    let installations: Int
    let registrations: Int
    let sessions: Int
}

private actor BootstrapTrace {
    private var installations = 0
    private var registrations = 0
    private var sessions = 0

    func record(_ path: String) {
        switch path {
        case "/v1/installation":
            installations += 1
        case "/v1/device-server":
            registrations += 1
        case "/v1/session-server":
            sessions += 1
        default:
            break
        }
    }

    func snapshot() -> BootstrapCounts {
        BootstrapCounts(
            installations: installations,
            registrations: registrations,
            sessions: sessions
        )
    }
}

private func reportAuthenticatedReads(
    trace: BootstrapTrace,
    opened: BootstrapCounts
) async throws {
    let completed = await trace.snapshot()
    guard completed.installations == opened.installations,
          completed.registrations == opened.registrations else {
        throw LiveFailure.unexpectedAuthenticationFlow
    }
    switch completed.sessions - opened.sessions {
    case 0:
        print("PASS Bunq sandbox: authenticated reads reused the existing session (no renewal)")
    case 1:
        print("PASS Bunq sandbox: expired session renewed once without device registration")
    default:
        throw LiveFailure.unexpectedAuthenticationFlow
    }
}

func run() async throws {
    let apiKey = try Bunq.APIKey(EnvironmentExtractor.value("BUNQ_SANDBOX_API_KEY"))
    let replacer = EnvironmentReplacer(
        replacements: [
            .home,

            // locally testing
            .variable(
                key: "myworkdir/programming",
                replacement: .value("main/programming/bundles")
            )
        ]
    )

    let publicPath = try EnvironmentExtractor.value("BUNQ_PUBLIC_KEY_PATH", replacer: replacer)
    let privatePath = try EnvironmentExtractor.value("BUNQ_PRIVATE_KEY_PATH", replacer: replacer)

    guard FileManager.default.isReadableFile(atPath: publicPath) else {
        throw LiveFailure.unavailableFile("BUNQ_PUBLIC_KEY_PATH")
    }
    guard FileManager.default.isReadableFile(atPath: privatePath) else {
        throw LiveFailure.unavailableFile("BUNQ_PRIVATE_KEY_PATH")
    }

    let signing = try Bunq.SigningIdentity(
        publicKeyURL: URL(fileURLWithPath: publicPath),
        privateKeyURL: URL(fileURLWithPath: privatePath)
    )
    // Identify the rejected bootstrap endpoint without disclosing headers,
    // credentials, request bodies, response bodies, or account identifiers.
    let bootstrapTrace = BootstrapTrace()
    let diagnosticTransport = Bunq.Transport { request in
        if request.httpMethod == "POST" {
            await bootstrapTrace.record(request.url?.path ?? "")
        }
        let (data, response) = try await Bunq.Transport.live.send(request)
        if !(200..<300).contains(response.statusCode) {
            let path = request.url?.path ?? ""
            let stage: String
            switch path {
            case "/v1/installation":
                stage = "installation"
            case "/v1/device-server":
                stage = "device-server"
            case "/v1/session-server":
                stage = "session-server"
            default:
                stage = "authenticated-read"
            }
            FileHandle.standardError.write(
                Data("Bunq HTTP \(response.statusCode) at \(stage)\n".utf8)
            )
        }
        return (data, response)
    }

    let contextPath = EnvironmentExtractor.optional("BUNQ_CONTEXT_PATH", replacer: replacer)
        ?? FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".config/bunq/sandbox-context.json").path
    let contextStore = Bunq.FileContextStore(url: URL(fileURLWithPath: contextPath))
    let client = try await Bunq.Client.open(
        environment: .sandbox,
        apiKey: apiKey,
        signing: signing,
        registration: .register(Bunq.Device(description: "Bunq Swift sandbox integration")),
        transport: diagnosticTransport,
        contextStore: contextStore
    )
    let opened = await bootstrapTrace.snapshot()
    switch (opened.installations, opened.registrations, opened.sessions) {
    case (0, 0, 0):
        print("PASS Bunq sandbox: restored persisted session (zero bootstrap requests)")
    case (0, 0, 1):
        print("PASS Bunq sandbox: reused registered installation; created a new session")
    case (1, 1, 1):
        print("PASS Bunq sandbox: created installation, registered device and opened session")
    default:
        throw LiveFailure.unexpectedAuthenticationFlow
    }

    guard let identity = await client.authenticatedUser else {
        print("SKIP Bunq account/payment reads: session did not identify an authenticated user")
        return
    }
    let user = identity.id
    if let rawUser = EnvironmentExtractor.optional("BUNQ_SANDBOX_USER_ID") {
        guard let numericID = Int64(rawUser), numericID > 0,
              numericID == user.raw else { throw LiveFailure.invalidUserID }
    }
    let count = try Bunq.Count(10)
    let accounts = try await client.user(user).accounts.list(count: count)
    print("PASS Bunq sandbox: account page decoded (\(accounts.items.count) items)")

    guard let first = accounts.items.first else {
        try await reportAuthenticatedReads(trace: bootstrapTrace, opened: opened)
        print("SKIP Bunq payment read: sandbox user has no monetary accounts")
        return
    }
    let payments = try await client.user(user).account(first.id).payments.list(count: count)
    print("PASS Bunq sandbox: payment page decoded (\(payments.items.count) items)")
    try await reportAuthenticatedReads(trace: bootstrapTrace, opened: opened)
}

do {
    try await run()
} catch {
    FileHandle.standardError.write(Data("FAIL Bunq sandbox: \(diagnose(error))\n".utf8))
    exit(1)
}
