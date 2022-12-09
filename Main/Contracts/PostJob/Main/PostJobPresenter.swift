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
    var businessTypeValue: String? { get }
    var descriptionValue: String? { get }
    var startDateValue: Date? { get }
    var deadlineValue: Date? { get }
    var documentsItems: [UploadedFileModel] { get }
    var filesItems: [UploadedFileModel] { get }
    var accountTypeIndex: Int? { get }
    var priceValue: Double? { get }
    var comissionValue: Double? { get }
    var isBtnNextEnabled: Bool { get set }
    
    func move(to: PostJobNavigation)
}

class PostJobPresenter {
    
    weak var view: PostJobProtocol?
    let service: MainServiceProtocol
    
    private var hours: Int?
    private var minutes: Int?
    
    init(view: PostJobProtocol, service: MainServiceProtocol) {
        self.view = view
        self.service = service
    }
    
    func didTapNextBtn() {
        if checkIfAllFieldAreFilled() {
            if hours == nil {
                hours = 0
            }
            if minutes == nil {
                minutes = 0
            }
            if  let accountTypeIndex = view?.accountTypeIndex {
                print("type == \(WalletType.allCases[accountTypeIndex].rawValue)")
            }
            if let view, let name = view.name,
               let businessType = view.businessTypeValue,
               let description = view.descriptionValue,
               let startDate = view.startDateValue,
               let deadline = view.deadlineValue,
               let hours, let minutes,
               let accountTypeIndex = view.accountTypeIndex,
               let price = view.priceValue,
               let comission = view.comissionValue {
                let accountType = WalletType.allCases[accountTypeIndex].rawValue
                let model = CreateContractJobModel(name: name,
                                                   businessType: businessType,
                                                   description: description,
                                                   startDate: startDate,
                                                   deadline: deadline,
                                                   documents: view.documentsItems,
                                                   files: view.filesItems,
                                                   hours: hours,
                                                   minutes: minutes,
                                                   accountType: accountType,
                                                   price: price,
                                                   comission: comission)
                view.isBtnNextEnabled = true
                view.move(to: .next(model: model))
            }
        }
    }
    
    func setTime(hours: Int, minutes: Int) {
        self.hours = hours
        self.minutes = minutes
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
           view.businessTypeValue != nil,
           let description = view.descriptionValue,
           view.startDateValue != nil,
           view.deadlineValue != nil,
           hours != nil || minutes != nil,
           view.priceValue != nil,
           !name.isEmpty,
           !description.isEmpty {
            return true
        }
        return false
    }
    
}
