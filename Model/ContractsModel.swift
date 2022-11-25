//
//  ContractsModel.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 25.11.2022.
//

import Foundation

struct ResponseContractsModel: Codable {
    var data: GetContractJobItem?
    var error: ErrorResponseModel?
}

struct GetContractJobItem: Codable {
    var contracts: [ContractJobModel]
    var role: String
    var status: String
    var total: Int
}

struct ContractJobModel: Codable {
    var amount: Double?
    var amount_early: Double?
    var candidates: Int?
    var cause_close: String?
    var closed_at: String?
    var created_at: String?
    var deadline: String?
    var description: String?
    var employee_user_hash: String?
    var employee_user_username: String?
    var employer_user_hash: String?
    var employer_user_username: String?
    var field_of_job: String?
    var hash: String?
    var hours: Double?
    var name: String?
    var signed_at: String?
    var start_date: String?
    var until_end: Double?
    var updated_at: String?
}
