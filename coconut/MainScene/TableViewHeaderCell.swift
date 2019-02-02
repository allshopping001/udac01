//
//  TableViewHeaderCell.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit

class TableViewHeaderCell: UITableViewCell {

    @IBOutlet weak var dateLabelView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconLabel: UIImageView!
    var timer = Timer()

    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabelView.layer.borderWidth = 0.5
        timer = Timer.scheduledTimer(timeInterval: 1.0,
            target: self,
            selector: #selector(clockTick),
            userInfo: nil,
            repeats: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Run Clock
    @objc func clockTick() {
        dateLabel.text = DateFormatter.localizedString(from: Date(),dateStyle: .medium ,timeStyle: .medium)
        
    }

}
