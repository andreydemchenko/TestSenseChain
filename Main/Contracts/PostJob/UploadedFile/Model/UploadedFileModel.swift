//
//  UploadedFileModel.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 02.12.2022.
//

import Foundation
import UIKit

struct UploadedFileModel {
    var id: String = UUID().uuidString
    var data: Data
    var icoImage: UIImage
    var fileName: String
    var fileSize: String
    var url: URL
}
