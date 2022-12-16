//
//  ContractsPresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 30.11.2022.
//

import FirebaseAnalytics
import Foundation

enum ContractsNavigation {
    case goToSignIn
    case goToJobContracts
    case goToPostJob
}

protocol ContractsProtocol: AnyObject {
    func move(to: ContractsNavigation)
    func removeSpinnerView()
}

class ContractsPresenter {
    
    weak var view: ContractsProtocol?
    let service: AuthServiceProtocol
    
    private let analytics = appContext.analytics
    
    init(view: ContractsProtocol, service: AuthServiceProtocol) {
        self.view = view
        self.service = service
    }
    
    func didTapJobContrtacts() {
        analytics.screenJobContractsClicked()
        view?.move(to: .goToJobContracts)
    }
    
    func didTapPostJob() {
        analytics.screenPostJobContractClicked()
        view?.move(to: .goToPostJob)
    }
    
    func didTapSignOut() {
        analytics.screenSignOutClicked()
        service.logout { [weak self] res in
            switch res {
            case .success:
                DispatchQueue.main.async {
                    self?.view?.move(to: .goToSignIn)
                    self?.view?.removeSpinnerView()
                }
            case let .failure(error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.view?.removeSpinnerView()
                }
            }
        }
    }
    
}
