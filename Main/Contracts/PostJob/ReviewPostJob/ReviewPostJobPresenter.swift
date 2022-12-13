//
//  ReviewPostJobPresenter.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 06.12.2022.
//

import Foundation

protocol ReviewPostJobProtocol: AnyObject {
    func presentData(model: CreateContractJobModel)
    func contractCreated()
    func removeLoader()
}

class ReviewPostJobPresenter {
    
    weak var view: ReviewPostJobProtocol?
    private var model: CreateContractJobModel?
    private let service: MainServiceProtocol
    private var documentHashes: [String] = []
    private var fileHashes: [String] = []
    
    init(view: ReviewPostJobProtocol, model: CreateContractJobModel?, service: MainServiceProtocol) {
        self.view = view
        self.model = model
        self.service = service
    }
    
    func showData() {
        if let model {
            view?.presentData(model: model)
        }
    }
    
    func createContractBtnTapped() {
        if let model {
            let group = DispatchGroup()
            for uploadFile in model.documents {
                group.enter()
                let attachment = AttachmentUploadReq(name: uploadFile.fileName, section: "contract", file: uploadFile.data, mimeType: uploadFile.url.mimeType())
                service.uploadAttachment(model: attachment) { [weak self] res in
                    switch res {
                    case let .success(attachmentRes):
                        if let hash = attachmentRes.data?.hash {
                            self?.documentHashes.append(hash)
                        }
                        group.leave()
                    case let .failure(error):
                        print("An error occurred with uploading attachment: \(error.localizedDescription)")
                    }
                }
            }
            for uploadFile in model.files {
                group.enter()
                let attachment = AttachmentUploadReq(name: uploadFile.fileName, section: "contract", file: uploadFile.data, mimeType: uploadFile.url.mimeType())
                service.uploadAttachment(model: attachment) { [weak self] res in
                    switch res {
                    case let .success(attachmentRes):
                        if let hash = attachmentRes.data?.hash {
                            self?.fileHashes.append(hash)
                        }
                        group.leave()
                    case let .failure(error):
                        print("An error occurred with uploading attachment: \(error.localizedDescription)")
                    }
                }
            }
            group.notify(queue: .global(qos: .background)) { [weak self] in
                self?.createContract()
            }
        }
    }
    
    private func createContract() {
        if let model {
            let group = DispatchGroup()
            group.enter()
            let contractReq = CreateContractJobReq(account_type: model.accountType,
                                                   amount: "\(model.price)",
                                                   deadline: model.deadline.formattedDateString,
                                                   description: model.description,
                                                   document_hashes: documentHashes,
                                                   file_hashes: fileHashes,
                                                   hours: "\(model.hours)",
                                                   minutes: "\(model.minutes)",
                                                   name: model.name,
                                                   start_date: model.startDate.formattedDateString,
                                                   type: model.businessType)
            print("model == \(contractReq)")
            service.createJobContract(model: contractReq) { [weak self] res in
                switch res {
                case let .success(response):
                    if response.data != nil {
                        self?.view?.contractCreated()
                    }
                    if let error = response.error {
                        print("An error occurred with creating job contract: \(error.text)")
                    }
                    group.leave()
                case let .failure(error):
                    print("An error occurred with creating job contract: \(error.localizedDescription)")
                    group.leave()
                }
            }
            group.notify(queue: .main) { [weak self] in
                self?.view?.removeLoader()
            }
        }
    }
    
}
