//
//  InputPriceViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 01.12.2022.
//

import UIKit

protocol InputPriceToMainProtocol: AnyObject {
    func sendPrice(price: Double?, comission: Double?, pageNumber: Int?)
}

class InputPriceViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var priceTxtField: UITextField!
    @IBOutlet private weak var scPriceLabel: UILabel!
    @IBOutlet private weak var comissionLbl: UILabel!
    @IBOutlet private weak var wholePriceLbl: UILabel!
    @IBOutlet private weak var wholePriceView: UIView!
    @IBOutlet private weak var slideView: UIView!
    @IBOutlet private weak var errorLbl: UILabel!
    @IBOutlet private weak var wholePriceViewBottomConstraint: NSLayoutConstraint!
    
    var price: Double?
    var comission: Double?
    var pageNumber: Int = 0
    var presenter: InputPricePresenter!
    private var balances: [WalletModelCell] = []
    private var slides: [BalanceAccountView] = []
    private var wholePriceFrame = CGPoint(x: 0, y: 0)
    private var balance: Double = 10
    
    private var keyboardSizeHeight: CGFloat = 0.0
    
    weak var inputPriceDelegate: InputPriceToMainProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Price"
        presenter = InputPricePresenter(view: self, service: appContext.mainService)
        presenter.getWalletData()
        
        priceTxtField.borderStyle = .none
        wholePriceView.layer.cornerRadius = 10
        wholePriceView.layer.borderWidth = 1
        wholePriceView.layer.borderColor = UIColor.systemGray.cgColor
        wholePriceFrame = wholePriceView.frame.origin
        
        scrollView.delegate = self
        
        priceTxtField.placeholder = "Price"
        priceTxtField.attributedPlaceholder = priceTxtField.changePlaceholderToStandart
        if let price, let comission  {
            priceTxtField.text = "\(price)"
            comissionLbl.text = "\(comission) sc comission"
            wholePriceLbl.text = "\(price + comission) sc"
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        wholePriceView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(priceViewClicked)))
        
    }
    
    @objc
    private func priceViewClicked() {
        presenter.didTapPriceView()
    }
    
    private func showWalletData() {
        createSlides()
        setupSlideScrollView()
    }
    
    private func createSlides() {
        for item in balances {
            let slide = Bundle.main.loadNibNamed("BalanceAccountView", owner: self, options: nil)?.first as? BalanceAccountView
            if let slide {
                slide.setViews(image: item.image, name: item.text, balance: item.balance)
                slides.append(slide)
            }
        }
    }
    
    private func setupSlideScrollView() {
        balance = balances[pageNumber].balance ?? 0
        pageControl.currentPage = pageNumber
        pageControl.numberOfPages = slides.count
        view.bringSubviewToFront(pageControl)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: slideView.frame.width * CGFloat(i), y: 0, width: slideView.frame.width, height: slideView.frame.height)
            scrollView.addSubview(slides[i])
        }
        let x = CGFloat(pageNumber) * slideView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: false)
    }
    
    @IBAction
    private func changePage(_ sender: Any) {
        pageNumber = pageControl.currentPage
        balance = balances[pageNumber].balance ?? 0
        let x = CGFloat(pageNumber) * slideView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        presenter.priceChanged()
    }
    
    @IBAction
    private func touchedPriceTxtField(_ sender: Any) {
        scPriceLabel.textColor = .orange
    }
    
    @IBAction
    private func priceTxtFieldChanged(_ sender: Any) {
        presenter.priceChanged()
    }
    
    @objc
    private func dismissKeyboard() {
        scPriceLabel.textColor = .systemGray
        view.endEditing(true)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardSizeHeight = keyboardSize.height
            wholePriceViewBottomConstraint.constant += keyboardSizeHeight
            wholePriceView.layoutIfNeeded()
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if wholePriceView.frame.origin.y != wholePriceFrame.y {
            wholePriceViewBottomConstraint.constant -= keyboardSizeHeight
            wholePriceView.layoutIfNeeded()
        }
    }

}

extension InputPriceViewController: InputPriceProtocol {
 
    var priceField: String? {
        get {
            return priceTxtField.text
        }
        set {
            priceTxtField.text = newValue
            if let newValue {
                if let selectedRange = priceTxtField.selectedTextRange {
                    let cursorPosition = priceTxtField.offset(from: priceTxtField.beginningOfDocument, to: selectedRange.start)
                    if cursorPosition != newValue.count - 1, let position = priceTxtField.position(from: priceTxtField.beginningOfDocument, offset: newValue.count - 2) {
                        priceTxtField.selectedTextRange = priceTxtField.textRange(from: position, to: position)
                    }
                }
            }
    
        }
    }
    
    var comissionField: String? {
        get {
            return comissionLbl.text
        }
        set {
            if let newValue {
                comissionLbl.text = "\(newValue) sc comission"
            } else {
                comissionLbl.text = "0 sc comission"
            }
        }
    }
    
    var wholePrice: String {
        get {
            return wholePriceLbl.text ?? "0 sc"
        }
        set {
            wholePriceLbl.text = "\(newValue) sc"
        }
    }
    
    var errorField: String? {
        get {
            errorLbl.text
        }
        set {
            errorLbl.text = newValue
        }
    }
    
    var balanceValue: Double {
        balance
    }
    
    func presentWalletData(data: [WalletModelCell]) {
        balances = data
        showWalletData()
    }
    
    func goToPostContract(price: Double?, comission: Double?) {
        if let delegateObget = inputPriceDelegate {
            delegateObget.sendPrice(price: price, comission: comission, pageNumber: pageNumber)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension InputPriceViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        pageControl.currentPage = pageNumber
        balance = balances[pageNumber].balance ?? 0
    }
    
}
