//
//  TextField+Ext.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 01.12.2022.
//

import Foundation
import UIKit

extension UITextField {
    
    var changePlaceholderToStandart: NSAttributedString {
        return NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 245.0/255.0, alpha: 0.72),
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        )
    }
}
