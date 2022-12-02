//
//  PostJobPresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 30.11.2022.
//

import Foundation

enum PostJobNavigation {
    case next
    case bussinessType
    case uploadDocuments
    case uploadFiles
}

protocol PostJobProtocol: AnyObject {
    func move(to: PostJobNavigation)
}

class PostJobPresenter {
    
    weak var view: PostJobProtocol?
    let service: MainServiceProtocol
    
    init(view: PostJobProtocol, service: MainServiceProtocol) {
        self.view = view
        self.service = service
    }
    
    func didTapNextBtn() {
        view?.move(to: .next)
    }
}
