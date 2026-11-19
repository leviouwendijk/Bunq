import Foundation
import HTTP

public extension Bunq {
    actor Client {
        private let environment: Environment
        private let apiKey: APIKey
        private let signing: any Signing
        private let transport: Transport
        private let contextStore: (any ContextStore)?
        public nonisolated let installation: Installation
        private var session: Session
        private var refreshTask: Task<Session, any Error>?

        public var authenticatedUser: User.Identity? { session.user }

        private init(
            environment: Environment,
            apiKey: APIKey,
            signing: any Signing,
            transport: Transport,
            installation: Installation,
            session: Session,
            contextStore: (any ContextStore)?
        ) {
            self.environment = environment
            self.apiKey = apiKey
            self.signing = signing
            self.transport = transport
            self.installation = installation
            self.session = session
            self.contextStore = contextStore
        }

        public static func open(
            environment: Environment,
            apiKey: APIKey,
            signing: any Signing,
            registration: Registration,
            transport: Transport = .live,
            contextStore: (any ContextStore)? = nil
        ) async throws -> Client {
            guard let contextStore else {
                let installation = try await Bunq.installation(
                    environment: environment, apiKey: apiKey,
                    signing: signing, registration: registration, transport: transport
                )
                let session = try await Bunq.session(
                    environment: environment, apiKey: apiKey,
                    signing: signing, installation: installation, transport: transport
                )
                return Client(
                    environment: environment, apiKey: apiKey, signing: signing,
                    transport: transport, installation: installation, session: session,
                    contextStore: nil
                )
            }
            return try await contextStore.withExclusiveLease {
                let saved = try await contextStore.load()
                let installation: Installation
                let existingSession: Session?
                if let saved {
                    let restored = try saved.restore(
                        environment: environment, apiKey: apiKey, signing: signing
                    )
                    if case .reuse(let supplied) = registration {
                        guard supplied.token.raw == restored.installation.token.raw,
                              supplied.serverPublicKey == restored.installation.serverPublicKey,
                              supplied.clientPublicKey == restored.installation.clientPublicKey,
                              supplied.environment == restored.installation.environment
                        else { throw Failure.contextMismatch }
                    }
                    installation = restored.installation
                    existingSession = restored.session
                } else {
                    installation = try await Bunq.installation(
                        environment: environment, apiKey: apiKey,
                        signing: signing, registration: registration, transport: transport
                    )
                    existingSession = nil
                    // Device registration succeeded; persist before opening a session.
                    try await contextStore.save(StoredContext(
                        environment: environment, apiKey: apiKey,
                        installation: installation, session: nil
                    ))
                }
                let session: Session
                if let existingSession {
                    session = existingSession
                } else {
                    session = try await Bunq.session(
                        environment: environment, apiKey: apiKey,
                        signing: signing, installation: installation, transport: transport
                    )
                    try await contextStore.save(StoredContext(
                        environment: environment, apiKey: apiKey,
                        installation: installation, session: session
                    ))
                }
                return Client(
                    environment: environment, apiKey: apiKey, signing: signing,
                    transport: transport, installation: installation, session: session,
                    contextStore: contextStore
                )
            }
        }

        public nonisolated func user(_ id: User.ID) -> UserScope {
            UserScope(client: self, id: id)
        }

        fileprivate func list<T: Decodable & Sendable>(
            path: String,
            count: Count,
            cursor: Pagination.Cursor?,
            as type: T.Type
        ) async throws -> Page<T> {
            let suffix = try cursor?.suffix(for: path) ?? ""
            let endpoint = HTTPEndpoint(method: .get, path: path + "?count=\(count.raw)" + suffix)
            let data = try await fetch(endpoint)
            let listing = try JSONDecoder().decode(Listing<T>.self, from: data)
            return Page(items: listing.Response, pagination: listing.Pagination ?? Pagination.empty)
        }

        fileprivate func read<T: Decodable & Sendable>(
            path: String,
            as type: T.Type
        ) async throws -> T {
            let data = try await fetch(HTTPEndpoint(method: .get, path: path))
            let entries = try JSONDecoder().decode(Response<T>.self, from: data).Response
            guard entries.count == 1 else { throw Failure.invalidResponse }
            return entries[0]
        }

        private func fetch(_ endpoint: HTTPEndpoint) async throws -> Data {
            let rejectedToken = session.token
            let request = try Bunq.request(
                environment: environment, endpoint: endpoint,
                token: rejectedToken, body: nil, signer: nil, sign: false
            )
            do {
                return try await Bunq.perform(
                    request: request, transport: transport,
                    signer: signing, serverKey: installation.serverPublicKey
                )
            } catch Failure.http(status: 401, message: _) {
                let renewed = try await refresh(after: rejectedToken)
                let retry = try Bunq.request(
                    environment: environment, endpoint: endpoint,
                    token: renewed, body: nil, signer: nil, sign: false
                )
                return try await Bunq.perform(
                    request: retry, transport: transport,
                    signer: signing, serverKey: installation.serverPublicKey
                )
            }
        }

        private func refresh(after rejectedToken: Token) async throws -> Token {
            if session.token.raw != rejectedToken.raw {
                return session.token
            }
            if let refreshTask {
                return (try await refreshTask.value).token
            }
            let task = Task { try await renewedSession(after: rejectedToken) }
            refreshTask = task
            do {
                let renewed = try await task.value
                session = renewed
                refreshTask = nil
                return renewed.token
            } catch {
                refreshTask = nil
                throw error
            }
        }

        private func renewedSession(after rejectedToken: Token) async throws -> Session {
            guard let contextStore else {
                return try await Bunq.session(
                    environment: environment, apiKey: apiKey, signing: signing,
                    installation: installation, transport: transport
                )
            }
            let environment = self.environment
            let apiKey = self.apiKey
            let signing = self.signing
            let installation = self.installation
            let transport = self.transport
            return try await contextStore.withExclusiveLease {
                guard let stored = try await contextStore.load() else {
                    throw Failure.contextMismatch
                }
                let restored = try stored.restore(
                    environment: environment, apiKey: apiKey, signing: signing
                )
                guard restored.installation.token.raw == installation.token.raw,
                      restored.installation.serverPublicKey == installation.serverPublicKey
                else { throw Failure.contextMismatch }
                // Another process may already have completed the renewal.
                if let latest = restored.session, latest.token.raw != rejectedToken.raw {
                    return latest
                }
                let fresh = try await Bunq.session(
                    environment: environment, apiKey: apiKey,
                    signing: signing, installation: installation, transport: transport
                )
                try await contextStore.save(StoredContext(
                    environment: environment, apiKey: apiKey,
                    installation: installation, session: fresh
                ))
                return fresh
            }
        }
    }

    struct UserScope: Sendable {
        fileprivate let client: Client
        public let id: User.ID

        public func account(_ id: MonetaryAccount.ID) -> AccountScope {
            AccountScope(client: client, user: self.id, account: id)
        }

        public var accounts: Accounts { Accounts(client: client, user: id) }
    }

    struct Accounts: Sendable {
        fileprivate let client: Client
        fileprivate let user: User.ID

        public func list(
            count: Count = .standard,
            cursor: Pagination.Cursor? = nil
        ) async throws -> Page<MonetaryAccount> {
            try await client.list(
                path: "/user/\(user.raw)/monetary-account", count: count,
                cursor: cursor, as: MonetaryAccount.self
            )
        }

        public func get(_ id: MonetaryAccount.ID) async throws -> MonetaryAccount {
            let account: MonetaryAccount = try await client.read(
                path: "/user/\(user.raw)/monetary-account/\(id.raw)",
                as: MonetaryAccount.self
            )
            guard account.id == id else { throw Failure.invalidResponse }
            return account
        }
    }

    struct AccountScope: Sendable {
        fileprivate let client: Client
        public let user: User.ID
        public let account: MonetaryAccount.ID

        public var payments: Payments { Payments(client: client, user: user, account: account) }
    }

    struct Payments: Sendable {
        fileprivate let client: Client
        fileprivate let user: User.ID
        fileprivate let account: MonetaryAccount.ID

        public func list(
            count: Count = .standard,
            cursor: Pagination.Cursor? = nil
        ) async throws -> Page<Payment> {
            try await client.list(
                path: "/user/\(user.raw)/monetary-account/\(account.raw)/payment",
                count: count, cursor: cursor, as: Payment.self
            )
        }

        public func get(_ id: Payment.ID) async throws -> Payment {
            let payment: Payment = try await client.read(
                path: "/user/\(user.raw)/monetary-account/\(account.raw)/payment/\(id.raw)",
                as: Payment.self
            )
            guard payment.id == id, payment.monetary_account_id == account else {
                throw Failure.invalidResponse
            }
            return payment
        }
    }
}

extension Bunq.Pagination {
    static let empty = Self()
}
