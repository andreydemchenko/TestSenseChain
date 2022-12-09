//
//  PostJobViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 30.11.2022.
//

import Photos
import PhotosUI
import MobileCoreServices
import UniformTypeIdentifiers
import UIKit

class PostJobViewController: UIViewController {
    
    @IBOutlet private weak var contractNameTxtField: UITextField!
    @IBOutlet private weak var chosenBusinessTypeLbl: UILabel!
    @IBOutlet private weak var descriptionTxtView: UITextView!
    @IBOutlet private weak var businessTypeStackView: UIStackView!
    @IBOutlet private weak var startDateStackView: UIStackView!
    @IBOutlet private weak var startDateTxtField: UITextField!
    @IBOutlet private weak var addDocumentsStackView: UIStackView!
    @IBOutlet private weak var addDocumentsView: UIView!
    @IBOutlet private weak var addDocumentsLbl: UILabel!
    @IBOutlet private weak var addFilesStackView: UIStackView!
    @IBOutlet private weak var addFilesView: UIView!
    @IBOutlet private weak var addFilesLbl: UILabel!
    @IBOutlet private weak var deadlineStackView: UIStackView!
    @IBOutlet private weak var deadlineDateTxtField: UITextField!
    @IBOutlet private weak var jobHoursSymbolLbl: UILabel!
    @IBOutlet private weak var priceSymbolLbl: UILabel!
    @IBOutlet private weak var jobHoursStackView: UIStackView!
    @IBOutlet private weak var jobHoursLbl: UILabel!
    @IBOutlet private weak var priceStackView: UIStackView!
    @IBOutlet private weak var priceLbl: UILabel!
    @IBOutlet private weak var comissionLbl: UILabel!
    @IBOutlet private weak var nextBtn: UIButton!
    
    var presenter: PostJobPresenter!
    
    private var descriptionPlaceholderLbl: UILabel!
    
    private var selectedBusinessTypeIndexPath: IndexPath?
    private var jobHours: Double?
    private var price: Double?
    private var comission: Double?
    private var inputPricePageNumber: Int?
    private var businessType: String?
    private let startDatePicker = UIDatePicker()
    private let deadlineDatePicker = UIDatePicker()
    private var startDate: Date?
    private var deadlineDate: Date?
    private var documentsModels = [UploadedFileModel]()
    private var filesModels = [UploadedFileModel]()
    private var isAddDocuments = false
    
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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func configureView() {
        title = "Create a contract"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        startDateTxtField.borderStyle = .none
        deadlineDateTxtField.borderStyle = .none
        setDatePickers()
        contractNameTxtField.borderStyle = .none
        contractNameTxtField.placeholder = "Contract name"
        contractNameTxtField.attributedPlaceholder = contractNameTxtField.changePlaceholderToStandart
        contractNameTxtField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        setDescriptionPlaceholder()
        descriptionTxtView.delegate = self
    }
    
    private func setDescriptionPlaceholder() {
        descriptionPlaceholderLbl = UILabel()
        descriptionPlaceholderLbl.text = "Description"
        descriptionPlaceholderLbl.font = UIFont.systemFont(ofSize: 16)
        descriptionPlaceholderLbl.sizeToFit()
        descriptionTxtView.addSubview(descriptionPlaceholderLbl)
        descriptionPlaceholderLbl.frame.origin = CGPoint(x: 5, y: 8)
        descriptionPlaceholderLbl.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    }
    
    private func setDatePickers() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        let date = formatter.string(from: Date())
        startDateTxtField.text = date
        deadlineDateTxtField.text = date
        startDate = Date()
        deadlineDate = Date()
        
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
            deadlineDatePicker.preferredDatePickerStyle = .wheels
        }
        
        startDatePicker.datePickerMode = .date
        deadlineDatePicker.datePickerMode = .date
        
        let toolbarStartDate = UIToolbar()
        toolbarStartDate.sizeToFit()
        
        let doneButtonStartDate = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarStartDate.setItems([spaceButton, doneButtonStartDate], animated: false)
        
        startDateTxtField.inputAccessoryView = toolbarStartDate
        startDateTxtField.inputView = startDatePicker
        
        let toolbarDeadline = UIToolbar()
        toolbarDeadline.sizeToFit()
    
        let doneButtonDeadline = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDeadlineDatePicker))
        toolbarDeadline.setItems([spaceButton, doneButtonDeadline], animated: false)
        
        deadlineDateTxtField.inputAccessoryView = toolbarDeadline
        deadlineDateTxtField.inputView = deadlineDatePicker
    }
    
    @objc
    private func doneStartDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        startDate = startDatePicker.date
        startDateTxtField.text = formatter.string(from: startDate!)
        dismissKeyboard()
    }
    
    @objc
    private func doneDeadlineDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        deadlineDate = deadlineDatePicker.date
        deadlineDateTxtField.text = formatter.string(from: deadlineDate!)
        dismissKeyboard()
    }
    
    @objc
    private func textFieldDidChange() {
        presenter.checkFields()
    }
    
    @objc
    private func businessTypeStackViewClicked() {
        dismissKeyboard()
        let vc = BusinessTypeSelectionViewController(nibName: "BusinessTypeSelectionViewController", bundle: nil)
        vc.selectionDelegate = self
        vc.presenter = BusinessTypeSelectionPresenter(view: vc, service: appContext.mainService)
        if let selectedBusinessTypeIndexPath {
            vc.selectedIndex = selectedBusinessTypeIndexPath
        }
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func jobHoursStackViewClicked() {
        dismissKeyboard()
        let vc = InputJobHoursViewController(nibName: "InputJobHoursViewController", bundle: nil)
        vc.jobHoursDelegate = self
        vc.jobHours = jobHours
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func priceStackViewClicked() {
        dismissKeyboard()
        let vc = InputPriceViewController(nibName: "InputPriceViewController", bundle: nil)
        vc.inputPriceDelegate = self
        if let price, let comission {
            vc.price = price
            vc.comission = comission
            if let inputPricePageNumber {
                vc.pageNumber = inputPricePageNumber
            }
        }
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func addDocumentsViewClicked() {
        dismissKeyboard()
        isAddDocuments = true
        madeActionSheetAlert()
    }
    
    @objc
    private func addFilesViewClicked() {
        dismissKeyboard()
        isAddDocuments = false
        madeActionSheetAlert()
    }
    
    private func showImagePicker() {
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.selectionLimit = 10
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    private func selectFiles() {
        if #available(iOS 14.0, *) {
            let types = UTType.types(tag: "json",
                                     tagClass: UTTagClass.filenameExtension,
                                     conformingTo: nil)
            let documentPickerController = UIDocumentPickerViewController(
                forOpeningContentTypes: types)
            documentPickerController.delegate = self
            self.present(documentPickerController, animated: true, completion: nil)
        }
    }
    
    private func showFilePicker(){
        let documentPicker = UIDocumentPickerViewController(documentTypes: Utils.docsTypes, in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .formSheet
        documentPicker.shouldShowFileExtensions = true
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    private func madeActionSheetAlert() {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let takePictureAction = UIAlertAction(title: "Upload photo or video", style: .default) { action -> Void in
            self.showImagePicker()
        }
        takePictureAction.setValue(UIColor.orange, forKey: "titleTextColor")
        actionSheetController.addAction(takePictureAction)

        let choosePictureAction = UIAlertAction(title: "Upload file", style: .default) { action -> Void in
            self.showFilePicker()
        }
        choosePictureAction.setValue(UIColor.orange, forKey: "titleTextColor")
        actionSheetController.addAction(choosePictureAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
        actionSheetController.addAction(cancelAction)

        actionSheetController.popoverPresentationController?.sourceRect = view.bounds
        actionSheetController.popoverPresentationController?.sourceView = view
        self.present(actionSheetController, animated: true, completion: nil)
    }

    private func createUploadedItem(_ model: UploadedFileModel) {
        let item = Bundle.main.loadNibNamed("UploadedFileView", owner: self, options: nil)?.first as? UploadedFileView
        if let item {
            item.uploadedFileDelegate = self
            if isAddDocuments {
                item.setViews(model: model, isDocument: true, isEditable: true)
                documentsModels.append(model)
                addDocumentsStackView.removeArrangedSubview(addDocumentsView)
                addDocumentsStackView.addArrangedSubview(item)
                addDocumentsStackView.addArrangedSubview(addDocumentsView)
                checkIfDocumentsStackViewIsEmpty()
            } else {
                item.setViews(model: model, isDocument: false, isEditable: true)
                filesModels.append(model)
                addFilesStackView.removeArrangedSubview(addFilesView)
                addFilesStackView.addArrangedSubview(item)
                addFilesStackView.addArrangedSubview(addFilesView)
                checkIfFilesStackViewIsEmpty()
            }
            presenter.checkFields()
        }
    }
    
    private func checkIfDocumentsStackViewIsEmpty() {
        if let addDocumentsView = addDocumentsView as? RectangularDashedView {
            if addDocumentsStackView.subviews.count != 1 {
                addDocumentsLbl.text = "Add more"
                addDocumentsView.dashWidth = 0
            } else {
                addDocumentsLbl.text = "Add documents"
                addDocumentsView.dashWidth = 1
            }
            self.addDocumentsView.setNeedsLayout()
        }
    }
    
    private func checkIfFilesStackViewIsEmpty() {
        if let addFilesView = addFilesView as? RectangularDashedView {
            if addFilesStackView.subviews.count != 1 {
                addFilesLbl.text = "Add more"
                addFilesView.dashWidth = 0
            } else {
                addFilesLbl.text = "Add documents"
                addFilesView.dashWidth = 1
            }
            self.addFilesView.setNeedsLayout()
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
    
    var name: String? {
        contractNameTxtField.text
    }
    
    var businessTypeValue: String? {
        businessType
    }
    
    var descriptionValue: String? {
        descriptionTxtView.text
    }
    
    var startDateValue: Date? {
        startDatePicker.date
    }
    
    var deadlineValue: Date? {
        deadlineDatePicker.date
    }
    
    var documentsItems: [UploadedFileModel] {
        documentsModels
    }
    
    var filesItems: [UploadedFileModel] {
        filesModels
    }
    
    var hoursValue: Double? {
        jobHours
    }
    
    var priceValue: Double? {
        price
    }
    
    var accountTypeIndex: Int? {
        inputPricePageNumber
    }
    
    var comissionValue: Double? {
        comission
    }
    
    var isBtnNextEnabled: Bool {
        get {
            nextBtn.isEnabled
        }
        set {
            nextBtn.isEnabled = newValue
            if newValue {
                nextBtn.backgroundColor = .orange
                nextBtn.setTitleColor(.white, for: .normal)
            } else {
                nextBtn.backgroundColor = UIColor(red: 102.0/255.0, green: 52.0/255.0, blue: 5.0/255.0, alpha: 1.0)
                nextBtn.setTitleColor(UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 147.0/255.0, alpha: 1.0), for: .normal)
            }
        }
    }
    
    func move(to: PostJobNavigation) {
        switch to {
        case let .next(model):
            let vc = ReviewPostJobViewController(nibName: "ReviewPostJobViewController", bundle: nil)
            vc.presenter = ReviewPostJobPresenter(view: vc, model: model, service: appContext.mainService)
            vc.hidesBottomBarWhenPushed = true
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        case .bussinessType:
            break
        case .uploadDocuments:
            break
        case .uploadFiles:
            break
        }
    }
    
}

extension PostJobViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        descriptionPlaceholderLbl.isHidden = !textView.text.isEmpty
        presenter.checkFields()
    }
    
}

extension PostJobViewController: BusinessTypeSelectionProtocol {
    
    func itemClick(type: String, indexPath: IndexPath) {
        selectedBusinessTypeIndexPath = indexPath
        chosenBusinessTypeLbl.text = type
        businessType = type
        presenter.checkFields()
    }
    
}

extension PostJobViewController: JobHoursProtocol {
    
    func sendTime(hours: Int, minutes: Int) {
        if hours != 0 || minutes != 0 {
            presenter.setTime(hours: hours, minutes: minutes)
        }
        let time = (Double(hours) + (Double(minutes) / 60.0)).rounded(toPlaces: 2)
        if time != 0 {
            jobHoursLbl.textColor = .white
            jobHoursLbl.text = "\(time)"
            jobHours = time
        } else {
            jobHoursLbl.textColor = .systemGray
            jobHoursLbl.text = "Job hours"
        }
        presenter.checkFields()
    }
    
}

extension PostJobViewController: InputPriceToMainProtocol {
    
    func sendPrice(price: Double?, comission: Double?, pageNumber: Int?) {
        if let price, price != 0 {
            priceLbl.text = "\(price)"
            priceLbl.textColor = .white
            self.price = price
            if let comission, comission != 0 {
                self.comission = comission
                comissionLbl.text = "\(comission) sc comission"
                comissionLbl.isHidden = false
            }
            if let pageNumber {
                print("page == \(pageNumber)")
                inputPricePageNumber = pageNumber
            }
        } else {
            priceLbl.text = "Price"
            priceLbl.textColor = .systemGray
            comissionLbl.isHidden = true
        }
        presenter.checkFields()
    }
    
}
    
extension PostJobViewController: UploadedFileProtocol {
    
    func removeView(view: UploadedFileView, isDocument: Bool) {
        if isDocument {
            let index = documentsModels.firstIndex(where: { $0.id == view.getFileId() })
            let i = index?.advanced(by: 0) ?? -1
            print("doc i ==== \(i)")
            documentsModels.remove(at: i)
            addDocumentsStackView.removeArrangedSubview(addDocumentsView)
            addDocumentsStackView.removeArrangedSubview(view)
            addDocumentsStackView.addArrangedSubview(addDocumentsView)
            view.removeFromSuperview()
            checkIfDocumentsStackViewIsEmpty()
        } else {
            let index = filesModels.firstIndex(where: { $0.id == view.getFileId() })
            let i = index?.advanced(by: 0) ?? -1
            print("file i ==== \(i)")
            filesModels.remove(at: i)
            addFilesStackView.removeArrangedSubview(addFilesView)
            addFilesStackView.removeArrangedSubview(view)
            addFilesStackView.addArrangedSubview(addFilesView)
            view.removeFromSuperview()
            checkIfFilesStackViewIsEmpty()
        }
        presenter.checkFields()
    }
    
}

extension PostJobViewController: PHPickerViewControllerDelegate,         UIAdaptivePresentationControllerDelegate {
    
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            let itemProvider: NSItemProvider = result.itemProvider
            
            let name = itemProvider.suggestedName ?? "Unknown name"
            var strFileSize = "0 kB"
            
            if let ident = result.assetIdentifier {
                let result = PHAsset.fetchAssets(withLocalIdentifiers: [ident], options: nil)
                if let asset = result.firstObject {
                    
                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                            if let url {
                                strFileSize = url.getFileSize
                                if let nsdata = NSData(contentsOf: url) {
                                    let data = Data(referencing: nsdata)
                                    
                                    print("image url = \(url)  type = \(url.lastPathComponent)")
                                    
                                    let model = UploadedFileModel(data: data, icoImage: UIImage(named: "image_ico")!, fileName: name, fileSize: strFileSize, url: url)
                                    
                                    DispatchQueue.main.async {
                                        self.createUploadedItem(model)
                                    }
                                }
                            } else if let error {
                                print("An error occurred with loading image: \(error.localizedDescription)")
                            }
                        }
                    } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                        itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                            if let url = url {
                                if let nsdata = NSData(contentsOf: url) {
                                    let data = Data(referencing: nsdata)
                                    let innerGroup = DispatchGroup()
                                    innerGroup.enter()
                                    let options = PHVideoRequestOptions()
                                    options.version = .original
                                    
                                    PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
                                        if let urlAsset = avAsset as? AVURLAsset {
                                            if let resourceValues = try? urlAsset.url.resourceValues(forKeys: [.fileSizeKey]),
                                               let fileSize = resourceValues.fileSize {
                                                
                                                let formatter = ByteCountFormatter()
                                                formatter.countStyle = .file
                                                
                                                strFileSize = formatter.string(fromByteCount: Int64(fileSize))
                                                innerGroup.leave()
                                            }
                                        }
                                    }
                                    
                                    print("video url \(url)")
                                    
                                    innerGroup.notify(queue: .main) {
                                        let model = UploadedFileModel(data: data, icoImage: UIImage(named: "image_ico")!, fileName: name, fileSize: strFileSize, url: url)
                                        
                                        self.createUploadedItem(model)
                                    }
                                }
                            } else if let error {
                                print("An error occurred with loading video: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension PostJobViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard urls.first != nil else {
            return
        }
        for url in urls {
            if let nsdata = NSData(contentsOf: url) {
                let data = Data(referencing: nsdata)
                let filename = url.lastPathComponent
                let filesize = url.getFileSize
                let model = UploadedFileModel(data: data, icoImage: UIImage(named: "file_ico")!, fileName: filename, fileSize: filesize, url: url)
                createUploadedItem(model)
            }
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
