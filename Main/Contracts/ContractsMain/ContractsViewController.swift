//
//  ContractsViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 30.11.2022.
//

import UIKit

class ContractsViewController: UIViewController {
    
    var presenter: ContractsPresenter!
    private let child = SpinnerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if presenter == nil {
            presenter = ContractsPresenter(view: self, service: appContext.authentication)
        }
    }
    
    @IBAction
    private func findJobContractsBtnClick(_ sender: Any) {
        presenter.didTapJobContrtacts()
    }
    
    @IBAction
    private func postJobBtnClick(_ sender: Any) {
        presenter.didTapPostJob()
    }
    
    @IBAction
    private func signOutClick(_ sender: Any) {
        self.createSpinnerView(child)
        presenter.didTapSignOut()
    }
    
}

extension ContractsViewController: ContractsProtocol {
    
    func removeSpinnerView() {
        self.removeSpinnerView(self.child)
    }
    
    func move(to: ContractsNavigation) {
        switch to {
        case .goToSignIn:
            if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                scene.openTheDesiredController(isAuthorized: false, result: nil)
                scene.saveData(model: nil, isUpdate: false)
            }
        case .goToJobContracts:
            let storyboard = UIStoryboard(name: "JobContracts", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "JobContractsVC") as? JobContractsViewController {
                vc.presenter = JobContractsPresenter(view: vc, service: appContext.mainService)
                vc.hidesBottomBarWhenPushed = true
                vc.modalPresentationStyle = .fullScreen
                navigationController?.pushViewController(vc, animated: true)
            }
        case .goToPostJob:
            let storyboard = UIStoryboard(name: "PostJob", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "PostJobVC") as? PostJobViewController {
                vc.presenter = PostJobPresenter(view: vc, service: appContext.mainService)
                vc.hidesBottomBarWhenPushed = true
                vc.modalPresentationStyle = .fullScreen
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
