//
//  TimeSetView.swift
//  OnTime
//
//  Created by Atom on 16/5/13.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class TimeSetView: UIView, UIPickerViewDelegate,UIPickerViewDataSource{

    var hourTitles:[String] = []
    var minuteTitles:[String] = []

   
    @IBOutlet weak var hourPickerView: UIPickerView!{
        didSet{
            hourPickerView.delegate = self
            hourPickerView.dataSource = self
            
            let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
            
            hourPickerView.layer.shadowRadius = 12
            hourPickerView.layer.shadowColor = CGColorCreate(colorSpace, [CGFloat]([0,0,0,1]))!
            hourPickerView.layer.shadowOpacity = 0.5
            hourPickerView.layer.shadowOffset = CGSizeMake(6, 6)
            
            hourPickerView.layer.cornerRadius = 8
            
        }
    }
    
    @IBOutlet weak var minutePickerView: UIPickerView!{
        didSet{
            minutePickerView.delegate = self
            minutePickerView.dataSource = self
            
            let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
            
            minutePickerView.layer.shadowRadius = 12
            minutePickerView.layer.shadowColor = CGColorCreate(colorSpace, [CGFloat]([0,0,0,1]))!
            minutePickerView.layer.shadowOpacity = 0.5
            minutePickerView.layer.shadowOffset = CGSizeMake(6, 6)
            
            minutePickerView.layer.cornerRadius = 8
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == hourPickerView){
            return hourTitles.count
        }
        else if(pickerView == minutePickerView){
            return minuteTitles.count
        }else{
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == hourPickerView){
            return hourTitles[row]
        }
        else if(pickerView == minutePickerView){
            return minuteTitles[row]
        }else{
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == hourPickerView){
//            switch( hourTitles[row] ){
//                case "07":
//                    minuteTitles = []
//                    for i in 0...60{
//                        minuteTitles.append(String.init(format: "%02d", i))
//                    }
//                    minutePickerView.reloadAllComponents()
//                break
//                case "08":
//                    minuteTitles = []
//                    for i in 0...30{
//                        minuteTitles.append(String.init(format: "%02d", i))
//                    }
//                    minutePickerView.reloadAllComponents()
//                break
//            default:
//                break
//            }
           
        }
        else if(pickerView == minutePickerView){
            
        }else{
            
        }
    }
    
    func refreshPickerViews(){
        self.hourPickerView.reloadAllComponents()
        self.minutePickerView.reloadAllComponents()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
  
}


