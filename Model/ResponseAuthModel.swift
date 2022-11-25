//
//  ResponseModel.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import Foundation

struct ResponseAuthModel: Codable {
    var data: DataResponseAuthModel?
    var error: ErrorResponseModel?
}

struct DataResponseAuthModel: Codable {
    var access_token: String
    var refresh_token: String
    var role_id: Int?
}

struct ErrorResponseModel: Codable {
    var code: Int
    var text: String
}

struct NoReply: Codable {}
