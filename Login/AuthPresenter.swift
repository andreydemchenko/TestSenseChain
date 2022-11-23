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
    func createSpinnerView()
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
        
        let validate = validateEmailAndPassword(email, password)
        let fieldsAreCorrect = validate.isValide
        self.view.error = validate.error
    
        if fieldsAreCorrect {
            view.createSpinnerView()
            self.authService.login(email, password) { [weak self] result in
                switch result {
                case let .success(model):
                    if model.data != nil {
                        self?.view.moveToContracts(result: model)
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(true, forKey: "isUserLoggedIn")
                        userDefaults.set(model.data?.access_token, forKey: "accessToken")
                        userDefaults.set(model.data?.refresh_token, forKey: "refreshToken")
                    } else if let error = model.error {
                        self?.view.error = error.text
                    }
                case .failure(_):
                    self?.view.error = "An error occurred"
                }
            }
        }
    }
    
}
