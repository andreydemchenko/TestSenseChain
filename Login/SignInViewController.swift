//
//  SignInViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet private weak var emailTxtField: UITextField!
    @IBOutlet private weak var passwordTxtField: UITextField!
    @IBOutlet private weak var errorLbl: UILabel!
    @IBOutlet private weak var signInBtn: UIButton!
    
    var presenter: AuthPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AuthPresenter(view: self, authService: appContext.authentication)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction
    private func signInClick(_ sender: Any) {
        presenter.tapSignInBtn()
    }
    
}

extension SignInViewController: AuthViewProtocol {
    
    var email: String {
        return emailTxtField.text ?? ""
    }
    
    var password: String {
        return passwordTxtField.text ?? ""
    }
    
    var error: String {
        get {
            return ""
        }
        set {
            DispatchQueue.main.async {
                self.errorLbl.isHidden = false
                self.errorLbl.text = newValue
            }
        }
    }
    
    func moveToContracts(result: ResponseModel) {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                scene.openTheDesiredController(isAuthorized: true, result: result, isTokenExpired: false)
            }
        }
    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
}
