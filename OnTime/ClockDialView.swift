//
//  ClockDialView.swift
//  OnTime
//
//  Created by Atom on 16/5/17.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit
import CoreText

class ClockDialView: UIView {
    struct constant{
        static let lineWidth:CGFloat = 2.0
    }
    
    var clockRadius:CGFloat
    var centerPoint:CGPoint
    
    var clockRadiusToClockDialViewSideLengthRatio:CGFloat
    
    init(frame: CGRect, clockRadius:CGFloat) {
    //override init(frame: CGRect) {
        self.clockRadius = clockRadius
        self.centerPoint = CGPointMake(frame.size.width/2, frame.size.height/2)
        self.clockRadiusToClockDialViewSideLengthRatio = clockRadius/min(frame.width,frame.height)
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        self.clockRadius = min(self.frame.width,self.frame.height)*self.clockRadiusToClockDialViewSideLengthRatio
        self.centerPoint = CGPointMake(self.frame.width/2, self.frame.height/2)
        
        let edgeSpace:CGFloat = 4.0
        let heightOfHourScale:CGFloat = 16.0
        let heightOfMinuteScale:CGFloat = 8.0
        
        //绘制钟面背景
        let bgColor = UIColor.init(red: 232/255.0, green: 221/255.0, blue: 203/255.0, alpha: 1.0)
        
        let path = CGPathCreateMutable()
        
        CGPathAddArc(path, nil, centerPoint.x, centerPoint.y, clockRadius-constant.lineWidth, 0, CGFloat(2*M_PI), false)
        
        let c = UIGraphicsGetCurrentContext()
    
        CGContextSetStrokeColorWithColor(c!, UIColor(white: 0, alpha: 1.0).CGColor)
        CGContextSetFillColorWithColor(c!,bgColor.CGColor)
        CGContextSetLineWidth(c!, constant.lineWidth)
        
        CGContextAddPath(c!, path)
        
        CGContextDrawPath(c!, CGPathDrawingMode.FillStroke)
        
        //绘制小时刻度及小时数字
        CGContextSetStrokeColorWithColor(c!, UIColor(white: 0, alpha: 1.0).CGColor)
        
        CGContextSetLineWidth(c!, 2.5)
        
        
        let spacingAngleOfHourScale:CGFloat = 30.0
        
        CGContextScaleCTM(c!, 1, -1);
        CGContextTranslateCTM(c!, 0, -rect.size.height);
        
        for (var i:Int = 0; i<12; i += 1) {
            
            let radian = TransformToRadian(spacingAngleOfHourScale * CGFloat(i));
            
            //字体大小
            let fontSize:CGFloat = 20.0;
            
            //t 为数字与刻度之间的间隔
            let distanceBetweenNumAndScale:CGFloat = 14.0
            
            let p1 = CGPointMake(centerPoint.x + (clockRadius - edgeSpace)*sin(radian), centerPoint.y + (clockRadius - edgeSpace) * cos(radian));
            
            let p2 = CGPointMake(centerPoint.x + (clockRadius - edgeSpace - heightOfHourScale)*sin(radian), centerPoint.y + (clockRadius - edgeSpace - heightOfHourScale) * cos(radian));
            
            CGContextMoveToPoint(c!, p1.x, p1.y);
            CGContextAddLineToPoint(c!, p2.x, p2.y);
        
            CGContextSaveGState(c!);
        
            let hourNumStr = NSString.init(format: "%d", i==0 ? 12 : i)
            
            CGContextSetTextMatrix(c!, CGAffineTransformIdentity)
            CGContextTranslateCTM(c!, 0, self.bounds.size.height)
            CGContextScaleCTM(c!, 1.0, -1.0)
            
            let p3 = CGPointMake(centerPoint.x + (clockRadius - edgeSpace - heightOfHourScale - distanceBetweenNumAndScale)*sin(radian),
                                 centerPoint.y - (clockRadius - edgeSpace - heightOfHourScale - distanceBetweenNumAndScale) * cos(radian));
            let p4 = CGPointMake(p3.x - CGFloat(hourNumStr.length) * fontSize/4 , p3.y - fontSize/3)
            
            let hourNumFont = UIFont.boldSystemFontOfSize(fontSize)
            
            hourNumStr.drawAtPoint(CGPoint(x: p4.x, y: p4.y),withAttributes:  [NSFontAttributeName:hourNumFont,NSForegroundColorAttributeName:UIColor.blackColor(),NSWritingDirectionAttributeName:[NSWritingDirection.LeftToRight.rawValue | NSTextWritingDirection.Override.rawValue]])
            
            //CGContextSetTextDrawingMode(c, CGTextDrawingMode.Fill)

            CGContextRestoreGState(c!);
            
        }
        CGContextDrawPath(c!, CGPathDrawingMode.FillStroke)
        
        //绘制分钟刻度
        CGContextSetStrokeColorWithColor(c!, UIColor(white: 0, alpha: 1.0).CGColor)
        CGContextSetLineWidth(c!, 0.5)
        let spacingAngleOfMinuteScale:CGFloat = 6.0
        
        for(var i:Int = 0; i<60; i+=1) {
            
            let radian:CGFloat = TransformToRadian(spacingAngleOfMinuteScale * CGFloat(i))
            
            let p1 = CGPointMake(centerPoint.x + (clockRadius - edgeSpace)*sin(radian), centerPoint.y - (clockRadius - edgeSpace) * cos(radian));
            
            let p2 = CGPointMake(centerPoint.x + (clockRadius - edgeSpace - heightOfMinuteScale)*sin(radian), centerPoint.y - (clockRadius - edgeSpace - heightOfMinuteScale) * cos(radian));
            
            CGContextMoveToPoint(c!, p1.x, p1.y);
            CGContextAddLineToPoint(c!, p2.x, p2.y);
            
        }
        
        CGContextDrawPath(c!, CGPathDrawingMode.FillStroke)
        
    }
 

}
