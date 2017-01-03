//
//  FaceView.swift
//  OnTime
//
//  Created by Atom on 16/5/13.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    var faceCenter:CGPoint{
        return convertPoint(center, fromView:superview)
    }
    
    var faceRadius:CGFloat{
        return min(bounds.size.width,bounds.size.height)*self.faceDiameterToViewSideLengthRatio/2
    }
    
    @IBInspectable
    var faceStrokeLineWidth:CGFloat = 3{
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var faceStrokeColor:UIColor = UIColor.blackColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var faceFillColor:UIColor = UIColor.orangeColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable
    var faceDiameterToViewSideLengthRatio:CGFloat = 0.9{
        didSet{
            setNeedsDisplay()
        }
    }
    
    private struct Constant{
       
        static let FaceRadiusToEyeRadiusYRatio:CGFloat = 8
        
        static let EyeRadiusXToEyeRadiusYRatio:CGFloat = 0.75
        static let EyeHighlightRadiusXToEyeRadiusYRatio:CGFloat = 0.2
        static let EyeHighlightRadiusYToEyeRadiusYRatio:CGFloat = 0.3
        static let EyeHighlightOffsetYToEyeRadiusYRatio:CGFloat = 0.45
        
        static let FaceRadiusToEyeOffsetRatio:CGFloat = 3.5
        static let FaceRadiusToEyeSeparationRatio:CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio:CGFloat = 1
        static let FaceRadiusToMouthHeightRatio:CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio:CGFloat = 2.5
        
        static let glamourPerGlamourLight:Int = 80
        static let noFaceDotGlamour:Int = 60
        static let glamourPerFaceDotPair:Int = 5
    }
    
    private enum Eye{
      case Left
      case Right
    }
    
    private func drawEyes(eyeColor:UIColor)
    {
        let eyeRadiusY = faceRadius/Constant.FaceRadiusToEyeRadiusYRatio
        let eyeRadiusX = eyeRadiusY*Constant.EyeRadiusXToEyeRadiusYRatio
        
        let eyeVerticalOffset = faceRadius/Constant.FaceRadiusToEyeOffsetRatio
        
        let eyeHorizontalSeparation = faceRadius/Constant.FaceRadiusToEyeSeparationRatio
        
        var leftEyeCenter = CGPoint.init(
            x: faceCenter.x-eyeHorizontalSeparation/2,
            y: faceCenter.y-eyeVerticalOffset)
        
        var rightEyeCenter = CGPoint.init(
            x: faceCenter.x+eyeHorizontalSeparation/2,
            y: faceCenter.y-eyeVerticalOffset)
        
        eyeColor.set()
        let leftEyePath = UIBezierPath.init(ovalInRect: CGRect.init(x: leftEyeCenter.x-eyeRadiusX, y: leftEyeCenter.y-eyeRadiusY, width: eyeRadiusX*2, height: eyeRadiusY*2))
        leftEyePath.lineWidth = faceStrokeLineWidth
        
        leftEyePath.stroke()
        leftEyePath.fill()
        
        let rightEyePath = UIBezierPath.init(ovalInRect: CGRect.init(x: rightEyeCenter.x-eyeRadiusX, y: rightEyeCenter.y-eyeRadiusY, width: eyeRadiusX*2, height: eyeRadiusY*2))
        rightEyePath.lineWidth = faceStrokeLineWidth
        
        rightEyePath.stroke()
        rightEyePath.fill()
        
        let pupilRadiusX = eyeRadiusY*Constant.EyeHighlightRadiusXToEyeRadiusYRatio
        let pupilRadiusY = eyeRadiusY*Constant.EyeHighlightRadiusYToEyeRadiusYRatio
        let pupilOffsetY = eyeRadiusY*Constant.EyeHighlightOffsetYToEyeRadiusYRatio
        
        let leftEyeHighlightCenter = CGPoint.init(
            x: leftEyeCenter.x,
            y: leftEyeCenter.y-pupilOffsetY)
        
        let rightEyeHighlightCenter = CGPoint.init(
            x: rightEyeCenter.x,
            y: rightEyeCenter.y-pupilOffsetY)

        UIColor.whiteColor().set()
        let leftEyeHighlightPath = UIBezierPath.init(ovalInRect: CGRect.init(x: leftEyeHighlightCenter.x-pupilRadiusX, y: leftEyeHighlightCenter.y-pupilRadiusY, width: pupilRadiusX*2, height: pupilRadiusY*2))
        
        leftEyeHighlightPath.lineWidth = faceStrokeLineWidth
        
        leftEyeHighlightPath.stroke()
        leftEyeHighlightPath.fill()
        
        let rightEyeHighlightPath = UIBezierPath.init(ovalInRect: CGRect.init(x: rightEyeHighlightCenter.x-pupilRadiusX, y: rightEyeHighlightCenter.y-pupilRadiusY, width: pupilRadiusX*2, height: pupilRadiusY*2))
        
        rightEyeHighlightPath.lineWidth = faceStrokeLineWidth
        rightEyeHighlightPath.stroke()
        rightEyeHighlightPath.fill()
    }
    
    private func drawSmile(smileDegree:Double,mouthColor:UIColor){
        let mouthWidth = faceRadius/Constant.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius/Constant.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius/Constant.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(smileDegree, 1),-1))*mouthHeight
        
        var start = CGPoint(x: faceCenter.x - mouthWidth/2,y: faceCenter.y + mouthVerticalOffset)
        start.y -= 0.25*smileHeight
        let end = CGPoint(x: start.x + mouthWidth,y:start.y)
        
        let cp1 = CGPoint(x:start.x+mouthWidth/3,y:start.y+smileHeight)
        let cp2 = CGPoint(x:end.x - mouthWidth/3,y:cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = faceStrokeLineWidth
        
        mouthColor.set()
        path.stroke()
    }
    
    func drawFace(faceColor:UIColor){
        
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = faceStrokeLineWidth
        
        self.faceStrokeColor.set()
        facePath.stroke()
        faceColor.set()
        facePath.fill()
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // Drawing code
        backgroundColor = UIColor.clearColor()
        
        let health = DataManager.getInstance().userData.health
        let happiness = DataManager.getInstance().userData.happiness
        let glamour = DataManager.getInstance().userData.glamour
        
        let faceColor:UIColor = self.getFaceColor(health)
        self.drawFace(faceColor)
        
        let eyeColor:UIColor = self.getEyeColor(health)
        self.drawEyes(eyeColor)
        
        if(glamour<=Constant.noFaceDotGlamour - Constant.glamourPerFaceDotPair){
            self.drawFaceDots(glamour)
        }
        
        if(glamour>=Constant.glamourPerGlamourLight){
            self.drawGlamourLights(glamour)
        }
        
        
        let smileDegree:Double = self.getSmileDegree(happiness)
        let mouthColor = self.getMouthColor(health)
        
        self.drawSmile(smileDegree,mouthColor: mouthColor)
       
    }
    
    func getFaceColor(health:Int)->UIColor{
        if(health>=50){
            return UIColor.init(red: (248-0.4*CGFloat(100-health))/255, green: (230-0.3*CGFloat(100-health))/255, blue: (192-0.3*CGFloat(100-health))/255, alpha: 1.0)
        }else{
            return UIColor.init(red: (248-0.4*50-0.6*CGFloat(50-health))/255, green: (230-0.3*CGFloat(100-health))/255, blue: (192-0.3*CGFloat(100-health))/255, alpha: 1.0)
        }
        
    }
    
    func getEyeColor(health:Int)->UIColor{
        return UIColor.init(red: CGFloat(100-health)/100, green: 0, blue: 0, alpha: 1.0)
    }
    
    func getSmileDegree(happiness:Int)->Double{
        return  Double(happiness-50)/50.0
    }
    
    func getMouthColor(health:Int)->UIColor{
        if(health>50){
            return UIColor.init(red: CGFloat(health+100)/200, green: CGFloat(100-health)/200, blue: CGFloat(100-health)/200, alpha: 1.0)
        }else{
            return UIColor.init(red: CGFloat(health+100)/200, green: 0.25, blue: CGFloat(100-health)/200, alpha: 1.0)
        }
    }
    
    func drawGlamourLights(glamour:Int){
        if(glamour<Constant.glamourPerGlamourLight){
            return
        }
        
        var glamourLightCenterXToFaceViewWidthRatio:CGFloat = 0
        var glamourLightCenterYToFaceViewHeightRatio:CGFloat = 0
        
        var glamourLightCenter:CGPoint = CGPoint.init(x: 0, y: 0)
        
        var glamourLightWidthToFaceRadiusRatio:CGFloat = 0
        var glamourLightWidth:CGFloat = 0
        var glamourLightHeightToGlamourLightWidthRatio:CGFloat = 0
        var glamourLightHeight:CGFloat = 0
        
        var glamourCopy:Int = glamour
        var glamourLightIndex:Int = 0

        while(true){
            glamourCopy -= Constant.glamourPerGlamourLight
            glamourLightIndex+=1
            
            if(glamourLightIndex>4 || glamourCopy<0){
                break;
            }
            switch glamourLightIndex {
            case 1:
                glamourLightCenterXToFaceViewWidthRatio = CGFloat(75+arc4random()%11)/100
                glamourLightCenterYToFaceViewHeightRatio = CGFloat(15+arc4random()%11)/100
                
                break
            case 2:
                glamourLightCenterXToFaceViewWidthRatio = CGFloat(15+arc4random()%11)/100
                glamourLightCenterYToFaceViewHeightRatio = CGFloat(75+arc4random()%11)/100
                
                break
            case 3:
                glamourLightCenterXToFaceViewWidthRatio = CGFloat(15+arc4random()%11)/100
                glamourLightCenterYToFaceViewHeightRatio = CGFloat(15+arc4random()%11)/100
                break
            case 4:
                glamourLightCenterXToFaceViewWidthRatio = CGFloat(75+arc4random()%11)/100
                glamourLightCenterYToFaceViewHeightRatio = CGFloat(75+arc4random()%11)/100
                break
            default:
                break
            }
            
            glamourLightCenter = CGPoint.init(x: self.bounds.width*glamourLightCenterXToFaceViewWidthRatio, y: self.bounds.height*glamourLightCenterYToFaceViewHeightRatio)
            
            glamourLightWidthToFaceRadiusRatio = CGFloat(45+arc4random()%11)/100
            glamourLightWidth = faceRadius * glamourLightWidthToFaceRadiusRatio
            glamourLightHeightToGlamourLightWidthRatio = CGFloat(14+arc4random()%5)/10
            glamourLightHeight = glamourLightWidth*glamourLightHeightToGlamourLightWidthRatio
            
            self.drawGlamourLight(glamourLightCenter,width: glamourLightWidth, height: glamourLightHeight)
        
        }

    }
    
    func drawGlamourLight(center:CGPoint,width:CGFloat,height:CGFloat){
        let hWidth:CGFloat = width/2.0
        let hHeight:CGFloat = height/2.0
        
        var start = CGPoint.init(x: center.x-hWidth, y: center.y)
        
        var end = CGPoint(x: start.x + hWidth,y:start.y + hHeight)
        
        var cp1 = CGPoint(x:start.x+hWidth/2.0,y:start.y)
        var cp2 = CGPoint(x:end.x,y:end.y-hHeight/2.0)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        
        start = end
        end = CGPoint(x: start.x + hWidth,y:start.y - hHeight)
        cp1 = CGPoint(x:start.x,y:start.y-hHeight/2.0)
        cp2 = CGPoint(x:end.x-hWidth/2.0,y:end.y)
       
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        
        start = end
        end = CGPoint(x: start.x - hWidth,y:start.y - hHeight)
        cp1 = CGPoint(x:start.x-hWidth/2.0,y:start.y)
        cp2 = CGPoint(x:end.x,y:end.y+hHeight/2.0)
        
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        
        start = end
        end = CGPoint(x: start.x - hWidth,y:start.y + hHeight)
        cp1 = CGPoint(x:start.x,y:start.y+hHeight/2.0)
        cp2 = CGPoint(x:end.x+hWidth/2.0,y:end.y)
        
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        
        path.lineWidth = faceStrokeLineWidth
     
        UIColor.yellowColor().set()
        
        path.fill()
    }
    
    func drawFaceDots(glamour:Int){
        if(glamour>Constant.noFaceDotGlamour-Constant.glamourPerFaceDotPair){
            return
        }
        
        var faceDotDistFromCenterToFaceRadiusRatio:CGFloat = 0
        var faceDotFromCenterRadian:Double = 0
        var faceDotRadius:CGFloat = 0
        
        var faceDotCounter:Int = 0
        var faceDotCount:Int
        
        
        faceDotCount = 2*((Constant.noFaceDotGlamour-glamour)/Constant.glamourPerFaceDotPair)
        
        faceDotCounter = faceDotCount
        
        while(true){
            faceDotCounter -= 1
            if(faceDotCounter<0){
                break
            }
            
            faceDotDistFromCenterToFaceRadiusRatio =  CGFloat(48+arc4random()%33)/100.0
            faceDotFromCenterRadian = M_PI/(Double(22+arc4random()%11)/10)
            faceDotRadius = CGFloat(2+arc4random()%2)
            
            if(faceDotCounter>=faceDotCount/2){
                self.drawFaceDot(
                    CGPoint.init(x: faceCenter.x-faceRadius*faceDotDistFromCenterToFaceRadiusRatio*CGFloat(sin(faceDotFromCenterRadian)), y: faceCenter.y+faceRadius*faceDotDistFromCenterToFaceRadiusRatio*CGFloat(cos(faceDotFromCenterRadian))), radius: faceDotRadius)
            }else{
                self.drawFaceDot(
                    CGPoint.init(x: faceCenter.x+faceRadius*faceDotDistFromCenterToFaceRadiusRatio*CGFloat(sin(faceDotFromCenterRadian)), y: faceCenter.y+faceRadius*faceDotDistFromCenterToFaceRadiusRatio*CGFloat(cos(faceDotFromCenterRadian))), radius: faceDotRadius)
            }
            
        }
        
        
    }
    
    func drawFaceDot(center:CGPoint,radius:CGFloat){
        let faceDotPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5).set()
        faceDotPath.fill()
    }
}
