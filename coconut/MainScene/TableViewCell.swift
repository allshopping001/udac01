//
//  TableViewCell.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // Properties
    let formatter = Formatters()
    var optionSelected = String()
    
    var isExpanded : Bool = false {
        didSet {
            toggle()
        }
    }
    
    // Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var collapsedLabel: UILabel!
    @IBOutlet weak var collapsedLabelPercent: UILabel!
    @IBOutlet weak var collapsedSubtitle: UILabel!
    @IBOutlet weak var loadDetailButton: UIButton!
    @IBOutlet weak var collapsedView: UIView!
    @IBOutlet weak var expandedLabel: UILabel!
    @IBOutlet weak var expandedLabel1: UILabel!
    @IBOutlet weak var expandedLabel2: UILabel!
    @IBOutlet weak var expandedView: UIView!
    @IBOutlet weak var imagePercentView: UIImageView!
    @IBOutlet weak var expandedTitle2: UILabel!
    @IBOutlet weak var expandedTitle1: UILabel!
    @IBOutlet weak var expandedTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    
    // MARK: - Configuration Collapsed Label
    
    var setCollapsedLabel: APIDisplay! {
        didSet{
            collapsedLabel.text = setCollapsedLabel.price
            collapsedLabelPercent.text = setCollapsedLabel.changePCT24h! + "%"
            collapsedSubtitle.text = setCollapsedLabel.fromSymbol
            DispatchQueue.main.async {
                let iconString = ConvertSymbol(symbolString: self.setCollapsedLabel.fromSymbol ?? "symbol")
                self.icon.image = iconString.image
            }
        }
    }
    
    // MARK: - Configuration Expanded Label
    
    var setExpandedLabel: APIDisplay! {
        didSet{
            expandedTitle.text = "Open 24h:"
            expandedTitle1.text = "Low 24h:"
            expandedTitle2.text = "High 24h:"
            
            expandedLabel.text =  setExpandedLabel.open24h
            expandedLabel1.text = setExpandedLabel.low24h
            expandedLabel2.text =  setExpandedLabel.high24h
            DispatchQueue.main.async {
                let iconString = ConvertSymbol(symbolString: self.setCollapsedLabel.fromSymbol ?? "symbol")
                self.nameLabel.text = iconString.name
            }
            
        }
    }
 
    // MARK: - Cell Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    // MARK: - Toggle Cells
    
    func toggle(){
        if isExpanded == false {
            UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .calculationModePaced, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                    self.expandedView.isHidden = true
                    self.expandedLabel.alpha = 0.5
                })
            }, completion:nil)
        }
        if isExpanded == true {
            UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .calculationModePaced, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                    self.expandedView.isHidden = false
                    self.expandedLabel.alpha = 1
                })
            }, completion: nil)
        }
    }
}

