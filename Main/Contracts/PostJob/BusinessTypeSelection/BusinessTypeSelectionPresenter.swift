//
//  BusinessTypeSelectionPresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 09.12.2022.
//

import Foundation

protocol BusinessTypeSelectionMainProtocol: AnyObject {
    func presentData(types: [String])
    func sendBusinessType(type: String, indexPath: IndexPath)
}

class BusinessTypeSelectionPresenter {
    
    weak var view: BusinessTypeSelectionMainProtocol?
    let service: MainServiceProtocol
    
    init(view: BusinessTypeSelectionMainProtocol, service: MainServiceProtocol) {
        self.view = view
        self.service = service
    }
    
    func getData() {
        let accessToken = appContext.keychain.readAccessToken()
        service.getJobTypes(accessToken: accessToken) { [weak self] res in
            switch res {
            case let .success(response):
                if let data = response.data {
                    self?.view?.presentData(types: data.types)
                }
            case let .failure(error):
                print("An error occurred with getting job types: \(error.localizedDescription)")
            }
        }
    }
    
    func itemClicked(type: String, indexPath: IndexPath) {
        view?.sendBusinessType(type: type, indexPath: indexPath)
    }
    
}
