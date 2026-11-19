import Foundation
import HTTP
import Primitives
import Sensitivity
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum Bunq {}

public extension Bunq {
    enum Environment: Sendable, Equatable {
        case sandbox
        case production

        var host: String {
            switch self {
            case .sandbox: "public-api.sandbox.bunq.com"
            case .production: "api.bunq.com"
            }
        }
    }

    struct APIKey: Invariant, Sendable, Sensitivity.Redacted {
        public static let redactedLabel = "bunq API key"

        public let raw: String

        public init(_ raw: String) throws(InvarianceFailure) {
            try Invariance([.text.nonblank]).require(raw)
            self.raw = raw
        }
    }

    struct Token: Invariant, Sendable, Sensitivity.Redacted {
        public static let redactedLabel = "bunq token"

        public let raw: String

        public init(_ raw: String) throws(InvarianceFailure) {
            try Invariance([.text.nonblank]).require(raw)
            self.raw = raw
        }
    }

    struct Count: CodableInvariant, Hashable, Sendable {
        public let raw: Int

        public init(_ raw: Int) throws(InvarianceFailure) {
            try Invariance([.range.min(1), .range.max(200)]).require(raw)
            self.raw = raw
        }

        public static let standard = Self(unchecked: 100)

        private init(unchecked: Int) { raw = unchecked }
    }

    struct Installation: Sendable {
        public let environment: Environment
        public let token: Token
        public let serverPublicKey: String
        public let clientPublicKey: String

        public init(
            environment: Environment,
            token: Token,
            serverPublicKey: String,
            clientPublicKey: String
        ) throws(InvarianceFailure) {
            try Invariance([.text.nonblank]).require(serverPublicKey)
            try Invariance([.text.nonblank]).require(clientPublicKey)
            self.environment = environment
            self.token = token
            self.serverPublicKey = serverPublicKey
            self.clientPublicKey = clientPublicKey
        }
    }

    struct Device: Sendable {
        public let description: String
        public let permittedIPs: [String]

        public init(description: String, permittedIPs: [String] = []) throws(InvarianceFailure) {
            try Invariance([.text.nonblank]).require(description)
            self.description = description
            self.permittedIPs = permittedIPs
        }
    }

    enum Registration: Sendable {
        case register(Device)
        case reuse(Installation)
    }

    enum Failure: Swift.Error, Sendable, Equatable {
        case invalidResponse
        case invalidSignature
        case invalidTransportResponse
        case installationMismatch
        case contextMismatch
        case contextStore
        case invalidCursor
        case http(status: Int, message: String?)
    }

    /// Allows deterministic mock transports without requiring a network connection.
    struct Transport: Sendable {
        public let send: @Sendable (URLRequest) async throws -> (Data, HTTPURLResponse)

        public init(send: @escaping @Sendable (URLRequest) async throws -> (Data, HTTPURLResponse)) {
            self.send = send
        }

        public static let live = Self { request in
            let (data, response) = try await VerifiedSession.client.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw Failure.invalidTransportResponse
            }
            return (data, response)
        }
    }

    protocol Signing: Sendable {
        var publicKeyPEM: String { get }
        func sign(_ body: Data) throws -> String
        func verify(_ body: Data, signature: String, publicKey: String) throws
    }
}

extension Bunq {
    static func request(
        environment: Environment,
        endpoint: HTTPEndpoint,
        token: Token?,
        body: Data?,
        signer: (any Signing)?,
        sign: Bool
    ) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = environment.host
        let parts = endpoint.path.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: false)
        components.path = "/v1" + String(parts[0])
        if parts.count == 2 { components.percentEncodedQuery = String(parts[1]) }
        guard let url = components.url else { throw Failure.invalidResponse }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("BunqSwiftSDK/0.1", forHTTPHeaderField: "User-Agent")
        if let token { request.setValue(token.raw, forHTTPHeaderField: "X-Bunq-Client-Authentication") }
        if let body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if sign {
            guard let signer, let body else { throw Failure.invalidResponse }
            request.setValue(try signer.sign(body), forHTTPHeaderField: "X-Bunq-Client-Signature")
        }
        return request
    }

    static func perform(
        request: URLRequest,
        transport: Transport,
        signer: (any Signing)?,
        serverKey: String?
    ) async throws -> Data {
        let (data, response) = try await transport.send(request)
        if !(200..<300).contains(response.statusCode) {
            let error = try? JSONDecoder().decode(ProviderError.self, from: data)
            throw Failure.http(status: response.statusCode, message: error?.Error.first?.error_description)
        }
        if let signer, let serverKey {
            guard let signature = response.value(forHTTPHeaderField: "X-Bunq-Server-Signature") else {
                throw Failure.invalidSignature
            }
            try signer.verify(data, signature: signature, publicKey: serverKey)
        }
        return data
    }

    struct ProviderError: Decodable {
        let Error: [Entry]

        struct Entry: Decodable {
            let error_description: String?
        }
    }

    struct Response<Entry: Decodable>: Decodable {
        let Response: [Entry]
    }

    struct BootstrapEntry: Decodable {
        let Token: TokenItem?
        let ServerPublicKey: ServerKeyItem?
        let UserPerson: UserItem?
        let UserCompany: UserItem?
        let UserPaymentServiceProvider: UserItem?

        struct UserItem: Decodable {
            let id: User.ID
        }

        struct TokenItem: Decodable {
            let token: String
        }

        struct ServerKeyItem: Decodable {
            let server_public_key: String
        }
    }

    struct RegisterDevice: Encodable {
        let description: String
        let secret: String
        let permitted_ips: [String]?
    }

    struct Install: Encodable { let client_public_key: String }
    struct StartSession: Encodable { let secret: String }

    static func encode<T: Encodable>(_ value: T) throws -> Data {
        try JSONEncoder().encode(value)
    }

    static func installation(
        environment: Environment,
        apiKey: APIKey,
        signing: any Signing,
        registration: Registration,
        transport: Transport
    ) async throws -> Installation {
        switch registration {
        case .reuse(let installation):
            guard installation.environment == environment,
                  installation.clientPublicKey == signing.publicKeyPEM else {
                throw Failure.installationMismatch
            }
            return installation
        case .register(let device):
            let request = try request(
                environment: environment,
                endpoint: .init(method: .post, path: "/installation"),
                token: nil,
                body: encode(Install(client_public_key: signing.publicKeyPEM)),
                signer: nil,
                sign: false
            )
            // First installation supplies its own verification key (trust on first use).
            let (raw, initialResponse) = try await transport.send(request)
            guard (200..<300).contains(initialResponse.statusCode) else {
                throw Failure.http(status: initialResponse.statusCode, message: nil)
            }
            let items = try JSONDecoder().decode(Response<BootstrapEntry>.self, from: raw).Response
            guard let rawToken = items.compactMap(\.Token?.token).first,
                  let key = items.compactMap(\.ServerPublicKey?.server_public_key).first
            else { throw Failure.invalidResponse }
            guard let signature = initialResponse.value(forHTTPHeaderField: "X-Bunq-Server-Signature") else {
                throw Failure.invalidSignature
            }
            try signing.verify(raw, signature: signature, publicKey: key)
            let installed = try Installation(
                environment: environment,
                token: Token(rawToken),
                serverPublicKey: key,
                clientPublicKey: signing.publicKeyPEM
            )
            let register = try self.request(
                environment: environment,
                endpoint: .init(method: .post, path: "/device-server"),
                token: installed.token,
                body: encode(RegisterDevice(
                    description: device.description,
                    secret: apiKey.raw,
                    permitted_ips: device.permittedIPs.isEmpty ? nil : device.permittedIPs
                )),
                signer: signing,
                sign: true
            )
            _ = try await perform(request: register, transport: transport, signer: signing, serverKey: key)
            return installed
        }
    }

    static func session(
        environment: Environment,
        apiKey: APIKey,
        signing: any Signing,
        installation: Installation,
        transport: Transport
    ) async throws -> Session {
        let request = try self.request(
            environment: environment,
            endpoint: .init(method: .post, path: "/session-server"),
            token: installation.token,
            body: encode(StartSession(secret: apiKey.raw)),
            signer: signing,
            sign: true
        )
        let data = try await perform(request: request, transport: transport, signer: signing, serverKey: installation.serverPublicKey)
        let items = try JSONDecoder().decode(Response<BootstrapEntry>.self, from: data).Response
        guard let raw = items.compactMap(\.Token?.token).first else { throw Failure.invalidResponse }
        let identities: [User.Identity] = items.flatMap { entry in
            var identities: [User.Identity] = []
            if let person = entry.UserPerson {
                identities.append(User.Identity(id: person.id, kind: .person))
            }
            if let company = entry.UserCompany {
                identities.append(User.Identity(id: company.id, kind: .company))
            }
            if let provider = entry.UserPaymentServiceProvider {
                identities.append(User.Identity(id: provider.id, kind: .payment_service_provider))
            }
            return identities
        }
        guard identities.count <= 1 else { throw Failure.invalidResponse }
        return Session(token: try Token(raw), user: identities.first)
    }
}

private enum VerifiedSession {
    static let client: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.httpShouldSetCookies = false
        configuration.httpCookieAcceptPolicy = .never
        return URLSession(configuration: configuration, delegate: BlockRedirects(), delegateQueue: nil)
    }()
}

private final class BlockRedirects: NSObject, URLSessionTaskDelegate, @unchecked Sendable {
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void
    ) {
        completionHandler(nil)
    }
}
