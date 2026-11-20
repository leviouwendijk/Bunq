import Bunq
import Foundation

func runWireKeyConvergenceTests() throws {
    let decoder = JSONDecoder()

    let account = try decoder.decode(
        Bunq.MonetaryAccount.self,
        from: Data(#"{"MonetaryAccountBank":{"id":23,"display_name":"Operations","alias":[{"iban":"NL91ABNA0417164300","display_name":"Owner","swift_bic":"ABNANL2A"}],"balance":{"value":"1.25","currency":"EUR"}}}"#.utf8)
    )
    guard account.display_name == "Operations",
          account.alias?.first?.display_name == "Owner",
          account.alias?.first?.swift_bic == "ABNANL2A" else {
        throw Bunq.Failure.invalidResponse
    }

    let payment = try decoder.decode(
        Bunq.Payment.self,
        from: Data(#"{"Payment":{"id":17,"monetary_account_id":23,"amount":{"value":"-1.25","currency":"EUR"},"sub_type":"PAYMENT","counterparty_alias":{"iban":"NL35RABO0117713678","display_name":"Payee"}}}"#.utf8)
    )
    guard payment.monetary_account_id.raw == 23,
          payment.sub_type == "PAYMENT",
          payment.counterparty_alias?.display_name == "Payee" else {
        throw Bunq.Failure.invalidResponse
    }

    let pagination = try decoder.decode(
        Bunq.Pagination.self,
        from: Data(#"{"older_url":"/v1/user/5/monetary-account?older_id=22","newer_url":null,"future_url":null}"#.utf8)
    )
    guard pagination.older_url != nil, pagination.older != nil else {
        throw Bunq.Failure.invalidResponse
    }

    // Direct wire names only: removing those names must not silently decode alternatives.
    let camelAccount = try decoder.decode(
        Bunq.MonetaryAccount.self,
        from: Data(#"{"MonetaryAccountBank":{"id":23,"displayName":"Not wire format","aliases":[]}}"#.utf8)
    )
    guard camelAccount.display_name == nil, camelAccount.alias == nil else {
        throw Bunq.Failure.invalidResponse
    }
}
