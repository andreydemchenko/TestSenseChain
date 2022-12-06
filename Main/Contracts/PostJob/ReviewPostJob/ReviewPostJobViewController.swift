//
//  ReviewPostJobViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 06.12.2022.
//

import UIKit

class ReviewPostJobViewController: UIViewController {

    @IBOutlet private weak var mainStackView: UIStackView!
    
    var presenter: ReviewPostJobPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter == nil {
            presenter = ReviewPostJobPresenter(view: self, model: nil)
        }
        
        configureView()
    }
    
    private func configureView() {
        title = "Create a contrat"
    }

    @IBAction
    private func createContractBtnClicked(_ sender: Any) {
        
    }
}
