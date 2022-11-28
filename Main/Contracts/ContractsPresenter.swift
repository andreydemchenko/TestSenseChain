//
//  ContractsPresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import Foundation

protocol ContractsProtocol: AnyObject {
    func presentResult(_ result: [ContractJobModel])
    func getContractsAmount(count: Int)
    func signOut()
}

class ContractsPresenter {
    
    weak var view: ContractsProtocol?
    let service: MainServiceProtocol
    
    init(view: ContractsProtocol, service: MainServiceProtocol) {
        self.view = view
        self.service = service
    }
    
    func getContracts() {
        let accessToken = appContext.keychain.readAccessToken()
        print("accesstoken = \(accessToken)")
        service.getJobContracts(accessToken: accessToken) { [weak self] res in
            switch res {
            case let .success(data):
                self?.view?.getContractsAmount(count: data.data?.total ?? 0)
                if let contracts = data.data?.contracts {
                    self?.view?.presentResult(contracts)
                } else {
                    print("Something went wrong!")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tapSignOutBtn() {
        view?.signOut()
    }
    
}
