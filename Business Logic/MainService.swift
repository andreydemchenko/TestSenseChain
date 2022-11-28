//
//  MainService.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 24.11.2022.
//

import Foundation

protocol MainServiceProtocol: AnyObject {
    
    func getWalletData(accessToken: String, completion: @escaping (Result<WalletModel, Error>) -> Void)
    func getJobContracts(accessToken: String, completion: @escaping (Result<ResponseContractsModel, Error>) -> Void)
}

class MainService: MainServiceProtocol {
    
    let urlWallet = URL(string: "https://sense-chain.devzz.ru/api/wallet")
    let urlJobContracts = URL(string: "https://sense-chain.devzz.ru/api/user/contracts/job/closed/employee/offset/0")
    let urlError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Invalid url"])
    
    private let manager = NetworkManager()
    
    func getWalletData(accessToken: String, completion: @escaping (Result<WalletModel, Error>) -> Void) {
        guard let requestUrl = urlWallet else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.query(request: request, modelType: WalletModel.self) { res in
            switch res {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getJobContracts(accessToken: String, completion: @escaping (Result<ResponseContractsModel, Error>) -> Void) {
        guard let requestUrl = urlJobContracts else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.query(request: request, modelType: ResponseContractsModel.self) { res in
            switch res {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
