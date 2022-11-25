//
//  WalletModel.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 24.11.2022.
//

import Foundation
import UIKit

struct WalletModel: Codable {
    var data: DataWalletModel?
    var error: ErrorResponseModel?
}

struct DataWalletModel: Codable {
    var checking_balance: Double?
    var discount: Double?
    var frozen_balance: Double?
    var granted_loan_balance: Double?
    var hash: String?
    var level: String?
    var loan_balance: Double?
    var operating_balance: Double?
    var saving_balance: Double?
}

struct SectionWallet {
    var data: [WalletModelCell]
}

struct WalletModelCell {
    var image: UIImage
    var text: String
    var balance: Double?
}
