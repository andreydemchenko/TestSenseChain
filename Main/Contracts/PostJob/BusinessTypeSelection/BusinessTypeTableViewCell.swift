//
//  BusinessTypeTableViewCell.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 01.12.2022.
//

import UIKit

class BusinessTypeTableViewCell: UITableViewCell {

    @IBOutlet private weak var typeName: UILabel!
    @IBOutlet private weak var checkedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setViews(name: String, isChecked: Bool) {
        typeName.text = name
        checkedImageView.isHidden = !isChecked
    }
    
}
