//
//  ContractsViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import UIKit

class ContractsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: ContractsPresenter!
    
    private let authService = appContext.authentication
    private let child = SpinnerViewController()
    
    private var contracts = [ContractJobModel]()
    private var contractsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter == nil {
            presenter = ContractsPresenter(view: self, service: appContext.mainService)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ContractJobTableViewCell", bundle: nil), forCellReuseIdentifier: "ContractJobCell")
        tableView.register(UINib(nibName: "ContractsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ContractsHeaderView")
        
        presenter.getContracts()
    }

    @IBAction
    private func signOutClick(_ sender: Any) {
        self.createSpinnerView(child)
        presenter.tapSignOutBtn()
    }
    
}

extension ContractsViewController: ContractsProtocol {
    
    func getContractsAmount(count: Int) {
        contractsCount = count
    }
    
    
    func presentResult(_ result: [ContractJobModel]) {
       contracts = result
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func signOut() {
        authService.logout { [weak self] res in
            switch res {
            case .success:
                DispatchQueue.main.async {
                    if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        scene.openTheDesiredController(isAuthorized: false, result: nil)
                        scene.saveData(model: nil, isUpdate: false)
                    }
                    if let self {
                        self.removeSpinnerView(self.child)
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
                if let self {
                    self.removeSpinnerView(self.child)
                }
            }
        }
        
    }
    
}

extension ContractsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContractsHeaderView") as? ContractsHeaderView else {
            return nil
        }
        headerView.setContractsAmountText(count: contractsCount)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
}
