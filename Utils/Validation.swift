//
//  Validation.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 23.11.2022.
//

import Foundation

class Validation {
    
    static func validateEmailAndPassword(_ email: String, _ password: String) -> (isValide: Bool, error: String?) {
        var error: String?
        if email.isEmpty && password.isEmpty {
            error = "Enter Email and Password!"
        } else {
            if email.isEmpty {
                error = "Enter Email!"
            }
            if password.isEmpty {
                error = "Enter Password!"
            } else {
                if !email.isValidEmail {
                    error = "Invalide Email!"
                }
                if password.count < 4 {
                    error = "Password should have at least 4 characters!"
                } else if email.isValidEmail && password.count >= 4 {
                    error = nil
                    return (true, error)
                }
            }
        }
        return (false, error)
    }
    
}
