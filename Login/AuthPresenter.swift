//
//  SignInPresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import Foundation

protocol AuthViewProtocol: AnyObject {
    var email: String { get }
    var password: String { get }
    var error: String { get set }
    
    func moveToContracts(result: ResponseModel)
}

class AuthPresenter {
    
    var view: AuthViewProtocol
    let authService: AuthServiceProtocol
    
    init(view: AuthViewProtocol, authService: AuthServiceProtocol) {
        self.view = view
        self.authService = authService
    }
    
    func tapSignInBtn() {
        let email = view.email
        let password = view.password
        
        self.view.error = ""
        
        let fieldsAreCorrect = validateEmailAndPassword(email, password)
    
        if fieldsAreCorrect {
            self.authService.login(email, password) { [weak self] result in
                switch result {
                case let .success(model):
                    if model.data != nil {
                        self?.view.moveToContracts(result: model)
                    } else if let error = model.error {
                        self?.view.error = "code: \(error.code), text: \(error.text)"
                    }
                case let .failure(error):
                    self?.view.error = error.localizedDescription
                }
            }
        }
    }
    
    private func validateEmailAndPassword(_ email: String, _ password: String) -> Bool {
        if email.isEmpty && password.isEmpty {
            self.view.error = "Enter Email and Password!"
        } else {
            if email.isEmpty {
                self.view.error = "Enter Email!"
            }
            if password.isEmpty {
                self.view.error = "Enter Password!"
            } else {
                if !email.isValidEmail {
                    self.view.error = "Invalide Email!"
                }
                if password.count < 4 {
                    self.view.error = "Password should have at least 4 characters!"
                } else if email.isValidEmail && password.count >= 4 {
                    self.view.error = ""
                    return true
                }
            }
        }
        return false
    }
    
}
