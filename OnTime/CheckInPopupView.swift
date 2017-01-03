//
//  CheckInPopupView.swift
//  OnTime
//
//  Created by Atom on 16/5/13.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class CheckInPopupView: UIView {

    @IBOutlet weak var imageVIew: UIImageView!
    
    @IBOutlet weak var closeBtn: UIButton!{
        didSet{
            closeBtn.layer.cornerRadius = 8
        }
    }
    
    @IBAction func onTouchCloseBtn(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("onTouchCheckInPopupViewCloseBtn", object: nil)
    }
    
    @IBAction func onTouchCheckInBtn(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("onTouchCheckInPopupViewCheckInBtn", object: nil)
    }
    
    @IBOutlet weak var checkInWindowView: UIView!{
        didSet{
            
            checkInWindowView.layer.cornerRadius = 8
            
            let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
            
            checkInWindowView.layer.shadowRadius = 12
            checkInWindowView.layer.shadowColor = CGColorCreate(colorSpace, [CGFloat]([0,0,0,1]))!
            checkInWindowView.layer.shadowOpacity = 0.5
            checkInWindowView.layer.shadowOffset = CGSizeMake(6, 6)
        }
    }
    
    @IBOutlet weak var guaranteeTextField: UITextField!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
