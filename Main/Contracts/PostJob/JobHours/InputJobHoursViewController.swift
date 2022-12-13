//
//  InputJobHoursViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 01.12.2022.
//

import UIKit

protocol JobHoursProtocol: AnyObject {
    func sendTime(hours: Int, minutes: Int)
}

class InputJobHoursViewController: UIViewController {

    @IBOutlet private weak var mainStackView: UIStackView!
    @IBOutlet private weak var hoursStackView: UIStackView!
    @IBOutlet private weak var minutesStackView: UIStackView!
    @IBOutlet private weak var hoursTxtField: UITextField!
    @IBOutlet private weak var minutesTxtField: UITextField!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var minutesLabel: UILabel!
    @IBOutlet private weak var enterBtn: UIButton!
    
    private lazy var minutesPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.sizeToFit()
        return picker
    }()
    
    private let minutesArray = Array(0...59).map { String($0) }
    
    weak var jobHoursDelegate: JobHoursProtocol?
    var jobHours: Double?
    private var hours: Int?
    private var minutes: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Job hours"
        
        hoursTxtField.placeholder = "00"
        hoursTxtField.attributedPlaceholder = hoursTxtField.changePlaceholderToStandart
        hoursTxtField.borderStyle = .none
        minutesTxtField.placeholder = "00"
        hoursTxtField.attributedPlaceholder = hoursTxtField.changePlaceholderToStandart
        minutesTxtField.borderStyle = .none
        
        minutesPickerView.dataSource = self
        minutesPickerView.delegate = self
        
        minutesTxtField.delegate = self
        minutesTxtField.inputView = minutesPickerView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let jobHours {
            let splitTime = modf(jobHours)
            hours = Int(splitTime.0)
            minutes = Int(splitTime.1 * 60)
            hoursTxtField.text = "\(hours!)"
            minutesTxtField.text = "\(minutes!)"
        }
    }
    
    @objc
    private func dismissKeyboard() {
        minutesPickerView.isHidden = true
        hoursLabel.textColor = .systemGray
        minutesLabel.textColor = .systemGray
        view.endEditing(true)
    }
    
    @IBAction
    private func touchedHoursTxtFiled(_ sender: Any) {
        hoursLabel.textColor = .orange
        minutesLabel.textColor = .systemGray
    }
    
    @IBAction
    private func touchedMinutesTxtField(_ sender: Any) {
        mainStackView.addArrangedSubview(minutesPickerView)
        hoursLabel.textColor = .systemGray
        minutesLabel.textColor = .orange
    }
    
    @IBAction
    private func enterTimeClicked(_ sender: Any) {
        let hours = Int(hoursTxtField.text ?? "0") ?? 0
        let minutes = Int(minutesTxtField.text ?? "0") ?? 0
        if let delegateObget = jobHoursDelegate {
            delegateObget.sendTime(hours: hours, minutes: minutes)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension InputJobHoursViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        minutesPickerView.isHidden = false
        return false
    }
}

extension InputJobHoursViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return minutesArray.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return minutesArray[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        minutesTxtField.text = minutesArray[row]
        minutesLabel.textColor = .systemGray
        pickerView.isHidden = true
    }
}
