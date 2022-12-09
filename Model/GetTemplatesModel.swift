//
//  GetTemplatesModel.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 24.11.2022.
//

import Foundation

struct GetTemplatesModel: Codable {
    var data: DataGetTemplatesModel?
    var error: ErrorResponseModel?
}

struct DataGetTemplatesModel: Codable {
    var templates: [TemplatesModel]?
}

struct TemplatesModel: Codable {
    var hash: String?
    var name: String?
}
