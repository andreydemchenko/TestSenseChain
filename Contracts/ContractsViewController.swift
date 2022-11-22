//
//  ContractsViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import UIKit

class ContractsViewController: UIViewController {
    
    @IBOutlet weak var resultTxtView: UITextView!
    
    var presenter: ContractsPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.showResult()
    }

    @IBAction
    private func signOutClick(_ sender: Any) {
        presenter.tapSignOutBtn()
    }
    
}

extension ContractsViewController: ContractsProtocol {
    
    func presentResult(_ result: ResponseModel?) {
        if let result = result?.data {
            resultTxtView.text = "access_token: \(result.access_token)\nrefresh_token: \(result.refresh_token)\nrole_id: \(result.role_id)"
        }
    }
    
    func signOut() {
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            scene.openTheDesiredController(isAuthorized: false, result: nil)
            resultTxtView.text = nil
        }
    }
    
}
