//
//  PlanTableViewCell.swift
//  OnTime
//
//  Created by Atom on 16/5/13.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class PlanTableViewCell: UITableViewCell {

    var planIndex:Int!
    
    @IBOutlet weak var activityIcon: UILabel!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var checkInBtn: UIButton!{
        didSet{
            checkInBtn.adjustsImageWhenHighlighted = false
        }
    }
 
    @IBAction func onTouchCheckInBtn(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("onTouchPlanCellCheckInBtn", object: ["planIndex":self.planIndex])
    }
    
    @IBOutlet weak var bgView: UIView!{
        didSet{
            bgView.layer.cornerRadius = 8
            bgView.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
   
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
