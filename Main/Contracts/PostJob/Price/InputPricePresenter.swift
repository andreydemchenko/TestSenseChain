//
//  InputPricePresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 02.12.2022.
//

import Foundation
import UIKit

protocol InputPriceProtocol: AnyObject {
    var priceField: String? { get set }
    var comissionField: String? { get set }
    var wholePrice: String { get set }
    var errorField: String? { get set }
    var balanceValue: Double { get }
    func presentWalletData(data: [WalletModelCell])
    func goToPostContract(price: Double?, comission: Double?)
}
    
class InputPricePresenter {
    
    weak var view: InputPriceProtocol?
    private let service: MainService
    private let accessToken = appContext.keychain.readAccessToken()
    
    private var searchTimer: Timer?
    
    init(view: InputPriceProtocol, service: MainService) {
        self.view = view
        self.service = service
    }
    
    func getWalletData() {
        service.getWalletData(accessToken: accessToken) { [weak self] res in
            switch res {
            case let .success(model):
                if let data = model.data {
                    self?.prepareData(data: data)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func prepareData(data: DataWalletModel) {
        let checkingBalance = WalletModelCell(image: UIImage(named: "cheking_account_ico")!, text: "Checking account", balance: data.checking_balance)
        let loanBalance = WalletModelCell(image: UIImage(named: "loan_account_ico")!, text: "Loan account", balance: data.loan_balance)
        
        var dataSource = [WalletModelCell]()
        dataSource.append(checkingBalance)
        dataSource.append(loanBalance)
        DispatchQueue.main.async {
            self.view?.presentWalletData(data: dataSource)
        }
    }
    
    func priceChanged() {
        if let priceField = view?.priceField {
            if priceField == ".0" {
                view?.priceField = nil
                view?.errorField = nil
                view?.comissionField = nil
                view?.wholePrice = "0"
            } else {
                if !priceField.contains(".0"), !priceField.contains(".") {
                    view?.priceField?.append(".0")
                }
                if priceField.isDoubleNumber {
                    let price = (view?.priceField ?? "0").toDouble
                    if let balance = view?.balanceValue, price <= balance {
                        view?.errorField = nil
                        searchTimer?.invalidate()
                        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                            self.getComission()
                        })
                    }
                    else {
                        view?.errorField = "The entered price exceeds the balance!"
                    }
                } else {
                    view?.errorField = "Incorrect price!"
                }
            }
        } else {
            view?.errorField = nil
            view?.comissionField = nil
            view?.wholePrice = "0"
        }
    }
    
    private func getComission() {
        let price = (view?.priceField ?? "0").toDouble
        service.getComissionByPrice(accessToken: accessToken, amount: price) { [weak self] res in
            switch res {
            case let .success(model):
                if let comission = model.data?.comission {
                    DispatchQueue.main.async {
                        self?.view?.comissionField = "\(comission)"
                        self?.view?.wholePrice = "\(price + comission)"
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapPriceView() {
        if let priceField = view?.priceField, let comissionField = view?.comissionField, view?.errorField == nil {
            let strPrice = priceField.components(separatedBy: " ").first ?? "0"
            let strComission = comissionField.components(separatedBy: " ").first ?? "0"
            let price = strPrice.toDouble
            let comission = strComission.toDouble
            print("field == \(priceField) price == \(price)")
            view?.goToPostContract(price: price, comission: comission)
        }
    }
}
