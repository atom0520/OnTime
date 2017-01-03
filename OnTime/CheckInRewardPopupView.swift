//
//  CheckInRewardPopupView.swift
//  OnTime
//
//  Created by Atom on 16/5/13.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class CheckInRewardPopupView: UIView {

    @IBOutlet weak var rewardWindowView: UIView!{
        didSet{
            
            rewardWindowView.layer.cornerRadius = 8
           
            let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
            rewardWindowView.layer.shadowRadius = 12
            rewardWindowView.layer.shadowColor = CGColorCreate(colorSpace, [CGFloat]([0,0,0,1]))!
            rewardWindowView.layer.shadowOpacity = 0.5
            rewardWindowView.layer.shadowOffset = CGSizeMake(6, 6)
        }
    }
    
    @IBOutlet weak var healthPromotionLabel: UILabel!
    @IBOutlet weak var happinessPromotionLabel: UILabel!
    @IBOutlet weak var glamourPromotionLabel: UILabel!
    
    @IBOutlet weak var promotionDisplayView: UIView!{
        didSet{
            promotionDisplayView.layer.cornerRadius = 8
            promotionDisplayView.layer.masksToBounds = true
            
            let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
            
            promotionDisplayView.layer.borderColor = CGColorCreate(colorSpace, [CGFloat]([0,0,1,1]))!
            promotionDisplayView.layer.borderWidth = 2
            

        }
    }
    
    @IBAction func onTouchOkBtn(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("onTouchCheckInRewardPopupViewOkBtn", object: nil)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
