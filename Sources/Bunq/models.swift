import Foundation
import Primitives

public extension Bunq {
    struct User: Sendable {
        public struct Identity: Codable, Sendable, Equatable {
            public enum Kind: String, Codable, Sendable {
                case person
                case company
                case payment_service_provider
            }

            public let id: ID
            public let kind: Kind

            public init(id: ID, kind: Kind) {
                self.id = id
                self.kind = kind
            }
        }
        public struct ID: CodableInvariant, Hashable, Sendable {
            public let raw: Int64

            public init(_ raw: Int64) throws(InvarianceFailure) {
                try Invariance([.range.min(1)]).require(raw)
                self.raw = raw
            }
        }
    }

    struct MonetaryAccount: Decodable, Sendable {
        public struct ID: CodableInvariant, Hashable, Sendable {
            public let raw: Int64

            public init(_ raw: Int64) throws(InvarianceFailure) {
                try Invariance([.range.min(1)]).require(raw)
                self.raw = raw
            }
        }

        public let id: ID
        public let description: String?
        public let balance: Amount?
        public let kind: Kind
        public let display_name: String?
        public let created: String?
        public let status: String?
        public let alias: [Party]?

        public enum Kind: Sendable, Hashable {
            case light
            case bank
            case external
            case investment
            case joint
            case savings
            case switchService
            case externalSavings
            case card
            case unknown(String)

            init(_ raw: String) {
                switch raw {
                case "MonetaryAccountLight": self = .light
                case "MonetaryAccountBank": self = .bank
                case "MonetaryAccountExternal": self = .external
                case "MonetaryAccountInvestment": self = .investment
                case "MonetaryAccountJoint": self = .joint
                case "MonetaryAccountSavings": self = .savings
                case "MonetaryAccountSwitchService": self = .switchService
                case "MonetaryAccountExternalSavings": self = .externalSavings
                case "MonetaryAccountCard": self = .card
                default: self = .unknown(raw)
                }
            }
        }

        // The account variant is the outer JSON member name, not a field on the account.
        private struct Fields: Decodable {
            let id: ID
            let description: String?
            let balance: Amount?
            let display_name: String?
            let created: String?
            let status: String?
            let alias: [Party]?
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let wrappers = try container.decode([String: Fields].self)
            guard wrappers.count == 1, let (name, fields) = wrappers.first else {
                throw Failure.invalidResponse
            }
            id = fields.id
            description = fields.description
            balance = fields.balance
            display_name = fields.display_name
            created = fields.created
            status = fields.status
            alias = fields.alias
            kind = Kind(name)
        }
    }

    struct Payment: Decodable, Sendable {
        public struct ID: CodableInvariant, Hashable, Sendable {
            public let raw: Int64

            public init(_ raw: Int64) throws(InvarianceFailure) {
                try Invariance([.range.min(1)]).require(raw)
                self.raw = raw
            }
        }

        public let id: ID
        public let monetary_account_id: MonetaryAccount.ID
        public let amount: Amount
        public let description: String?
        public let created: String?
        public let updated: String?
        public let type: String?
        public let sub_type: String?
        public let counterparty_alias: Party?

        private struct Fields: Decodable {
            let id: ID
            let monetary_account_id: MonetaryAccount.ID
            let amount: Amount
            let description: String?
            let created: String?
            let updated: String?
            let type: String?
            let sub_type: String?
            let counterparty_alias: Party?
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let wrappers = try container.decode([String: Fields].self)
            guard wrappers.count == 1, let fields = wrappers["Payment"] else {
                throw Failure.invalidResponse
            }
            id = fields.id
            monetary_account_id = fields.monetary_account_id
            amount = fields.amount
            description = fields.description
            created = fields.created
            updated = fields.updated
            type = fields.type
            sub_type = fields.sub_type
            counterparty_alias = fields.counterparty_alias
        }
    }

    struct Party: Decodable, Sendable {
        public let iban: String?
        public let display_name: String?
        public let country: String?
        public let swift_bic: String?
    }

    struct Amount: Decodable, Sendable {
        public let value: Decimal
        public let currency: Currency

        private struct Fields: Decodable {
            let value: String
            let currency: Currency
        }

        public init(from decoder: Decoder) throws {
            let fields = try Fields(from: decoder)
            guard let decimal = Decimal(string: fields.value, locale: Locale(identifier: "en_US_POSIX")),
                  !decimal.isNaN else {
                throw Failure.invalidResponse
            }
            value = decimal
            currency = fields.currency
        }
    }

    struct Page<Element: Sendable>: Sendable {
        public let items: [Element]
        public let pagination: Pagination
    }

    struct Pagination: Decodable, Sendable {
        public struct Cursor: Sendable {
            fileprivate let resourcePath: String
            fileprivate let parameter: String
            fileprivate let identifier: Int64

            fileprivate init?(url: String) {
                guard let parsed = URLComponents(string: url),
                      parsed.user == nil, parsed.password == nil,
                      parsed.fragment == nil,
                      parsed.path.hasPrefix("/v1/"),
                      parsed.scheme == nil || parsed.scheme == "https",
                      parsed.host == nil ||
                        parsed.host == "api.bunq.com" ||
                        parsed.host == "public-api.sandbox.bunq.com"
                else { return nil }
                let matches = (parsed.queryItems ?? []).filter {
                    $0.name == "older_id" || $0.name == "newer_id"
                }
                guard matches.count == 1,
                      let raw = matches[0].value,
                      let id = Int64(raw), id > 0
                else { return nil }
                resourcePath = String(parsed.path.dropFirst(3))
                parameter = matches[0].name
                identifier = id
            }

            func suffix(for path: String) throws -> String {
                guard resourcePath == path else { throw Failure.invalidCursor }
                return "&\(parameter)=\(identifier)"
            }
        }

        public let older_url: String?
        public let newer_url: String?
        public let future_url: String?
        public let older: Cursor?
        public let newer: Cursor?
        public let future: Cursor?

        init() {
            older_url = nil
            newer_url = nil
            future_url = nil
            older = nil
            newer = nil
            future = nil
        }

        public init(from decoder: Decoder) throws {
            let fields = try Fields(from: decoder)
            older_url = fields.older_url
            newer_url = fields.newer_url
            future_url = fields.future_url
            if let older_url {
                guard let cursor = Cursor(url: older_url), cursor.parameter == "older_id" else {
                    throw Failure.invalidCursor
                }
                older = cursor
            } else { older = nil }
            if let newer_url {
                guard let cursor = Cursor(url: newer_url), cursor.parameter == "newer_id" else {
                    throw Failure.invalidCursor
                }
                newer = cursor
            } else { newer = nil }
            // The provider's future_url may be a non-cursor polling URL.
            future = future_url.flatMap(Cursor.init(url:))
        }

        private struct Fields: Decodable {
            let older_url: String?
            let newer_url: String?
            let future_url: String?
        }
    }

    struct Listing<Entry: Decodable>: Decodable {
        let Response: [Entry]
        let Pagination: Bunq.Pagination?
    }
}
