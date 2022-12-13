//
//  ContractCreatedViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 09.12.2022.
//

import UIKit

class ContractCreatedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction
    private func pendingContractsBtnClicked(_ sender: Any) {
 
    }
    
    @IBAction
    private func backToContractsBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Contracts", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ContractsVC") as? ContractsViewController {
            vc.presenter = ContractsPresenter(view: vc, service: appContext.authentication)
            vc.hidesBottomBarWhenPushed = true
            vc.modalPresentationStyle = .fullScreen
            navigationController?.popToRootViewController(animated: false)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
