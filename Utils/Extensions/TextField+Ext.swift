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
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        )
    }
}
