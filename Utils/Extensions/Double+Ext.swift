//
//  Double+Ext.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 28.11.2022.
//

import Foundation

extension Double {
    
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        let str = String(formatter.string(from: number) ?? "")
        return str.replacingOccurrences(of: ",", with: ".")
    }
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}

