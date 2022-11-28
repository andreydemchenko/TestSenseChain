//
//  Date+Ext.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 28.11.2022.
//

import Foundation

extension Date {
    
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
}
