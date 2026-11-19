#if canImport(Security)
import Foundation
import Security
import Cryptography

public extension Bunq {
    final class SigningIdentity: Signing, @unchecked Sendable {
        public let publicKeyPEM: String
        private let privateKey: SecKey

        public init(publicKeyURL: URL, privateKeyURL: URL) throws {
            publicKeyPEM = try String(contentsOf: publicKeyURL, encoding: .utf8)
            privateKey = try CryptographicKeyOperation.loadPrivateKey(at: privateKeyURL.path)
        }

        public func sign(_ body: Data) throws -> String {
            var error: Unmanaged<CFError>?
            guard let signature = SecKeyCreateSignature(
                privateKey, .rsaSignatureMessagePKCS1v15SHA256, body as CFData, &error
            ) as Data? else {
                throw Bunq.Failure.invalidSignature
            }
            return signature.base64EncodedString()
        }

        public func verify(_ body: Data, signature: String, publicKey: String) throws {
            guard let data = Data(base64Encoded: signature),
                  let pem = CryptographicKeyOperation.pemBody(
                    publicKey,
                    begin: "-----BEGIN PUBLIC KEY-----",
                    end: "-----END PUBLIC KEY-----"
                  )
            else { throw Bunq.Failure.invalidSignature }
            let key = try CryptographicKeyOperation.makeSecKeyFromDER(pem, isPublic: true)
            var error: Unmanaged<CFError>?
            guard SecKeyVerifySignature(
                key, .rsaSignatureMessagePKCS1v15SHA256,
                body as CFData, data as CFData, &error
            ) else { throw Bunq.Failure.invalidSignature }
        }
    }
}
#endif
