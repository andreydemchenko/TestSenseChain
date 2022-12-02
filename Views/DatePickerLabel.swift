//
//  DatePickerLabel.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 01.12.2022.
//

import Foundation
import UIKit

class DatePickerLabel: UILabel {

    private let _inputView: UIView? = {
        var picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        return picker
    }()

    private let _inputAccessoryToolbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true

        toolBar.sizeToFit()

        return toolBar
    }()

    override var inputView: UIView? {
        return _inputView
    }

    override var inputAccessoryView: UIView? {
        return _inputAccessoryToolbar
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        _inputAccessoryToolbar.setItems([spaceButton, doneButton], animated: false)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(launchPicker))
        self.addGestureRecognizer(tapRecognizer)
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    @objc
    private func launchPicker() {
        becomeFirstResponder()
    }

    @objc
    private func doneClick() {
        if let pickerView = _inputView as? UIDatePicker {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy"
            text = formatter.string(from: pickerView.date)
        }
        resignFirstResponder()
    }

}
