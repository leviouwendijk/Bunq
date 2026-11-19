import CryptoKit
import Foundation
import Darwin

public extension Bunq {
    struct Session: Sendable {
        public let token: Token
        public let user: User.Identity?

        public init(token: Token, user: User.Identity?) {
            self.token = token
            self.user = user
        }
    }

    struct StoredContext: Codable, Sendable, CustomStringConvertible {
        public let version: Int
        public let environment: String
        public let apiKeyFingerprint: String
        public let installationToken: String
        public let serverPublicKey: String
        public let clientPublicKey: String
        public let sessionToken: String?
        public let user: User.Identity?

        public var description: String { "<redacted bunq context>" }

        public init(
            environment: Environment,
            apiKey: APIKey,
            installation: Installation,
            session: Session?
        ) {
            version = 1
            self.environment = environment.identifier
            apiKeyFingerprint = Self.fingerprint(apiKey)
            installationToken = installation.token.raw
            serverPublicKey = installation.serverPublicKey
            clientPublicKey = installation.clientPublicKey
            sessionToken = session?.token.raw
            user = session?.user
        }

        public func restore(
            environment: Environment,
            apiKey: APIKey,
            signing: any Signing
        ) throws -> (installation: Installation, session: Session?) {
            guard version == 1,
                  self.environment == environment.identifier,
                  apiKeyFingerprint == Self.fingerprint(apiKey),
                  clientPublicKey == signing.publicKeyPEM,
                  (sessionToken != nil || user == nil)
            else { throw Failure.contextMismatch }
            let installation = try Installation(
                environment: environment,
                token: Token(installationToken),
                serverPublicKey: serverPublicKey,
                clientPublicKey: clientPublicKey
            )
            let session = try sessionToken.map { Session(token: try Token($0), user: user) }
            return (installation, session)
        }

        private static func fingerprint(_ apiKey: APIKey) -> String {
            SHA256.hash(data: Data(apiKey.raw.utf8)).map { String(format: "%02x", $0) }.joined()
        }
    }

    protocol ContextStore: Sendable {
        func load() async throws -> StoredContext?
        func save(_ context: StoredContext) async throws
        /// Explicit reset only; callers must hold the exclusive lease.
        func invalidate() async throws
        /// Holds a store-scoped, cross-process lease over load, bootstrap/renewal, and save.
        func withExclusiveLease<T: Sendable>(
            _ operation: @Sendable () async throws -> T
        ) async throws -> T
    }

    actor FileContextStore: ContextStore {
        private let fileURL: URL
        private let lockURL: URL

        public init(url: URL) {
            fileURL = url
            lockURL = url.appendingPathExtension("lock")
        }

        public func load() throws -> StoredContext? {
            try ensureProtectedDirectory()
            let descriptor = Darwin.open(fileURL.path, O_RDONLY | O_NOFOLLOW)
            if descriptor < 0 && errno == ENOENT { return nil }
            guard descriptor >= 0 else { throw Failure.contextStore }
            defer { _ = Darwin.close(descriptor) }
            try validateDescriptor(descriptor)
            let handle = FileHandle(fileDescriptor: descriptor, closeOnDealloc: false)
            let data = try handle.readToEnd() ?? Data()
            guard let stored = try? JSONDecoder().decode(StoredContext.self, from: data) else {
                throw Failure.contextStore
            }
            return stored
        }

        public func save(_ context: StoredContext) throws {
            try ensureProtectedDirectory()
            var existing = stat()
            if lstat(fileURL.path, &existing) == 0 {
                try validate(fileURL)
            } else if errno != ENOENT {
                throw Failure.contextStore
            }
            let data = try JSONEncoder().encode(context)
            let temporaryURL = fileURL.deletingLastPathComponent()
                .appendingPathComponent(".bunq-context-\(UUID().uuidString).tmp")
            let descriptor = Darwin.open(
                temporaryURL.path, O_WRONLY | O_CREAT | O_EXCL | O_NOFOLLOW, mode_t(0o600)
            )
            guard descriptor >= 0 else { throw Failure.contextStore }
            var replaced = false
            defer {
                _ = Darwin.close(descriptor)
                if !replaced { _ = Darwin.unlink(temporaryURL.path) }
            }
            let written = data.withUnsafeBytes { buffer -> Bool in
                guard let base = buffer.baseAddress else { return data.isEmpty }
                var index = 0
                while index < buffer.count {
                    let count = Darwin.write(descriptor, base.advanced(by: index), buffer.count - index)
                    if count < 0 && errno == EINTR { continue }
                    guard count > 0 else { return false }
                    index += count
                }
                return true
            }
            guard written, Darwin.fsync(descriptor) == 0,
                  Darwin.rename(temporaryURL.path, fileURL.path) == 0
            else { throw Failure.contextStore }
            replaced = true
        }

        public func invalidate() throws {
            try ensureProtectedDirectory()
            var existing = stat()
            if lstat(fileURL.path, &existing) != 0 {
                guard errno == ENOENT else { throw Failure.contextStore }
                return
            }
            try validate(fileURL)
            guard Darwin.unlink(fileURL.path) == 0 else { throw Failure.contextStore }
        }

        public func withExclusiveLease<T: Sendable>(
            _ operation: @Sendable () async throws -> T
        ) async throws -> T {
            try ensureProtectedDirectory()
            let descriptor = Darwin.open(
                lockURL.path, O_RDWR | O_CREAT | O_NOFOLLOW, mode_t(0o600)
            )
            guard descriptor >= 0 else { throw Failure.contextStore }
            defer {
                _ = flock(descriptor, LOCK_UN)
                _ = Darwin.close(descriptor)
            }
            try validateDescriptor(descriptor)
            while flock(descriptor, LOCK_EX | LOCK_NB) != 0 {
                guard errno == EWOULDBLOCK || errno == EAGAIN else {
                    throw Failure.contextStore
                }
                try await Task.sleep(for: .milliseconds(100))
            }
            return try await operation()
        }

        private func ensureProtectedDirectory() throws {
            let directory = fileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true,
                attributes: [.posixPermissions: 0o700]
            )
            var info = stat()
            guard lstat(directory.path, &info) == 0,
                  (info.st_mode & mode_t(S_IFMT)) == mode_t(S_IFDIR),
                  info.st_uid == getuid(),
                  info.st_mode & 0o077 == 0
            else { throw Failure.contextStore }
        }

        private func validate(_ url: URL) throws {
            var info = stat()
            guard lstat(url.path, &info) == 0,
                  (info.st_mode & mode_t(S_IFMT)) == mode_t(S_IFREG),
                  info.st_uid == getuid(),
                  info.st_mode & 0o077 == 0
            else { throw Failure.contextStore }
        }

        private func validateDescriptor(_ descriptor: Int32) throws {
            var info = stat()
            guard fstat(descriptor, &info) == 0,
                  (info.st_mode & mode_t(S_IFMT)) == mode_t(S_IFREG),
                  info.st_uid == getuid(),
                  info.st_mode & 0o077 == 0
            else { throw Failure.contextStore }
        }
    }
}

extension Bunq.Environment {
    var identifier: String {
        switch self {
        case .sandbox: "sandbox"
        case .production: "production"
        }
    }
}
