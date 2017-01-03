//
//  PlanSetViewTimeSetCell.swift
//  OnTime
//
//  Created by Atom on 16/5/13.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class PlanSetViewTimeSetCell: UITableViewCell {

    @IBOutlet weak var timeSetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //timeSetLabel.text = "未设置"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
