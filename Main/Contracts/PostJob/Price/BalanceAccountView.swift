//
//  BalanceAccountView.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 02.12.2022.
//

import UIKit

class BalanceAccountView: UIView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var walletNameLbl: UILabel!
    @IBOutlet private weak var balanceLbl: UILabel!
    
    func setViews(image: UIImage, name: String, balance: Double?) {
        imageView.image = image
        walletNameLbl.text = name
        if let balance {
            balanceLbl.text = "\(balance.removeZerosFromEnd())"
        }
    }
}
