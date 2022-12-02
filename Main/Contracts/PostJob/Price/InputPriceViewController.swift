//
//  InputPriceViewController.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 01.12.2022.
//

import UIKit

protocol InputPriceToMainProtocol: AnyObject {
    func sendPrice(price: Double?)
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
    
    var price: String?
    var presenter: InputPricePresenter!
    private var balances: [WalletModelCell] = []
    private var slides: [BalanceAccountView] = []
    private var wholePriceFrame = CGPoint(x: 0, y: 0)
    
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
        if let price {
            priceTxtField.text = price
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
    
    private func setupSlideScrollView() {
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: slideView.frame.width * CGFloat(i), y: 0, width: slideView.frame.width, height: slideView.frame.height)
            scrollView.addSubview(slides[i])
        }
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
    
    @IBAction
    private func changePage(_ sender: Any) {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
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
            wholePriceView.frame.origin.y -= keyboardSize.height
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if wholePriceView.frame.origin.y != wholePriceFrame.y {
            wholePriceView.frame.origin.y = wholePriceFrame.y
        }
    }

}

extension InputPriceViewController: InputPriceProtocol {
    
    var priceField: String? {
        return priceTxtField.text
    }
    
    var comission: String? {
        get {
           return ""
        }
        set {
            comissionLbl.text = newValue
        }
    }
    
    var wholePrice: String {
        get {
            return ""
        }
        set {
            wholePriceLbl.text = newValue
        }
    }
    
    func presentWalletData(data: [WalletModelCell]) {
        balances = data
        showWalletData()
    }
    
    func goToPostContract(price: Double?) {
        if let delegateObget = inputPriceDelegate {
            delegateObget.sendPrice(price: price)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension InputPriceViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
}
