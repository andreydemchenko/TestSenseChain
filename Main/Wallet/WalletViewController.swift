//
//  WalletViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 24.11.2022.
//

import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: WalletPresenter!
    private var balances: [SectionWallet] = []
    private var dataWallet: DataWalletModel?
    
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
        tableView.register(UINib(nibName: "WalletHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "WalletHeaderView")

    }

}

extension WalletViewController: WalletProtocol {
    
    func presentWalletData(model: DataWalletModel, data: [SectionWallet]) {
        balances = data
        dataWallet = model
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WalletHeaderView") as! WalletHeaderView
            headerView.setViews(balance: dataWallet?.checking_balance, discount: dataWallet?.discount)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 170
        }
        return 0
    }
    
}
