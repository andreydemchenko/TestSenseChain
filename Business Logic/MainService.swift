//
//  MainService.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 24.11.2022.
//

import Alamofire
import Foundation

protocol MainServiceProtocol: AnyObject {
    
    func getWalletData(completion: @escaping (Result<WalletModel>) -> Void)
    func getJobContracts(status: String, role: String, offset: Int, completion: @escaping (Result<GetContractsJobResponse>) -> Void)
    func getJobTypes(completion: @escaping (Result<ContractJobTypeResponse>) -> Void)
    func getCommissionByPrice(amount: String, completion: @escaping (Result<ResponseJobCommission>) -> Void)
    func uploadAttachment(model: AttachmentUploadReq, completion: @escaping (Result<AttachmentUploadResponse>) -> Void)
    func createJobContract(model: CreateContractJobReq, completion: @escaping (Result<CreateContractJobResponse>) -> Void)
    
}

class MainService: MainServiceProtocol {
    
    private let accessToken = appContext.keychain.readAccessToken()
    
    let urlError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Invalid url"])
    
    private let manager = NetworkManager()
    
    private func applyRequest(request: inout URLRequest) {
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    func getWalletData(completion: @escaping (Result<WalletModel>) -> Void) {
        let urlWallet = URL(string: "https://sense-chain.devzz.ru/api/wallet")
        guard let requestUrl = urlWallet else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        applyRequest(request: &request)
        
        manager.query(request: request, modelType: WalletModel.self) { res in
            switch res {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getJobContracts(status: String, role: String, offset: Int, completion: @escaping (Result<GetContractsJobResponse>) -> Void) {
        let urlJobContracts = URL(string: "https://sense-chain.devzz.ru/api/user/contracts/job/\(status)/\(role)/offset/\(offset)")
        guard let requestUrl = urlJobContracts else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        applyRequest(request: &request)
        
        manager.query(request: request, modelType: GetContractsJobResponse.self) { res in
            switch res {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getJobTypes(completion: @escaping (Result<ContractJobTypeResponse>) -> Void) {
        let urlJobTypes = URL(string: "https://sense-chain.devzz.ru/api/contract/job/types")
        
        guard let requestUrl = urlJobTypes else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        applyRequest(request: &request)
        
        manager.query(request: request, modelType: ContractJobTypeResponse.self) { res in
            switch res {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getCommissionByPrice(amount: String, completion: @escaping (Result<ResponseJobCommission>) -> Void) {
        
        let urlJobCommission = "https://sense-chain.devzz.ru/api/contract/job/commission"
        
        var components = URLComponents(string: urlJobCommission)
        guard var components = components else { return completion(.failure(urlError)) }
          
        components.queryItems = [
            URLQueryItem(name: "amount", value: amount)
        ]
        
        guard let requestUrl = components.url else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        applyRequest(request: &request)
        
        manager.query(request: request, modelType: ResponseJobCommission.self) { res in
            switch res {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadAttachment(model: AttachmentUploadReq, completion: @escaping (Result<AttachmentUploadResponse>) -> Void) {
        
        let urlAttachment = URL(string: "https://sense-chain.devzz.ru/api/attachment")
        
        guard let url = urlAttachment else { return completion(.failure(urlError)) }
        
        let headers: Alamofire.HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken)",
            "Accept" : "application/json",
            "Content-Type" : "multipart/form-data"
        ]
        let parameters = [
            "name" : "\(model.name)",
            "section" : "\(model.section)"
        ]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                multipartFormData.append(model.file, withName: "file", fileName: model.name, mimeType: model.mimeType)
            },
            usingThreshold: .max,
            to: url,
            method: .post,
            headers: headers,
            encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case let .success(upload, _, _):
                    upload.responseJSON { response in
                        if response.result.isSuccess, let data = response.data {
                            do {
                                let attachmentResponse = try JSONDecoder().decode(AttachmentUploadResponse.self, from: data)
                                completion(.success(attachmentResponse))
                            } catch {
                                print("Decoding error occurred")
                            }
                        } else if response.result.isFailure, let error = response.result.error {
                            completion(.failure(error))
                        }
                    }
                    upload.uploadProgress(closure: {
                        progress in
                        print(progress.fractionCompleted)
                    })
                case let .failure(encodingError):
                    completion(.failure(encodingError))
                }
            })
        
    }
    
    func createJobContract(model: CreateContractJobReq, completion: @escaping (Result<CreateContractJobResponse>) -> Void) {
        let urlPostJobContract = URL(string: "https://sense-chain.devzz.ru/api/contract/job")
        guard let requestUrl = urlPostJobContract else { return completion(.failure(urlError)) }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        applyRequest(request: &request)
        
        do {
            let jsonData = try JSONEncoder().encode(model)
            request.httpBody = jsonData
            
            manager.query(request: request, modelType: CreateContractJobResponse.self) { res in
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
    
}
