//
//  AppContext.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import Foundation

let appContext = AppContext()

class AppContext {
    fileprivate init() {}
    
    lazy var authentication = AuthService()
}
