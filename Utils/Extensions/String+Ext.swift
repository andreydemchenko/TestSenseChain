//
//  String+Ext.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date? {
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
