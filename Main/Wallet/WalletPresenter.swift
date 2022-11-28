//
//  WalletPresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 24.11.2022.
//

import Foundation
import UIKit

protocol WalletProtocol: AnyObject {
    func presentWalletData(model: DataWalletModel, data: [SectionWallet])
}

class WalletPresenter {
    
    weak var view: WalletProtocol?
    let service: MainServiceProtocol
    
    private var dataSource = [SectionWallet]()
    private var data: DataWalletModel?
    
    init(view: WalletProtocol, service: MainServiceProtocol) {
        self.view = view
        self.service = service
    }
    
    func getData() {
        let group = DispatchGroup()
        group.enter()
        let accessToken = appContext.keychain.readAccessToken()
        service.getWalletData(accessToken: accessToken) { [weak self] res in
            switch res {
            case let .success(model):
                if let data = model.data {
                    self?.data = data
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        group.notify(queue: .global(qos: .default)) { [weak self] in
            self?.prepareData()
        }
    }
    
    private func prepareData() {
        if let data {
            let chechBalance = SectionWallet(data: [WalletModelCell(image: UIImage(named: "cheking_account_ico")!, text: "Checking account", balance: data.checking_balance)])
            let savBalance = SectionWallet(data: [WalletModelCell(image: UIImage(named: "saving_account_ico")!, text: "Saving account", balance: data.loan_balance)])
            let loanBalance = SectionWallet(data: [WalletModelCell(image: UIImage(named: "loan_account_ico")!, text: "Loan account", balance: data.loan_balance)])
            let grantedBalance = SectionWallet(data: [WalletModelCell(image: UIImage(named: "granted_account_ico")!, text: "Granted loan account", balance: data.granted_loan_balance)])
            let frozenBalance = SectionWallet(data: [WalletModelCell(image: UIImage(named: "frozen_account_ico")!, text: "Frozen account", balance: data.frozen_balance)])
            let transHistory = WalletModelCell(image: UIImage(named: "history_ico")!, text: "Transaction history")
            let discProgram = WalletModelCell(image: UIImage(named: "discount_ico")!, text: "Discount program")
            let investments = WalletModelCell(image: UIImage(named: "investments_ico")!, text: "Investments")
            let otherSect = SectionWallet(data: [transHistory, discProgram, investments])
            dataSource.append(chechBalance)
            dataSource.append(savBalance)
            dataSource.append(loanBalance)
            dataSource.append(grantedBalance)
            dataSource.append(frozenBalance)
            dataSource.append(otherSect)
            DispatchQueue.main.async {
                self.view?.presentWalletData(model: data, data: self.dataSource)
            }
        }
        
    }
    
    func tapReloadBalance() {
        getData()
    }
    
}
