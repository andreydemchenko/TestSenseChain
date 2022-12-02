//
//  InputPricePresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 02.12.2022.
//

import Foundation
import UIKit

protocol InputPriceProtocol: AnyObject {
    var priceField: String? { get }
    var comission: String? { get set }
    var wholePrice: String { get set }
    func presentWalletData(data: [WalletModelCell])
    func goToPostContract(price: Double?)
}
    
class InputPricePresenter {
    
    weak var view: InputPriceProtocol?
    private let service: MainService
    
    init(view: InputPriceProtocol, service: MainService) {
        self.view = view
        self.service = service
    }
    
    func getWalletData() {
        let accessToken = appContext.keychain.readAccessToken()
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
        let chechBalance = WalletModelCell(image: UIImage(named: "cheking_account_ico")!, text: "Checking account", balance: data.checking_balance)
        let savBalance = WalletModelCell(image: UIImage(named: "saving_account_ico")!, text: "Saving account", balance: data.loan_balance)
        let loanBalance = WalletModelCell(image: UIImage(named: "loan_account_ico")!, text: "Loan account", balance: data.loan_balance)
        let grantedBalance = WalletModelCell(image: UIImage(named: "granted_account_ico")!, text: "Granted loan account", balance: data.granted_loan_balance)
        let frozenBalance = WalletModelCell(image: UIImage(named: "frozen_account_ico")!, text: "Frozen account", balance: data.frozen_balance)
        
        var dataSource = [WalletModelCell]()
        dataSource.append(chechBalance)
        dataSource.append(savBalance)
        dataSource.append(loanBalance)
        dataSource.append(grantedBalance)
        dataSource.append(frozenBalance)
        DispatchQueue.main.async {
            self.view?.presentWalletData(data: dataSource)
        }
    }
    
    func priceChanged() {
        let price = Double(view?.priceField ?? "0")
        
        if let price {
            let comission = price * 0.05
            view?.comission = "\(comission.removeZerosFromEnd()) sc comission"
            view?.wholePrice = "\((price + comission).removeZerosFromEnd()) sc"
        } else {
            view?.comission = nil
            view?.wholePrice = "0 sc"
        }
    }
    
    func didTapPriceView() {
        let price = Double(view?.priceField ?? "0")
        view?.goToPostContract(price: price)
    }
}
