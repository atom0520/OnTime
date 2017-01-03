//
//  PlanSetViewActivitySetCell.swift
//  OnTime
//
//  Created by Atom on 16/5/13.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class PlanSetViewActivitySetCell: UITableViewCell {

    @IBOutlet weak var getUpActivityBtn: UIButton!
    @IBOutlet weak var breakfastActivityBtn: UIButton!
    @IBOutlet weak var lunchActivityBtn: UIButton!
    @IBOutlet weak var dinnerActivityBtn: UIButton!
    @IBOutlet weak var sleepActivityBtn: UIButton!
    @IBOutlet weak var etcActivityBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
