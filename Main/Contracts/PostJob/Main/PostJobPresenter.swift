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
    var errorName: String? { get set }
    var errorType: String? { get set }
    var errorDescription: String? { get set }
    var errorTime: String? { get set }
    var errorPrice: String? { get set }
    
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
        checkName()
        checkType()
        checkDescription()
        checkTime()
        checkPrice()
        if checkIfAllFieldAreFilled() {
            if hours == nil {
                hours = 0
            }
            if minutes == nil {
                minutes = 0
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
    
    func checkName() {
        if view?.name == nil {
            view?.errorName = "Enter name"
        } else {
            if let name = view?.name {
                if name.isEmpty {
                    view?.errorName = "Enter name"
                } else if !name.isValidContractName {
                    view?.errorName = "Incorrect name"
                } else {
                    view?.errorName = nil
                }
            }
        }
    }
    
    func checkType() {
        if view?.businessTypeValue == nil {
            view?.errorType = "Chose type"
        } else {
            view?.errorType = nil
        }
    }
    
    func checkDescription() {
        if view?.descriptionValue == nil {
            view?.errorDescription = "Enter description"
        } else {
            if let desc = view?.descriptionValue {
                if desc.isEmpty {
                    view?.errorDescription = "Enter description"
                } else if !desc.isValidContractDescription {
                    view?.errorDescription = "Incorrect description"
                } else {
                    view?.errorDescription = nil
                }
            }
        }
    }
    
    func checkTime() {
        if hours == nil, minutes == nil {
            view?.errorTime = "Enter time"
        } else {
            view?.errorTime = nil
        }
    }
    
    func checkPrice() {
        if view?.priceValue == nil {
            view?.errorPrice = "Enter price"
        } else {
            if let price = view?.priceValue {
                if price == 0 {
                    view?.errorPrice = "Enter price"
                } else {
                    view?.errorPrice = nil
                }
            }
        }
    }
    
    private func checkIfAllFieldAreFilled() -> Bool {
        if let view {
            if view.businessTypeValue != nil,
               view.startDateValue != nil,
               view.deadlineValue != nil,
               hours != nil || minutes != nil,
               view.priceValue != nil,
               view.errorName == nil,
               view.errorType == nil,
               view.errorDescription == nil,
               view.errorTime == nil,
               view.errorPrice == nil {
                return true
            }
        }
        return false
    }
    
}
