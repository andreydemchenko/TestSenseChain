//
//  BusinessTypeSelectionViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 01.12.2022.
//

import UIKit

protocol BusinessTypeSelectionProtocol: AnyObject {
    func itemClick(type: String, indexPath: IndexPath)
}

class BusinessTypeSelectionViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: BusinessTypeSelectionPresenter?
    var selectedIndex: IndexPath?
    
    weak var selectionDelegate: BusinessTypeSelectionProtocol?
    
    private var dataSource: [String] = []
    
    private var filteredData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Business Type"
        
        if presenter == nil {
            presenter = BusinessTypeSelectionPresenter(view: self, service: appContext.mainService)
        }
        presenter?.getData()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BusinessTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "BusinessTypeCell")
        searchBar.delegate = self
        filteredData = dataSource
    }

}

extension BusinessTypeSelectionViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTypeCell") as? BusinessTypeTableViewCell else {
            fatalError("Could not dequeue cell of type BusinessTypeTableViewCell")
        }
        let isChecked = indexPath == selectedIndex
        cell.setViews(name: filteredData[indexPath.row], isChecked: isChecked)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tableView.reloadData()
        presenter?.itemClicked(type: filteredData[indexPath.row], indexPath: indexPath)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? dataSource : dataSource.filter {
            $0.range(of: searchText, options: .caseInsensitive) != nil
        }

        tableView.reloadData()
    }
    
}

extension BusinessTypeSelectionViewController: BusinessTypeSelectionMainProtocol {
    
    func presentData(types: [String]) {
        DispatchQueue.main.async {
            self.dataSource = types
            self.filteredData = types
            self.tableView.reloadData()
        }
    }
    
    func sendBusinessType(type: String, indexPath: IndexPath) {
        if let delegateObget = selectionDelegate {
            delegateObget.itemClick(type: type, indexPath: indexPath)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
