//
//  PortifolioDetailTableViewCell.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import CoreData

class PortifolioDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var percentImage: UIImageView!
    
    var setCell: Portifolio! {
        didSet{
            totalValueLabel.text = String(setCell.total)
            let iconString = ConvertSymbol(symbolString: setCell.coin!)
            self.icon.image = iconString.image
            currencyLabel.text = setCell.currency
            iconLabel.text = iconString.tickerSymbol
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
