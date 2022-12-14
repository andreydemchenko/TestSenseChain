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
    private var dataWallet: WalletBalanceRes?
    
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
        
        let titleNameLbl = UILabel()
        titleNameLbl.text = "Wallet"
        titleNameLbl.textColor = .white
        titleNameLbl.font = .boldSystemFont(ofSize: 20)
        let titleWalletLbl = UILabel()
        titleWalletLbl.text = "6a55c567624683e...64d9a16b1b4a61c94e"
        titleWalletLbl.textColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 245.0/255.0, alpha: 0.72)
        titleWalletLbl.font = .systemFont(ofSize: 12)
        
        let vStack = UIStackView(arrangedSubviews: [titleNameLbl, titleWalletLbl])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 8
        vStack.sizeToFit()
        
        navigationItem.titleView = vStack
    }

}

extension WalletViewController: WalletProtocol {
    
    func presentWalletData(model: WalletBalanceRes, data: [SectionWallet]) {
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
            let row = indexPath.row
            let isLast = indexPath.section + row - 1 == balances.count
            cell.setViews(model: balances[indexPath.section].data[row], isLast: isLast)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WalletHeaderView") as? WalletHeaderView else {
                return nil
            }
            headerView.setViews(balance: dataWallet?.checking_balance?.toDouble, discount: dataWallet?.discount?.toDouble)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 140
        }
        return 0
    }
    
}
