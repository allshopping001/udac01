//
//  SegmentControlView.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit

@IBDesignable
class SegmentControlView: UIControl {
    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0
    
    @IBInspectable
    var colorBackGround: UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
            updateView()
        }
    }
    
    @IBInspectable
    var commaSeparatedButtonTitles: String = ""{
        didSet{
            updateView()
        }
    }
    @IBInspectable
    var borderWidth: CGFloat = 0.5{
        didSet{
            layer.borderWidth = borderWidth
            updateView()
        }
    }
    
    @IBInspectable
    var textColor : UIColor = .black{
        didSet{
            updateView()
        }
    }
    @IBInspectable
    var selectorColor : UIColor = .darkGray{
        didSet{
            updateView()
        }
    }
    @IBInspectable
    var selectorTextColor : UIColor = .white{
        didSet{
            updateView()
        }
    }
    
    fileprivate func configureSelector(_ buttonTitles: [String]) {
        let selectorWidth = self.frame.width / CGFloat(buttonTitles.count)
        selector = UIView(frame: CGRect(x: 0.0, y: 0.0, width: selectorWidth, height: frame.height))
        selector.layer.cornerRadius = frame.height / 2
        selector.backgroundColor = selectorColor
        let selectorStartPosition = frame.width/CGFloat(buttons.count) * CGFloat(selectedSegmentIndex)
        self.selector.frame.origin.x = selectorStartPosition
        addSubview(selector)
    }
    
    fileprivate func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
    
    func updateView(){
        addObservers()
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        let buttonTitles = commaSeparatedButtonTitles.components(separatedBy: ",")
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            buttons.append(button)
        }
        
        configureSelector(buttonTitles)
        
        configureStackView()
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height/2
        selector.isHidden = true
        layer.backgroundColor = colorBackGround.cgColor
    }

    @objc func buttonTapped(sender: UIButton){
        selector.isHidden = false
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                selectedSegmentIndex = buttonIndex
                let selectorStartPosition = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selector.frame.origin.x = selectorStartPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        sendActions(for: .valueChanged)
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate(_:)), name:UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func deviceDidRotate (_ notification: NSNotification) {
        if notification.name ==  UIDevice.orientationDidChangeNotification {
            updateView()
        }
    }
}
