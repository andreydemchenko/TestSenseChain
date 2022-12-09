//
//  ReviewPostJobViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 06.12.2022.
//

import UIKit

class ReviewPostJobViewController: UIViewController {

    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var businessTypeLbl: UILabel!
    @IBOutlet private weak var descriptionLbl: UILabel!
    @IBOutlet private weak var executionDatesLbl: UILabel!
    @IBOutlet private weak var documentsStackView: UIStackView!
    @IBOutlet private weak var filesStackView: UIStackView!
    @IBOutlet private weak var jobHoursLbl: UILabel!
    @IBOutlet private weak var priceLbl: UILabel!
    @IBOutlet private weak var allPriceWithComissionLbl: UILabel!
    @IBOutlet private weak var exampleFileStackView: UIStackView!
    @IBOutlet private weak var exampleDocumentStackView: UIStackView!
    
    var presenter: ReviewPostJobPresenter?
    
    private let spinner = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter == nil {
            presenter = ReviewPostJobPresenter(view: self, model: nil, service: appContext.mainService)
        }
        presenter?.showData()
        
        configureView()
    }
    
    private func configureView() {
        title = "Create a contrat"
    }

    @IBAction func createContractBtnClicked(_ sender: Any) {
        self.createSpinnerView(spinner)
        presenter?.createContractBtnTapped()
    }
    
    private func createUploadedItem(_ model: UploadedFileModel, isAddDocument: Bool) {
        let item = Bundle.main.loadNibNamed("UploadedFileView", owner: self, options: nil)?.first as? UploadedFileView
        if let item {
            item.setViews(model: model, isDocument: isAddDocument, isEditable: false)
            if isAddDocument {
                documentsStackView.addArrangedSubview(item)
            } else {
                filesStackView.addArrangedSubview(item)
            }
        }
    }
    
    private func createAttributedText(text: String, addSymbols: String) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(string: "\(text) \(addSymbols)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0), range: NSRange(location: text.count + 1, length: addSymbols.count))
        return mutableString
    }
}

extension ReviewPostJobViewController: ReviewPostJobProtocol {
    
    func presentData(model: CreateContractJobModel) {
        nameLbl.text = model.name
        businessTypeLbl.text = model.businessType
        descriptionLbl.text = model.description
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        let startDate = formatter.string(from: model.startDate)
        let deadline = formatter.string(from: model.deadline)
        executionDatesLbl.text = "\(startDate) - \(deadline)"
        documentsStackView.removeArrangedSubview(exampleDocumentStackView)
        filesStackView.removeArrangedSubview(exampleFileStackView)
        model.documents.forEach {
            createUploadedItem($0, isAddDocument: true)
        }
        model.files.forEach {
            createUploadedItem($0, isAddDocument: false)
        }
        let time = (Double(model.hours) + (Double(model.minutes) / 60.0)).rounded(toPlaces: 2)
        jobHoursLbl.attributedText = createAttributedText(text: "\(time)", addSymbols: "h")
        priceLbl.attributedText = createAttributedText(text: "\(model.price)", addSymbols: "sc")
        allPriceWithComissionLbl.text = "You will pay \(model.price + model.comission) sc including comission"
    }
    
    func contractCreated() {
        DispatchQueue.main.async {
            let vc = ContractCreatedViewController(nibName: "ContractCreatedViewController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.navigationBar.topItem?.title = " "
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func removeLoader() {
        self.removeSpinnerView(spinner)
    }
    
}
