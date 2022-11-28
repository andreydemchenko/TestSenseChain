//
//  ContractJobTableViewCell.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 25.11.2022.
//

import UIKit

class ContractJobTableViewCell: UITableViewCell {

    @IBOutlet private weak var createdAtLbl: UILabel!
    @IBOutlet private weak var balanceLbl: UILabel!
    @IBOutlet private weak var hoursLbl: UILabel!
    @IBOutlet private weak var emploeyrView: UIView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var employerLbl: UILabel!
    @IBOutlet private weak var datesLbl: UILabel!
    @IBOutlet private weak var categoryLbl: UILabel!
    @IBOutlet private weak var descriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setViews(contract: ContractJobModel) {
        nameLbl.text = contract.name
        createdAtLbl.text = contract.created_at?.toDate()?.timeAgoDisplay()
        balanceLbl.text = contract.amount?.removeZerosFromEnd()
        hoursLbl.text = contract.hours?.removeZerosFromEnd()
        employerLbl.text = contract.employer_user_username
        if let startDate = contract.start_date, let endDate = contract.until_end {
            datesLbl.text = "\(startDate) - \(endDate)"
        }
        descriptionLbl.text = contract.description
        categoryLbl.text = contract.field_of_job
    }
    
}
