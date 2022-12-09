//
//  NetworkManager.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 24.11.2022.
//

import Foundation

class NetworkManager {
    
    func query<T: Codable>(request: URLRequest, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error.localizedDescription)")
                return completion(.failure(error))
            }
            
            if let data {
                do {
                    let responseModel = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(responseModel))
                } catch let error {
                    completion(.failure(error))
                }
            }
            else if let response {
                let error = NSError(domain: "", code: 404, userInfo: [ NSLocalizedDescriptionKey: "Response error: \(response)"])
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
