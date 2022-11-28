//
//  KeyStore.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 28.11.2022.
//

import Foundation
import Security

class KeychainWrapper {
    
    private let accessTokenSecAttr = "AccessToken"
    private let refreshTokenSecAttr = "RefreshToken"
    private let secAttrService = "zuzex.com"
    
    func setAccessToken(token: String, isUpdate: Bool) {
        let keychainItem = [
          kSecValueData: token.data(using: .utf8)!,
          kSecAttrAccount: accessTokenSecAttr,
          kSecAttrService: secAttrService,
          kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        if isUpdate {
            let attributes = [
                   kSecValueData: token.data(using: .utf8)!
               ] as CFDictionary
            SecItemUpdate(keychainItem, attributes)
        } else {
            SecItemAdd(keychainItem, nil)
        }
    }
    
    func setRefreshToken(token: String, isUpdate: Bool) {
        let keychainItem = [
          kSecValueData: token.data(using: .utf8)!,
          kSecAttrAccount: refreshTokenSecAttr,
          kSecAttrService: secAttrService,
          kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        if isUpdate {
            let attributes = [
                   kSecValueData: token.data(using: .utf8)!
               ] as CFDictionary
            SecItemUpdate(keychainItem, attributes)
        } else {
            SecItemAdd(keychainItem, nil)
        }
    }
    
    func readAccessToken() -> String {
        let query = [
            kSecAttrService: secAttrService,
            kSecAttrAccount: accessTokenSecAttr,
            kSecClass: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ] as CFDictionary

        var itemCopy: AnyObject?
        SecItemCopyMatching(
            query as CFDictionary,
            &itemCopy
        )
        var token: String = ""
        if let tokenData = itemCopy as? Data {
            token = String(data: tokenData, encoding: .utf8) ?? ""
        }

        return token
    }
    
    func readRefreshToken() -> String {
        let query = [
            kSecAttrService: secAttrService,
            kSecAttrAccount: refreshTokenSecAttr,
            kSecClass: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ] as CFDictionary
        
        var itemCopy: AnyObject?
        SecItemCopyMatching(
            query as CFDictionary,
            &itemCopy
        )
        var token: String = ""
        if let tokenData = itemCopy as? Data {
            token = String(data: tokenData, encoding: .utf8) ?? ""
        }
        
        return token
    }
    
    func deleteData() {
        let queryRefreshToken = [
          kSecAttrAccount: refreshTokenSecAttr,
          kSecAttrService: secAttrService,
          kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        let queryAccessToken = [
          kSecAttrAccount: accessTokenSecAttr,
          kSecAttrService: secAttrService,
          kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        SecItemDelete(queryAccessToken)
        SecItemDelete(queryRefreshToken)
    }
    
}
