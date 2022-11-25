//
//  BalanceAccountTableViewCell.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 25.11.2022.
//

import UIKit

class BalanceAccountTableViewCell: UITableViewCell {

    @IBOutlet private weak var imageBalance: UIImageView?
    @IBOutlet private weak var nameLbl: UILabel?
    @IBOutlet private weak var balanceLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setViews(model: WalletModelCell) {
        nameLbl?.text = model.text
        imageBalance?.image = model.image
        if let balance = model.balance {
            balanceLbl?.text = "\(balance) "
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
