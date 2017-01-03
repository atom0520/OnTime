//
//  ClockView.swift
//  OnTime
//
//  Created by Atom on 16/5/17.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class ClockView: UIView {
    let dialView:ClockDialView!
    let hourHandView:ClockHandView!
    let minuteHandView:ClockHandView!
    let secondHandView:ClockHandView!
    
    let centerPointView: ClockCenterPointView!
    
    let clockRadiusToClockViewSideLengthRatio:CGFloat
    
    var centerPoint: CGPoint
    var clockRadius:CGFloat

    var timer:NSTimer! = nil
    
    struct constant {
        static let hourHandLengthToClockRadiusRatio:CGFloat = 0.6
        static let minuteHandLengthToClockRadiusRatio:CGFloat = 0.9
        static let secondHandLengthToClockRadiusRatio:CGFloat = 0.8
        static let clockCenterPointRadius:CGFloat = 2.5
    }
    
    init(frame: CGRect,clockRadius:CGFloat,bgColor:UIColor) {
        self.clockRadius = clockRadius
        self.clockRadiusToClockViewSideLengthRatio = clockRadius/min(frame.width,frame.height)
        
        self.centerPoint = CGPointMake(frame.size.width/2, frame.size.height/2)
        
        dialView = ClockDialView.init(
            frame: CGRect(
                x: centerPoint.x-self.clockRadius,
                y: centerPoint.y-self.clockRadius,
                width: self.clockRadius*2,
                height: self.clockRadius*2),
            clockRadius:self.clockRadius
        )
        
        hourHandView = ClockHourHandView.init(
            frame:CGRect(
                x: centerPoint.x-self.clockRadius,
                y: centerPoint.y-self.clockRadius,
                width: self.clockRadius*2,
                height: self.clockRadius*2),
            handLength: self.clockRadius*constant.hourHandLengthToClockRadiusRatio)
        
        minuteHandView = ClockMinuteHandView.init(
            frame:CGRect(
                x: centerPoint.x-self.clockRadius,
                y: centerPoint.y-self.clockRadius,
                width: self.clockRadius*2,
                height: self.clockRadius*2),
            handLength: self.clockRadius*constant.minuteHandLengthToClockRadiusRatio)
        
        secondHandView = ClockSecondHandView.init(
            frame:CGRect(
                x: centerPoint.x-self.clockRadius,
                y: centerPoint.y-self.clockRadius,
                width: self.clockRadius*2,
                height: self.clockRadius*2),
            handLength: self.clockRadius*constant.secondHandLengthToClockRadiusRatio)
        
        centerPointView = ClockCenterPointView.init(
            frame: CGRect(
                x: centerPoint.x-constant.clockCenterPointRadius,
                y: centerPoint.y-constant.clockCenterPointRadius,
                width: 2*constant.clockCenterPointRadius,
                height: 2*constant.clockCenterPointRadius))
        
        timer = nil
        
        super.init(frame: frame)
        
        self.backgroundColor = bgColor
        
        self.addSubview(dialView)
        
        secondHandView.alpha = 0.75
        self.addSubview(secondHandView)
        
        minuteHandView.alpha = 0.75
        self.addSubview(minuteHandView)
        
        hourHandView.alpha = 0.75
        self.addSubview(hourHandView)
        
        centerPointView.alpha = 0.75
        self.addSubview(centerPointView)
        
        self.setTimer()
        self.updateHands()
        self.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.New, context: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateHands"), userInfo: nil, repeats: true)
    }
    
    func updateHands(){

        let hour = CGFloat(TimeManager.getInstance().getCurrentTime()["hour"]!)
        let minute = CGFloat(TimeManager.getInstance().getCurrentTime()["minute"]!)
        let second = CGFloat(TimeManager.getInstance().getCurrentTime()["second"]!)
        
        let angleOfHourHand = ((hour%12) + (minute+second/60.0)/60.0) * 30.0
        let angleOfMinuteHand = (minute + second/60.0) * 6.0
        let angleOfSecondHand = second * 6.0
        
        hourHandView.angle = CGFloat(angleOfHourHand)
        minuteHandView.angle = CGFloat(angleOfMinuteHand)
        secondHandView.angle = CGFloat(angleOfSecondHand)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "bounds"){
            
            self.clockRadius = self.clockRadiusToClockViewSideLengthRatio * min(self.frame.size.width,self.frame.size.height)
            self.centerPoint = CGPointMake(frame.size.width/2, frame.size.height/2)
            
            self.dialView.frame =
                CGRect(
                    x: centerPoint.x-self.clockRadius,
                    y: centerPoint.y-self.clockRadius,
                    width: self.clockRadius*2,
                    height: self.clockRadius*2)
            
            self.hourHandView.frame =
                CGRect(
                x: centerPoint.x-self.clockRadius,
                y: centerPoint.y-self.clockRadius,
                width: self.clockRadius*2,
                height: self.clockRadius*2)
            
            self.minuteHandView.frame = CGRect(
                x: centerPoint.x-self.clockRadius,
                y: centerPoint.y-self.clockRadius,
                width: self.clockRadius*2,
                height: self.clockRadius*2)
            
            self.secondHandView.frame = CGRect(
                x: centerPoint.x-self.clockRadius,
                y: centerPoint.y-self.clockRadius,
                width: self.clockRadius*2,
                height: self.clockRadius*2)
            
            self.centerPointView.frame =
                CGRect(x: self.centerPoint.x - constant.clockCenterPointRadius,
                       y: self.centerPoint.y - constant.clockCenterPointRadius,
                       width: 2*constant.clockCenterPointRadius,
                       height: 2*constant.clockCenterPointRadius)
            
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        // Drawing code

//    }
 
    
}

class ClockCenterPointView:UIView{
    var centerPoint: CGPoint
    var radius:CGFloat
    
    override init(frame: CGRect) {
        centerPoint = CGPointMake(frame.size.width/2, frame.size.height/2)
        radius = min(frame.size.width/2,frame.size.height/2)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let path = CGPathCreateMutable()
        
        CGPathAddArc(path, nil, centerPoint.x, centerPoint.y, radius, 0, CGFloat(2*M_PI), false)
        
        let c = UIGraphicsGetCurrentContext()
        
        CGContextSetStrokeColorWithColor(c!, UIColor(white: 1.0, alpha: 1.0).CGColor)
        CGContextSetFillColorWithColor(c!,UIColor(white: 1.0, alpha: 1.0).CGColor)
        CGContextSetLineWidth(c!, 2.0)
        
        CGContextAddPath(c!, path)
        
        CGContextDrawPath(c!, CGPathDrawingMode.FillStroke)

    }
}


