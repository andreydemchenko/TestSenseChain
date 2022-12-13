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
        let status = UserContractStatus.pending.rawValue
        let role = UserContractRole.employer.rawValue
        service.getJobContracts(status: status, role: role, offset: 0) { [weak self] res in
            switch res {
            case let .success(data):
                self?.view?.getContractsAmount(count: data.data?.total ?? 0)
                if let data = data.data {
                    self?.view?.presentResult(data.contracts)
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
