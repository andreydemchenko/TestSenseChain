//
//  JobContractsPresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import Foundation

protocol JobContractsProtocol: AnyObject {
    func presentResult(_ result: [GetContractsJobItem])
    func getContractsAmount(count: Int)
}

class JobContractsPresenter {
    
    weak var view: JobContractsProtocol?
    let service: MainServiceProtocol
    
    init(view: JobContractsProtocol, service: MainServiceProtocol) {
        self.view = view
        self.service = service
    }
    
    func getContracts() {
        let accessToken = appContext.keychain.readAccessToken()
        service.getJobContracts(accessToken: accessToken) { [weak self] res in
            switch res {
            case let .success(data):
                self?.view?.getContractsAmount(count: data.data?.total ?? 0)
                if let contracts = data.data?.contracts {
                    self?.view?.presentResult(contracts)
                } else {
                    if let error = data.error {
                        print("Error: \(error.text)")
                    } else {
                        print("Something went wrong!")
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
}
