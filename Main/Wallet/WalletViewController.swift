//
//  WalletViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 24.11.2022.
//

import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet private weak var balance: UILabel!
    @IBOutlet private weak var discount: UILabel!   
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: WalletPresenter!
    private var balances: [SectionWallet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if presenter == nil {
            presenter = WalletPresenter(view: self, service: appContext.mainService)
        }
        presenter.getData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BalanceAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "WalletBalanceCell")
        tableView.register(UINib(nibName: "BottomTableViewCell", bundle: nil), forCellReuseIdentifier: "WalletBottomCell")
    }
    
    @IBAction
    private func reloadBalanceClick(_ sender: Any) {
        presenter.tapReloadBalance()
    }

}

extension WalletViewController: WalletProtocol {
    
    func presentWalletData(model: DataWalletModel, data: [SectionWallet]) {
        balances = data
        balance.text = "\(model.checking_balance ?? 10)"
        discount.text = "\(model.discount ?? 10)%"
        tableView.reloadData()
    }
    
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balances[section].data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return balances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WalletBalanceCell") as? BalanceAccountTableViewCell else {
                fatalError("Could not dequeue cell of type BalanceAccountTableViewCell")
            }
            cell.setViews(model: balances[indexPath.section].data[0])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WalletBottomCell") as? BottomTableViewCell else {
                fatalError("Could not dequeue cell of type BottomTableViewCell")
            }
            cell.setViews(model: balances[indexPath.section].data[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
}
