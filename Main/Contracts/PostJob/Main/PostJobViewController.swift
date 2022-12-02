//
//  PostJobViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 30.11.2022.
//

import UIKit

class PostJobViewController: UIViewController {
    
    @IBOutlet private weak var contractNameTxtField: UITextField!
    @IBOutlet private weak var chosenBusinessTypeLbl: UILabel!
    @IBOutlet private weak var descriptionTxtField: UITextField!
    @IBOutlet private weak var businessTypeStackView: UIStackView!
    @IBOutlet private weak var startDateStackView: UIStackView!
    @IBOutlet private weak var pickerStartDateLbl: UILabel!
    @IBOutlet private weak var addDocumentsStackView: UIStackView!
    @IBOutlet private weak var addDocumentsView: UIView!
    @IBOutlet private weak var addFilesStackView: UIStackView!
    @IBOutlet private weak var addFilesView: UIView!
    @IBOutlet private weak var deadlineStackView: UIStackView!
    @IBOutlet private weak var pickerDeadlineLbl: UILabel!
    @IBOutlet private weak var jobHoursValueLbl: UILabel!
    @IBOutlet private weak var priceValueLbl: UILabel!
    @IBOutlet private weak var jobHoursStackView: UIStackView!
    @IBOutlet private weak var jobHoursLbl: UILabel!
    @IBOutlet private weak var priceStackView: UIStackView!
    @IBOutlet private weak var priceLbl: UILabel!
    @IBOutlet private weak var comissionLbl: UILabel!
    
    var presenter: PostJobPresenter!
    
    private var selectedBusinessTypeIndexPath: IndexPath?
    private var jobHours: Double?
    private var price: String?
    private let startDatePicker = UIDatePicker()
    private let deadlineDatePicker = UIDatePicker()
    
    private var uploadedDocuments: [UploadedFileModel] = []
    private var uploadedFiles: [UploadedFileModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        if presenter == nil {
            presenter = PostJobPresenter(view: self, service: appContext.mainService)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        businessTypeStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(businessTypeStackViewClicked)))
        jobHoursStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(jobHoursStackViewClicked)))
        priceStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(priceStackViewClicked)))
        addDocumentsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addDocumentsViewClicked)))
        addFilesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addFilesViewClicked)))
        
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
            deadlineDatePicker.preferredDatePickerStyle = .wheels
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func configureView() {
        title = "Create a contract"
        contractNameTxtField.borderStyle = .none
        contractNameTxtField.placeholder = "Contract name"
        contractNameTxtField.attributedPlaceholder = contractNameTxtField.changePlaceholderToStandart
        descriptionTxtField.borderStyle = .none
        descriptionTxtField.placeholder = "Description"
        descriptionTxtField.attributedPlaceholder = descriptionTxtField.changePlaceholderToStandart
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        let date = formatter.string(from: Date())
        pickerStartDateLbl.text = date
        pickerDeadlineLbl.text = date
        
    }
    
    @objc
    private func businessTypeStackViewClicked() {
        let vc = BusinessTypeSelectionViewController(nibName: "BusinessTypeSelectionViewController", bundle: nil)
        vc.selectionDelegate = self
        if let selectedBusinessTypeIndexPath {
            vc.selectedIndex = selectedBusinessTypeIndexPath
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func jobHoursStackViewClicked() {
        let vc = InputJobHoursViewController(nibName: "InputJobHoursViewController", bundle: nil)
        vc.jobHoursDelegate = self
        vc.jobHours = jobHours
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func priceStackViewClicked() {
        let vc = InputPriceViewController(nibName: "InputPriceViewController", bundle: nil)
        vc.inputPriceDelegate = self
        vc.price = price
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func addDocumentsViewClicked() {
        //madeActionSheetAlert()
        createUploadedDocumentItem()
    }
    
    @objc
    private func addFilesViewClicked() {
        madeActionSheetAlert()
    }
    
    private func madeActionSheetAlert() {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let takePictureAction = UIAlertAction(title: "Upload photo or video", style: .default) { action -> Void in
            self.performSegue(withIdentifier: "segue_upload_photo_or_video", sender: self)
        }
        takePictureAction.setValue(UIColor.orange, forKey: "titleTextColor")
        actionSheetController.addAction(takePictureAction)

        let choosePictureAction = UIAlertAction(title: "Upload file", style: .default) { action -> Void in
            self.performSegue(withIdentifier: "segue_upload_file", sender: self)
        }
        choosePictureAction.setValue(UIColor.orange, forKey: "titleTextColor")
        actionSheetController.addAction(choosePictureAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
        actionSheetController.addAction(cancelAction)

        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    private func createUploadedDocumentItem() {
        let item = Bundle.main.loadNibNamed("UploadedFileView", owner: self, options: nil)?.first as? UploadedFileView
        if let item {
            let model = UploadedFileModel(icoImage: UIImage(named: "image_ico")!, fileName: "image_123.jpg", fileSize: "123 kB")
            item.setViews(model: model)
            item.uploadedFileDelegate = self
            //uploadedDocuments.append(model)
            addDocumentsStackView.removeArrangedSubview(addDocumentsView)
            addDocumentsStackView.addArrangedSubview(item)
            addDocumentsStackView.addArrangedSubview(addDocumentsView)
        }
    }
    
    @IBAction
    private func btnNextClick(_ sender: Any) {
        presenter.didTapNextBtn()
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension PostJobViewController: PostJobProtocol {
    
    func move(to: PostJobNavigation) {
        switch to {
        case .next:
            break
        case .bussinessType:
            break
        case .uploadDocuments:
            break
        case .uploadFiles:
            break
        }
    }
    
}

extension PostJobViewController: BusinessTypeSelectionProtocol {
    
    func itemClick(indexPath: IndexPath) {
        selectedBusinessTypeIndexPath = indexPath
        let name = BusinesTypeSelection.allCases[indexPath.row].rawValue
        chosenBusinessTypeLbl.text = name
    }
    
}

extension PostJobViewController: JobHoursProtocol {
    
    func sendTime(time: Double) {
        if time != 0 {
            jobHoursLbl.textColor = .white
            jobHoursLbl.text = "\(time)"
            jobHours = time
        } else {
            jobHoursLbl.textColor = .systemGray
            jobHoursLbl.text = "Job hours"
        }
    }
    
}

extension PostJobViewController: InputPriceToMainProtocol {
    
    func sendPrice(price: Double?) {
        if let price, price != 0 {
            priceLbl.text = "\(price)"
            priceLbl.textColor = .white
            self.price = "\(price)"
        } else {
            priceLbl.text = "Price"
            priceLbl.textColor = .systemGray
        }
    }
    
}
    
extension PostJobViewController: UploadedFileProtocol {
    
    func removeView(view: UploadedFileView) {
        addDocumentsStackView.removeArrangedSubview(addDocumentsView)
        addDocumentsStackView.addArrangedSubview(addDocumentsView)
        addDocumentsStackView.removeArrangedSubview(view)
    }
    
}
