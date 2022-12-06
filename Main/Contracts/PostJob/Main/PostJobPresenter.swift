//
//  PostJobPresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 30.11.2022.
//

import Foundation

enum PostJobNavigation {
    case next(model: CreateContractJobModel)
    case bussinessType
    case uploadDocuments
    case uploadFiles
}

protocol PostJobProtocol: AnyObject {
    var name: String? { get }
    var businessType: BusinesTypeSelection? { get }
    var description: String? { get }
    var startDateValue: Date? { get }
    var deadlineValue: Date? { get }
    var documentsItems: [UploadedFileModel] { get }
    var filesItems: [UploadedFileModel] { get }
    var hoursValue: Double? { get }
    var priceValue: Double? { get }
    var isBtnNextEnabled: Bool { get set }
    
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
        if checkIfAllFieldAreFilled() {
            if let view, let name = view.name,
               let businessType = view.businessType,
               let description = view.description,
               let startDate = view.startDateValue,
               let deadline = view.deadlineValue,
               let hours = view.hoursValue,
               let price = view.priceValue {
                
                let model = CreateContractJobModel(name: name,
                                                   businessType: businessType,
                                                   description: description,
                                                   startDate: startDate,
                                                   deadline: deadline,
                                                   documents: view.documentsItems,
                                                   files: view.filesItems,
                                                   jobHours: hours,
                                                   price: price)
                
                view.isBtnNextEnabled = true
                view.move(to: .next(model: model))
            }
        }
    }
    
    func checkFields() {
        if checkIfAllFieldAreFilled() {
            view?.isBtnNextEnabled = true
        } else {
            view?.isBtnNextEnabled = false
        }
    }
    
    private func checkIfAllFieldAreFilled() -> Bool {
        if let view, let name = view.name,
           let businessType = view.businessType,
           let description = view.description,
           view.startDateValue != nil,
           view.deadlineValue != nil,
           !view.documentsItems.isEmpty,
           !view.filesItems.isEmpty,
           view.hoursValue != nil,
           view.priceValue != nil,
           !name.isEmpty,
           businessType.rawValue != "Not chosen",
           !description.isEmpty {
            return true
        }
        return false
    }
    
}
