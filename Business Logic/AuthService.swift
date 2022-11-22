//
//  AuthService.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import Foundation

protocol AuthServiceProtocol {
    func login(_ email: String, _ password: String, completion: @escaping (Result<ResponseModel, Error>) -> Void)
    func logout()
}

class AuthService: AuthServiceProtocol {
    
    let url = URL(string: "https://sense-chain.devzz.ru/api/auth/session")
    
    func login(_ email: String, _ password: String, completion: @escaping (Result<ResponseModel, Error>) -> Void) {
        
        guard let requestUrl = url else { return }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let user = User(device_token: "string", email: email, password: password)
            let jsonData = try JSONEncoder().encode(user)
            
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                guard let data = data else { return }
                
                do {
                    let responseModel = try JSONDecoder().decode(ResponseModel.self, from: data)
                    completion(.success(responseModel))
                } catch let error {
                    completion(.failure(error))
                }
            }
            task.resume()
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func logout() {
        guard let requestUrl = url else { return }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
        }
        task.resume()
    }
    
}
