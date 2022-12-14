//
//  ContractsModel.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 25.11.2022.
//

import Foundation

struct ResponseJobComission: Codable {
    var data: ResponseJobComissionData?
    var error: ErrorResponseModel?
}

struct ResponseJobComissionData: Codable {
    var amount: String
    var comission: String
}

struct ContractJobTypeResponse: Codable {
    var data: ContractJobTypeRes?
    var error: ErrorResponseModel?
}

struct ContractJobTypeRes: Codable {
    var types: [String]
}

struct GetContractsJobResponse: Codable {
    var data: GetContractsJobRes?
    var error: ErrorResponseModel?
}

struct GetContractsJobRes: Codable {
    var contracts: [GetContractsJobItem]
    var role: String
    var status: String
    var total: Int
}

struct GetContractsJobItem: Codable {
    var amount: String?
    var amount_early: String?
    var candidates: Int?
    var cause_close: String?
    var closed_at: String?
    var created_at: String?
    var deadline: String?
    var description: String?
    var disputed: Bool?
    var employee: Employee?
    var employer: Employer?
    var hash: String?
    var hours: String?
    var is_waiting_vote_employer: Bool?
    var name: String?
    var signed_at: String?
    var start_date: String?
    var type: String?
    var until_end: String?
    var updated_at: String?
}

struct Employee: Codable {
    var avatar_link: String?
    var hash: String?
    var rate: Int?
    var username: String?
}

struct Employer: Codable {
    var avatar_link: String?
    var hash: String?
    var rate: Int?
    var username: String?
}

struct CreateContractJobModel {
    var name: String
    var businessType: String
    var description: String
    var startDate: Date
    var deadline: Date
    var documents: [UploadedFileModel]
    var files: [UploadedFileModel]
    var hours: Int
    var minutes: Int
    var accountType: String
    var price: Double
    var comission: Double
}

struct CreateContractJobResponse: Codable {
    var data: CreateContractJobReq?
    var error: ErrorResponseModel?
}

struct CreateContractJobReq: Codable {
    var account_type: String
    var amount: String
    var deadline: String
    var description: String
    var document_hashes: [String]
    var file_hashes: [String]
    var hours: String
    var minutes: String
    var name: String
    var start_date: String
    var type: String
}

struct CreateContractJobRes: Codable {
    var account_type: String
    var amount: Double
    var created_at: String
    var deadline: String
    var description: String
    var document_hashes: [String]
    var file_hashes: [String]
    var hash: String
    var hours: Int
    var minutes: Int
    var name: String
    var start_date: String
    var status: String
    var type: String
}
