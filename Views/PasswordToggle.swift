//
//  PasswordToggle.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 23.11.2022.
//

import Foundation
import UIKit

extension UITextField {
    
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if (isSecureTextEntry) {
            button.setImage(UIImage(named: "view_password"), for: .normal)
        } else {
            button.setImage(UIImage(named: "hide_password"), for: .normal)
        }
    }
    
    func enablePasswordToggle() {
        let button = UIButton(type: .custom)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
        setPasswordToggleImage(button)
    }
    
    @IBAction func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry.toggle()
        setPasswordToggleImage(sender as! UIButton)
    }
}
