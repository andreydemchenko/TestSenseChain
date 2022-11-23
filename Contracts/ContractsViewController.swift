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
    
    private let authService = appContext.authentication

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.showResult()
    }

    @IBAction
    private func signOutClick(_ sender: Any) {
        createSpinnerView()
        presenter.tapSignOutBtn()
    }
    
    private func createSpinnerView() {
        let child = SpinnerViewController()

        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
}

extension ContractsViewController: ContractsProtocol {
    
    func presentResult(_ result: ResponseModel?) {
        if let result = result?.data {
            resultTxtView.text = "access_token: \(result.access_token)\nrefresh_token: \(result.refresh_token)\nrole_id: \(result.role_id)"
        }
    }
    
    func signOut() {
        authService.logout { [weak self] res in
            switch res {
            case .success:
                DispatchQueue.main.async {
                    if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        scene.openTheDesiredController(isAuthorized: false, result: nil)
                        self?.resultTxtView.text = nil
                    }
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self?.resultTxtView.text = error.localizedDescription
                }
            }
        }
        
    }
    
}
