//
//  WalletModel.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 24.11.2022.
//

import Foundation
import UIKit

struct WalletModel: Codable {
    var data: WalletBalanceRes?
    var error: ErrorResponseModel?
}

struct WalletBalanceRes: Codable {
    var checking_balance: String?
    var discount: String?
    var frozen_balance: String?
    var granted_loan_balance: String?
    var hash: String?
    var level: String?
    var loan_balance: String?
    var operating_balance: String?
    var overdue_contract_loan: OverdueContractLoanDetails?
    var saving_balance: String?
    var status: String?
    var user_status: String?
}

struct OverdueContractLoanDetails: Codable {
    var amount_refund_loan_account: String?
    var amount_refund_other_accounts: String?
    var hash: String?
    var lender: LenderModel?
    var name: String?
}

struct LenderModel: Codable {
    var avatar_link: String?
    var hash: String?
    var rate: Int?
    var username: String?
}

struct SectionWallet {
    var data: [WalletModelCell]
}

struct WalletModelCell {
    var image: UIImage
    var text: String
    var balance: Double?
}
