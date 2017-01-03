//
//  ClockHandView.swift
//  OnTime
//
//  Created by Atom on 16/5/17.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

func TransformToRadian(angle:CGFloat) -> CGFloat{
    return angle * CGFloat(M_PI/180.0)
}

class ClockHandView: UIView {
    
    var centerPoint:CGPoint
    
    var angle:CGFloat{
        
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var handLength:CGFloat
    var handLengthToClockHandViewSideLengthRatio:CGFloat

    var longHandSegmentLengthToEntireHandLengthRatio:CGFloat
    var lineWidth:CGFloat
    var expansion:CGFloat
    var fillColor:CGColor
    var strokeColor:CGColor
   
    
    init(frame: CGRect, handLength:CGFloat) {
        self.centerPoint = CGPointMake(frame.size.width/2, frame.size.height/2)
        self.angle = 0.0
        self.handLength = handLength
        self.handLengthToClockHandViewSideLengthRatio = handLength/min(frame.width,frame.height)
    
        self.longHandSegmentLengthToEntireHandLengthRatio = 1.0
        self.expansion = 0.0
        self.lineWidth = 0.2
        self.fillColor = UIColor.init(white: 0, alpha: 1.0).CGColor
        self.strokeColor = UIColor.init(white: 0.5, alpha: 1.0).CGColor
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        self.centerPoint = CGPointMake(self.frame.width/2, self.frame.height/2)
        self.handLength = min(self.frame.width,self.frame.height)*self.handLengthToClockHandViewSideLengthRatio
        
        let p1 = CGPointMake(centerPoint.x + handLength * longHandSegmentLengthToEntireHandLengthRatio * sin(TransformToRadian(self.angle)),
                             centerPoint.y - handLength * longHandSegmentLengthToEntireHandLengthRatio * cos(TransformToRadian(self.angle)))
        let p2 = CGPointMake(centerPoint.x + expansion * sin(TransformToRadian(self.angle+90)),
                             centerPoint.y - expansion * cos(TransformToRadian(self.angle+90)))
        let p3 = CGPointMake(centerPoint.x + expansion * sin(TransformToRadian(self.angle+270)),
                             centerPoint.y - expansion * cos(TransformToRadian(self.angle+270)))
        let p4 = CGPointMake(centerPoint.x + handLength * (1-longHandSegmentLengthToEntireHandLengthRatio) * sin(TransformToRadian(self.angle+180)),
                             centerPoint.y - handLength * (1-longHandSegmentLengthToEntireHandLengthRatio) * cos(TransformToRadian(self.angle+180)))
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, p1.x, p1.y)
        
        CGPathAddLineToPoint(path, nil, p2.x, p2.y)
        CGPathAddLineToPoint(path, nil, p4.x, p4.y)
        CGPathAddLineToPoint(path, nil, p3.x, p3.y)
        CGPathAddLineToPoint(path, nil, p1.x, p1.y)
        
        let c = UIGraphicsGetCurrentContext()!
        
        CGContextSetLineWidth(c, lineWidth)
        
        CGContextSetStrokeColorWithColor(c, strokeColor)
        CGContextSetFillColorWithColor(c, fillColor)
        CGContextAddPath(c, path)
        CGContextDrawPath(c, CGPathDrawingMode.FillStroke)
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

class ClockHourHandView: ClockHandView{

    override init(frame: CGRect, handLength:CGFloat) {
        super.init(frame: frame,handLength:handLength)
        
        //self.angle = 0
        //self.handLength = handLength
        
        self.longHandSegmentLengthToEntireHandLengthRatio = 0.8
        self.expansion = 0.0
        self.lineWidth = 5.5
        
        self.fillColor = UIColor.init(white: 0, alpha: 1.0).CGColor
        self.strokeColor = UIColor.init(white: 0.1, alpha: 1.0).CGColor
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ClockMinuteHandView: ClockHandView{
    
    override init(frame: CGRect,handLength: CGFloat) {
        super.init(frame: frame,handLength:handLength)
        
        //self.angle = 0
        //self.handLength = handLength
        self.longHandSegmentLengthToEntireHandLengthRatio = 0.8
        self.expansion = 0.0
        self.lineWidth = 4.0
        self.fillColor = UIColor.init(white: 0, alpha: 1.0).CGColor
        self.strokeColor = UIColor.init(white: 0.3, alpha: 1.0).CGColor
       
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ClockSecondHandView: ClockHandView{
    
    override init(frame: CGRect, handLength:CGFloat) {
        super.init(frame: frame,handLength:handLength)
        
        //self.angle = 0
        //self.handLength = handLength
        self.longHandSegmentLengthToEntireHandLengthRatio = 0.8
        self.expansion = 0.0
        self.lineWidth = 2.5
        self.fillColor = UIColor(red: 188/255.0, green: 8/255.0, blue: 18/255.0, alpha: 1.0).CGColor
        self.strokeColor = self.fillColor
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        self.centerPoint = CGPointMake(self.frame.width/2.0, self.frame.height/2.0)
        self.handLength = min(self.frame.width,self.frame.height)*self.handLengthToClockHandViewSideLengthRatio
        
        let p1 = CGPointMake(centerPoint.x + handLength * longHandSegmentLengthToEntireHandLengthRatio * sin(TransformToRadian(self.angle)),
                             centerPoint.y - handLength * longHandSegmentLengthToEntireHandLengthRatio * cos(TransformToRadian(self.angle)))
        let p2 = CGPointMake(centerPoint.x + expansion * sin(TransformToRadian(self.angle+90)),
                             centerPoint.y - expansion * cos(TransformToRadian(self.angle+90)))
        let p3 = CGPointMake(centerPoint.x + expansion * sin(TransformToRadian(self.angle+270)),
                             centerPoint.y - expansion * cos(TransformToRadian(self.angle+270)))
        let p4 = CGPointMake(centerPoint.x + handLength * (1-longHandSegmentLengthToEntireHandLengthRatio) * sin(TransformToRadian(self.angle+180)),
                             centerPoint.y - handLength * (1-longHandSegmentLengthToEntireHandLengthRatio) * cos(TransformToRadian(self.angle+180)))
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, p1.x, p1.y)
        
        CGPathAddLineToPoint(path, nil, p2.x, p2.y)
        CGPathAddLineToPoint(path, nil, p4.x, p4.y)
        CGPathAddLineToPoint(path, nil, p3.x, p3.y)
        CGPathAddLineToPoint(path, nil, p1.x, p1.y)
        
        let c = UIGraphicsGetCurrentContext()!
        
        CGContextSetStrokeColorWithColor(c, strokeColor)
        CGContextSetFillColorWithColor(c, fillColor)
        CGContextSetLineWidth(c, lineWidth)
        
        CGContextAddPath(c, path)
        CGContextDrawPath(c, CGPathDrawingMode.FillStroke)
        
        // 画秒针小球
        let pathOfTipBall = CGPathCreateMutable()
        
        let tipBallRadius:CGFloat = 6.0
        let p5 = CGPointMake(p1.x - tipBallRadius * sin(TransformToRadian(self.angle)),
                             p1.y + tipBallRadius * cos(TransformToRadian(self.angle)))
        
        CGPathAddArc(pathOfTipBall, nil, p5.x, p5.y, tipBallRadius, 0, CGFloat(2*M_PI), false)
        
        CGContextSetStrokeColorWithColor(c, strokeColor)
        CGContextSetFillColorWithColor(c,fillColor)
        CGContextSetLineWidth(c, lineWidth)
        
        CGContextAddPath(c, pathOfTipBall)
        
        CGContextDrawPath(c, CGPathDrawingMode.FillStroke)
        
        
    }
}



