//
//  PatternSetView.swift
//  OnTime
//
//  Created by Atom on 16/5/12.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class PatternSetView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let pickerViewTitles:[String] = ["每日","工作日","周末"]
    
    @IBOutlet weak var patternPickerView: UIPickerView!{
        didSet{
            patternPickerView.delegate = self
            patternPickerView.dataSource = self
            
            let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
           
            patternPickerView.layer.shadowRadius = 12
            patternPickerView.layer.shadowColor = CGColorCreate(colorSpace, [CGFloat]([0,0,0,1]))!
            patternPickerView.layer.shadowOpacity = 0.5
            patternPickerView.layer.shadowOffset = CGSizeMake(6, 6)
            
            patternPickerView.layer.cornerRadius = 8
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewTitles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewTitles[row]
    }
}
