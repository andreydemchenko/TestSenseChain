//
//  ContractsHeaderView.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 28.11.2022.
//

import UIKit

class JobContractsHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var jobContractsLbl: UILabel!
    @IBOutlet private weak var contractsCountLbl: UILabel!
    
    func setContractsAmountText(count: Int) {
        var text = "Contracts not found"
        if count > 0 {
            if count % 10 == 1 {
                text = "\(count) contract found"
            } else {
                text = "\(count) contracts found"
            }
        }
        contractsCountLbl.text = text
    }

}
