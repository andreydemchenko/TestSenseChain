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
    var commissionField: String? { get set }
    var wholePrice: String { get set }
    var errorField: String? { get set }
    var balanceValue: Double { get }
    func presentWalletData(data: [WalletModelCell])
    func goToPostContract(price: Double?, commission: Double?)
}
    
class InputPricePresenter {
    
    weak var view: InputPriceProtocol?
    private let service: MainService
    
    private var searchTimer: Timer?
    
    init(view: InputPriceProtocol, service: MainService) {
        self.view = view
        self.service = service
    }
    
    func getWalletData() {
        service.getWalletData() { [weak self] res in
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
    
    private func prepareData(data: WalletBalanceRes) {
        let checkingBalance = WalletModelCell(image: UIImage(named: "cheking_account_ico")!, text: "Checking account", balance: data.checking_balance?.toDouble)
        let loanBalance = WalletModelCell(image: UIImage(named: "loan_account_ico")!, text: "Loan account", balance: data.loan_balance?.toDouble)
        
        var dataSource = [WalletModelCell]()
        dataSource.append(checkingBalance)
        dataSource.append(loanBalance)
        DispatchQueue.main.async {
            self.view?.presentWalletData(data: dataSource)
        }
    }
    
    func checkPrice() {
        if let priceField = view?.priceField, priceField.first != "0", !priceField.isEmpty {
            if priceField == ".0" {
                view?.priceField = nil
                view?.errorField = nil
                view?.commissionField = nil
                view?.wholePrice = "0"
            } else {
                if priceField.isDoubleNumber {
                    if !priceField.contains(".0"), !priceField.contains(".") {
                        view?.priceField?.append(".0")
                    }
                    let price = (view?.priceField ?? "0").toDouble
                    if let balance = view?.balanceValue, price <= balance {
                        if price >= 10 {
                            priceChanged()
                        } else {
                            view?.errorField = "Min price is 10 sc"
                            view?.commissionField = "0"
                            view?.wholePrice = "0"
                        }
                    } else {
                        view?.errorField = "The entered price exceeds the balance!"
                        view?.commissionField = "0"
                        view?.wholePrice = "0"
                    }
                } else {
                    view?.errorField = "Incorrect price!"
                    view?.commissionField = "0"
                    view?.wholePrice = "0"
                }
            }
        } else {
            view?.errorField = "Enter price"
            view?.commissionField = "0"
            view?.wholePrice = "0"
        }
    }
    
    func priceChanged() {
        if let priceField = view?.priceField, priceField.isDoubleNumber {
            let price = (view?.priceField ?? "0").toDouble
            if let balance = view?.balanceValue, price <= balance {
                if price >= 10 {
                    view?.errorField = nil
                    searchTimer?.invalidate()
                    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                        self.getComission()
                    })
                }
            }
        }
    }

    private func getComission() {
        let price = (view?.priceField ?? "0")
        service.getCommissionByPrice(amount: price) { [weak self] res in
            switch res {
            case let .success(model):
                if let commission = model.data?.commission {
                    DispatchQueue.main.async {
                        self?.view?.commissionField = commission
                        self?.view?.wholePrice = "\(price.toDouble + commission.toDouble)"
                    }
                } else if let error = model.error {
                    print("An error occurred with getting commission: \(error.text)")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapPriceView() {
        if let priceField = view?.priceField, let commissionField = view?.commissionField, view?.errorField == nil {
            let strPrice = priceField.components(separatedBy: " ").first ?? "0"
            let strCommission = commissionField.components(separatedBy: " ").first ?? "0"
            let price = strPrice.toDouble
            let commission = strCommission.toDouble
            view?.goToPostContract(price: price, commission: commission)
        }
    }
}
