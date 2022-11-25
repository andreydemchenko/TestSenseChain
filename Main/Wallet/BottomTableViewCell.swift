//
//  BottomTableViewCell.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 25.11.2022.
//

import UIKit

class BottomTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLbl: UILabel?
    @IBOutlet private weak var imageBottom: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setViews(model: WalletModelCell) {
        nameLbl?.text = model.text
        imageBottom?.image = model.image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
