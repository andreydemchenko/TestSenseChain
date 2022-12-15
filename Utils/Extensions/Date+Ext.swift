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
    
    var formattedDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
    
    var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: self)
    }
    
}
