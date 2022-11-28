//
//  WalletHeaderView.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 28.11.2022.
//

import UIKit

class WalletHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var balance: UILabel!
    @IBOutlet private weak var discount: UILabel!   

    func setViews(balance: Double?, discount: Double?) {
        self.balance.text = balance?.removeZerosFromEnd()
        if let disc = discount {
            self.discount.text = "\(disc.removeZerosFromEnd())%"
        } else {
            self.discount.text = "0%"
        }
    }
 
}
