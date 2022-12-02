//
//  UploadedFileView.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 02.12.2022.
//

import UIKit

protocol UploadedFileProtocol: AnyObject {
    func removeView(view: UploadedFileView)
}

class UploadedFileView: UIView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var imageSizeLbl: UILabel!
    @IBOutlet private weak var removeBtn: UIButton!
    
    weak var uploadedFileDelegate: UploadedFileProtocol?
    
    func setViews(model: UploadedFileModel) {
        imageView.image = model.icoImage
        nameLbl.text = model.fileName
        imageSizeLbl.text = model.fileSize
        removeBtn.titleLabel?.text = nil
        removeBtn.setTitle(nil, for: .normal)
    }
    
    @IBAction
    private func removeClick(_ sender: Any) {
        if let delegateObject = uploadedFileDelegate {
            delegateObject.removeView(view: self)
        }
    }
    
}
