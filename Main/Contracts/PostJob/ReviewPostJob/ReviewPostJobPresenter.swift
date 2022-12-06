//
//  ReviewPostJobPresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 06.12.2022.
//

import Foundation

protocol ReviewPostJobProtocol: AnyObject {
    func createContract(model: CreateContractJobModel)
}

class ReviewPostJobPresenter {
    
    weak var view: ReviewPostJobProtocol?
    private var model: CreateContractJobModel?
    
    init(view: ReviewPostJobProtocol, model: CreateContractJobModel) {
        self.view = view
        self.model = model
    }
}

extension ReviewPostJobViewController: ReviewPostJobProtocol {
    
    func createContract(model: CreateContractJobModel) {
        
    }
    
}
