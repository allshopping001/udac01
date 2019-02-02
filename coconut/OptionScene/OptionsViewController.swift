//
//  OptionsViewController.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit

protocol optionViewDelegate {
    func setOption(with string: String)
}

class OptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var returnButtonView: UIButton!
    // Outlets
    @IBOutlet weak var navigationBackground: UINavigationItem!
    @IBOutlet weak var navigationButton: UIBarButtonItem!
    @IBOutlet weak var optionsTableView: UITableView!
    
    // Properties
    var delegate: optionViewDelegate?
    let optionsItems = ["en_US", "pt_BR", "en_UK", "zh_CN", /*"ja_JP*/ "de_DE", "btc_BTC", "eth_ETH"]
    let optionLabels = ["Dollar", "Real", "Libra","Renminbi", /*"Iene"*/ "Euro", "Bitcoin", "Ethereum"]
   
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfiguration()
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
    }
    
    // MARK: - Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell", for: indexPath) as? OptionTableViewCell else {fatalError()}
        cell.accessoryType = .none
        let item = optionLabels[indexPath.row]
        cell.cellLabel.text = item
        let cellItem = ConvertOption(optionsItems[indexPath.row])
        cell.cellImage.image = cellItem.imageOnCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passDataBackwards(optionsItems[indexPath.row])
        UserDefaults.standard.set(optionsItems[indexPath.row], forKey: "optionSelected")
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? OptionTableViewCell
        cell?.accessoryType = .none
        cell?.contentView.backgroundColor = UIColor.yellow
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != self {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func passDataBackwards(_ string: String) {
        delegate?.setOption(with: string)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - View Controller Configuration
    
    func viewConfiguration(){
        returnButtonView.layer.maskedCorners =  [.layerMaxXMinYCorner]
        returnButtonView.layer.cornerRadius = 10
        returnButtonView.layer.borderWidth = 0.5

        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor : UIColor.black,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)
            ]
        navigationButton.setTitleTextAttributes(strokeTextAttributes, for: .normal)
    }
}
