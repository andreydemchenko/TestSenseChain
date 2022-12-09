//
//  AttachmentModels.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 08.12.2022.
//

import Foundation

struct AttachmentUploadReq: Codable {
    var name: String
    var section: String
    var file: Data
    var mimeType: String
}

struct AttachmentUploadResponse: Codable {
    var data: AttachmentUploadRes?
    var error: ErrorResponseModel?
}

struct AttachmentUploadRes: Codable {
    var file_name: String?
    var file_size_bytes: Int?
    var file_type: String?
    var hash: String?
    var link: String?
    var name: String?
    var section: String?
}
