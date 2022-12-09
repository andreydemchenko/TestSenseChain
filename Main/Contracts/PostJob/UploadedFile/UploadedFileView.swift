//
//  UploadedFileView.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 02.12.2022.
//

import UIKit

protocol UploadedFileProtocol: AnyObject {
    func removeView(view: UploadedFileView, isDocument: Bool)
}

class UploadedFileView: UIView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var imageSizeLbl: UILabel!
    @IBOutlet private weak var removeBtn: UIButton!
    @IBOutlet private weak var removeStackView: UIStackView!
    
    weak var uploadedFileDelegate: UploadedFileProtocol?
    
    private var isDocument = false
    private var id = ""
    
    func setViews(model: UploadedFileModel, isDocument: Bool, isEditable: Bool) {
        id = model.id
        self.isDocument = isDocument
        imageView.image = model.icoImage
        nameLbl.text = model.fileName
        imageSizeLbl.text = model.fileSize
        removeBtn.titleLabel?.text = nil
        removeBtn.setTitle(nil, for: .normal)
        if !isEditable {
            removeStackView.isHidden = true
            self.backgroundColor = UIColor(red: 24.0/255.0, green: 24.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        }
    }
    
    @IBAction
    private func removeClick(_ sender: Any) {
        if let delegateObject = uploadedFileDelegate {
            delegateObject.removeView(view: self, isDocument: isDocument)
        }
    }
    
    func getFileId() -> String {
        return id
    }
    
}
