//
//  AuthService.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import Foundation

protocol AuthServiceProtocol {
    
    func login(_ email: String, _ password: String, completion: @escaping (Result<ResponseModel, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
    func getToken(refreshToken: String, completion: @escaping (Result<String, Error>) -> Void)
    
}

class AuthService: AuthServiceProtocol {
    
    let url = URL(string: "https://sense-chain.devzz.ru/api/auth/session")
    let urlError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Invalid url"])
    
    func login(_ email: String, _ password: String, completion: @escaping (Result<ResponseModel, Error>) -> Void) {
        
        guard let requestUrl = url else { return completion(.failure(urlError)) }
        
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
                    return completion(.failure(error))
                }
                if let data {
                    do {
                        let responseModel = try JSONDecoder().decode(ResponseModel.self, from: data)
                        completion(.success(responseModel))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let requestUrl = url else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return completion(.failure(error))
            }
            completion(.success(()))
        }
        task.resume()
    }
    
    func getToken(refreshToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let requestUrl = url else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(refreshToken)
            
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return completion(.failure(error))
                }
                if let data {
                    do {
                        let responseModel = try JSONDecoder().decode(ResponseModel.self, from: data)
                        let refreshToken = responseModel.data?.refresh_token ?? ""
                        completion(.success(refreshToken))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        } catch let error {
            completion(.failure(error))
        }
        
    }
    
}
