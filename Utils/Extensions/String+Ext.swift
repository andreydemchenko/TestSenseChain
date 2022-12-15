//
//  String+Ext.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailPred = NSPredicate(format: "SELF MATCHES %@", Utils.email)
        return emailPred.evaluate(with: self)
    }
    
    var isValidContractName: Bool {
        let namePred = NSPredicate(format: "SELF MATCHES %@", Utils.contractName)
        return namePred.evaluate(with: self)
    }
    
    var isValidContractDescription: Bool {
        let descPred = NSPredicate(format: "SELF MATCHES %@", Utils.contractDesc)
        return descPred.evaluate(with: self)
    }
    
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
         let dateFormatter = DateFormatter()
         dateFormatter.calendar = Calendar(identifier: .gregorian)
         dateFormatter.dateFormat = format
         let date = dateFormatter.date(from: self)

         return date
     }
    
    var toDouble: Double {
        return (self as NSString).doubleValue
    }
    
    var isDoubleNumber: Bool {
        return self.range(
            of: "^-?\\d+(?:.\\d+)?$",
            options: .regularExpression) != nil
    }
}
