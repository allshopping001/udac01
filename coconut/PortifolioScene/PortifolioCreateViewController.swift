//
//  PortifolioViewController.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import CoreData

class PortifolioCreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Outlets
    @IBOutlet weak var labelIcon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var coinInput: UITextField!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var selectCoin: UITextField!
    @IBOutlet weak var uiPicker: UIPickerView!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalInput: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewBottomContraint: NSLayoutConstraint!
    
    // Properties
    let scrollView = UIScrollView()
    var portifolioTag = Int()
    var itemsFetched = [APIRaw]()
    var backgroundViewContext : NSManagedObjectContext!
    var sharedViewContext: NSManagedObjectContext!
    var portifolioListSelected : PortifolioList!
    var optionSelected: String?
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        viewControllerConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewControllerConfiguration()
        addObservers()
        fetchRequest()
        optionSelected = UserDefaults.standard.string(forKey: "optionSelected")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
 
    
    // MARK: - Data Source Methods (UIPicker)
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsFetched.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let iconString = ConvertSymbol(symbolString: itemsFetched[row].fromSymbol!)
        return iconString.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCoin.text = itemsFetched[row].fromSymbol
        amountLabel.text = itemsFetched[row].fromSymbol
        let currency = ConvertOption(optionSelected!)
        priceLabel.text = currency.toCurrency
        totalLabel.text = currency.toCurrency
        let iconString = ConvertSymbol(symbolString: itemsFetched[row].fromSymbol!)
        labelIcon.image = iconString.image
        label.text = itemsFetched[row].fromSymbol
        amountLabel.textColor = UIColor.black
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.uiPicker.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Save to Coredata
    @IBAction func save(_ sender: Any) {
        let portifolio = Portifolio(context: backgroundViewContext)
        portifolio.coin = selectCoin.text!
        portifolio.amount = Double(amountInput.text!)!
        portifolio.price = Double(priceInput.text!)!
        portifolio.total = Double(totalInput.text!)!
        let convertedOptionSelected = ConvertOption(optionSelected!)
        portifolio.currency = convertedOptionSelected.toCurrency
        portifolioListSelected.addToPortifolio(portifolio)
        try? backgroundViewContext.save()
        dismissEditPortifolio(self)
    }
    
    // Sum Total Value From Text Inputs
    @IBAction func sumTotal(_ sender: Any) {
        guard let amountInput = amountInput.text else {return}
        guard let priceInput = priceInput.text else {return}
        guard let amount = Double(amountInput) else {return}
        guard let price = Double(priceInput) else {return}
        let total = amount * price
        let totalText = String(total)
        totalInput.text = totalText
    }
    
    // Dismiss View
    @IBAction func dismissEditPortifolio(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Fetch Request for UIPicker
    
    func fetchRequest(){
        do {
            let result = try sharedViewContext.fetch(APIRaw.sortedFetchRequest)
            for data in result as [NSManagedObject]{
                itemsFetched.append(data as! APIRaw)
            }
        }catch{
            print("failed")
        }
    }
 
    
    // MARK: - View Controller Configuration
    
    func viewControllerConfiguration(){
        self.uiPicker.delegate = self
        self.uiPicker.dataSource = self
        self.coinInput.delegate = self
        self.amountInput.delegate = self
        self.priceInput.delegate = self
        
        view.backgroundColor = .clear
        stackViewBottomContraint.constant = self.view.frame.height/3
        titleView.layer.maskedCorners =  [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleView.layer.cornerRadius = 15
        titleView.layer.borderWidth = 0.5
        bottomView.layer.maskedCorners =  [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bottomView.layer.cornerRadius = 10
        bottomView.layer.borderWidth = 0.5
        priceLabel.textColor = UIColor.black
        totalLabel.textColor = UIColor.black
        self.totalInput.isUserInteractionEnabled = false
        self.uiPicker.isHidden = true
        self.addToolBar(textField: self.amountInput)
        self.addToolBar(textField: self.priceInput)
        
        //Blur Effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])
    }
    
    //MARK: - Observers
    
    // Remove Observers
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // Add Observers
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate(_:)), name:UIDevice.orientationDidChangeNotification, object: nil)
    }
}

//MARK: - Text Field Delegate

extension PortifolioCreateViewController: UITextFieldDelegate {
    // Keyboard Observer Method
    // MARK: - Keyboard Constraints
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillShowNotification  {
            guard let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardSize = keyboardRect.cgRectValue
            let frameOriginY = keyboardSize.height - stackViewBottomContraint.constant
            view.frame.origin.y = -frameOriginY
            
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillHideNotification  {
            view.frame.origin.y = 0
        }
    }
    
    @objc func deviceDidRotate (_ notification: NSNotification) {
        if notification.name ==  UIDevice.orientationDidChangeNotification {
            stackViewBottomContraint.constant = view.frame.height/3
        }
    }
    
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignIfFirstResponder(textField)
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.uiPicker.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var bool = Bool()
        switch textField{
        case  coinInput :
            UIView.animate(withDuration: 0.3, animations: {
                self.uiPicker.isHidden = !self.uiPicker.isHidden
                self.view.layoutIfNeeded()
            }, completion: nil)
            bool = false
        default:
            bool = true
        }
        return bool
    }
 
}

//MARK: - Create Toolbar

extension PortifolioCreateViewController {
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
    
    @objc func cancelPressed() {
        view.endEditing(true) // or do something
    }
}






