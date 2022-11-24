//
//  ContractsPresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import Foundation

protocol ContractsProtocol: AnyObject {
    func presentResult(_ result: ResponseModel?)
    func signOut()
}

class ContractsPresenter {
    
    weak var view: ContractsProtocol?
    var result: ResponseModel?
    
    init(view: ContractsProtocol, result: ResponseModel?) {
        self.view = view
        self.result = result
    }
    
    func showResult() {
        view?.presentResult(result)
    }
    
    func tapSignOutBtn() {
        view?.signOut()
    }
    
}
