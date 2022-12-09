//
//  ContractsViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import UIKit

class JobContractsViewController: UIViewController {
    
    @IBOutlet private weak var contractsTableView: UITableView!
    var presenter: JobContractsPresenter!
    
    private let authService = appContext.authentication
    private let child = SpinnerViewController()
    
    private var contracts = [GetContractsJobItem]()
    private var contractsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "JobContracts"
        
        if presenter == nil {
            presenter = JobContractsPresenter(view: self, service: appContext.mainService)
        }
        
        contractsTableView.delegate = self
        contractsTableView.dataSource = self
        contractsTableView.register(UINib(nibName: "ContractJobTableViewCell", bundle: nil), forCellReuseIdentifier: "ContractJobCell")
        contractsTableView.register(UINib(nibName: "JobContractsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "JobContractsHeaderView")
        
        presenter.getContracts()
    }
    
}

extension JobContractsViewController: JobContractsProtocol {
    
    func getContractsAmount(count: Int) {
        contractsCount = count
    }
    
    
    func presentResult(_ result: [GetContractsJobItem]) {
        contracts = result
        DispatchQueue.main.async {
            self.contractsTableView.reloadData()
        }
    }
    
}

extension JobContractsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contracts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContractJobCell") as? ContractJobTableViewCell else {
            fatalError("Could not dequeue cell of type BalanceAccountTableViewCell")
        }
        cell.setViews(contract: contracts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JobContractsHeaderView") as? JobContractsHeaderView else {
            return nil
        }
        headerView.setContractsAmountText(count: contractsCount)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
}
