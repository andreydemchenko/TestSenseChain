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
    private let child = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AuthPresenter(view: self, authService: appContext.authentication)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        passwordTxtField.enablePasswordToggle()
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction
    private func signInClick(_ sender: Any) {
        self.createSpinnerView(child)
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
    
    var error: String? {
        get {
            return nil
        }
        set {
            DispatchQueue.main.async {
                self.errorLbl.isHidden = false
                self.errorLbl.text = newValue
            }
        }
    }
    
    func moveToMain(result: ResponseAuthModel) {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                scene.openTheDesiredController(isAuthorized: true, result: result)
                scene.saveData(model: result, isUpdate: false)
            }
        }
    }
    
    func removeLoader() {
        self.removeSpinnerView(self.child)
    }
    
}

extension UIViewController {
    
    func createSpinnerView(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        if frame != nil {
            if let frame = frame {
                child.view.frame = frame
            }
        } else {
            child.view.frame = self.view.frame
        }
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeSpinnerView(_ child: UIViewController) {
        DispatchQueue.main.async {
            child.view.removeFromSuperview()
            self.willMove(toParent: nil)
            self.removeFromParent()
        }
    }
    
}
