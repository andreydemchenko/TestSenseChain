//
//  AuthService.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import Foundation

protocol AuthServiceProtocol {
    
    func login(_ email: String, _ password: String, completion: @escaping (Result<ResponseAuthModel, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
    func refreshToken(refreshToken: String, completion: @escaping (Result<ResponseAuthModel, Error>) -> Void)
    func testQuery(accessToken: String, completion: @escaping (Result<GetTemplatesModel, Error>) -> Void)
    
}

class AuthService: AuthServiceProtocol {
    
    private let manager = NetworkManager()
    
    let urlSession = URL(string: "https://sense-chain.devzz.ru/api/auth/session")
    let urlTemplates = URL(string: "https://sense-chain.devzz.ru/api/contract/job/templates")
    let urlError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Invalid url"])
    
    func login(_ email: String, _ password: String, completion: @escaping (Result<ResponseAuthModel, Error>) -> Void) {
        
        guard let requestUrl = urlSession else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let user = User(device_token: "string", email: email, password: password)
            let jsonData = try JSONEncoder().encode(user)
            
            request.httpBody = jsonData
            
            manager.query(request: request, modelType: ResponseAuthModel.self) { res in
                switch res {
                case let .success(model):
                    completion(.success(model))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let requestUrl = urlSession else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.query(request: request, modelType: NoReply.self) { res in
            switch res {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func refreshToken(refreshToken: String, completion: @escaping (Result<ResponseAuthModel, Error>) -> Void) {
        
        guard let requestUrl = urlSession else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        manager.query(request: request, modelType: ResponseAuthModel.self) { res in
            switch res {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func testQuery(accessToken: String, completion: @escaping (Result<GetTemplatesModel, Error>) -> Void) {
        guard let requestUrl = urlTemplates else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.query(request: request, modelType: GetTemplatesModel.self) { res in
            switch res {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
