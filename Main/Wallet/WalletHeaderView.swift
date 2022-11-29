//
//  WalletHeaderView.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 28.11.2022.
//

import UIKit

class WalletHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var balance: UILabel?
    @IBOutlet private weak var discount: UILabel?
    @IBOutlet private weak var totalBalanceInLbl: UILabel?
    
    func setViews(balance: Double?, discount: Double?) {
        var myString = "Total balance in SenseCoins"
        var myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSRange(location: 17, length: 10))
        totalBalanceInLbl?.attributedText = myMutableString
        
        self.balance?.text = balance?.removeZerosFromEnd()
        if let disc = discount {
            self.discount?.text = "\(disc.removeZerosFromEnd())%"
        } else {
            self.discount?.text = "0%"
        }
    }
 
}
