//
//  FloatingCircleButton.swift
//  OnTime
//
//  Created by Atom on 16/6/9.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class FloatingCircleButton: UIButton {
    
    var hostVC:UIViewController!
    
    struct constant{
        static let minEdgeDistance:CGFloat = 40.0
        static let imageViewBoundsToSelfBoundsRatio:CGFloat = 1.0
        static let imageLabelBoundsToSelfBoundsRatio:CGFloat = 1.0
        
    }
    
    init(frame: CGRect,image:UIImage,hostVC:UIViewController) {
        
        super.init(frame: frame)
        
        imageView!.image = image
        imageView!.contentMode = .ScaleAspectFit
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(imageView!)
        
        
//        self.imageView!.translatesAutoresizingMaskIntoConstraints = false
//
//        if #available(iOS 9.0, *) {
//            
//            let widthConstraint = NSLayoutConstraint(item: imageView!, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: constant.imageViewBoundsToSelfBoundsRatio, constant: 0.0)
//            let centerXConstraint = NSLayoutConstraint(item: imageView!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
//    
//            let heightConstraint = NSLayoutConstraint(item: imageView!, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: constant.imageViewBoundsToSelfBoundsRatio, constant: 0.0)
//            let centerYConstraint = NSLayoutConstraint(item: imageView!, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
//            
//            self.addConstraints([widthConstraint,centerXConstraint,heightConstraint,centerYConstraint])
//            
//        }
//        self.autoresizesSubviews = true
        self.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.New, context: nil)

        self.hostVC = hostVC
    }
    
    init(frame: CGRect,text:String,textFontSize:CGFloat,hostVC:UIViewController) {
        
        super.init(frame: frame)
        
        //print("floating circle view titlelabel: ",self.titleLabel!)
        self.setTitle(text, forState: .Normal)
        self.setTitle(text, forState: .Selected)
        
        self.titleLabel!.hidden = false;

        
        //print("floating circle view titlelabel: ",self.titleLabel!)
      
        titleLabel!.textAlignment = NSTextAlignment.Center
        titleLabel!.adjustsFontSizeToFitWidth = false
       
        titleLabel!.font = UIFont.systemFontOfSize(textFontSize)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.addSubview(titleLabel!)
        
        //self.titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        
//        if #available(iOS 9.0, *) {
//            
//            let widthConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: constant.titleLabelBoundsToSelfBoundsRatio, constant: 0.0)
//            
//            let centerXConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
//            
//            let heightConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: constant.titleLabelBoundsToSelfBoundsRatio, constant: 0.0)
//            
//            let centerYConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
//            
//            self.addConstraints([widthConstraint,centerXConstraint,heightConstraint,centerYConstraint])
//            
//        }
        self.autoresizesSubviews = true
        self.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.New, context: nil)
        
        self.hostVC = hostVC
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "bounds"){
            
            if(self.imageView != nil){
                self.imageView!.bounds = CGRectMake(0, 0, self.bounds.width*constant.imageViewBoundsToSelfBoundsRatio, self.bounds.height*constant.imageViewBoundsToSelfBoundsRatio)
                self.imageView!.center = CGPoint(x: self.bounds.width/2,y: self.bounds.height/2)
            }
            
            if(self.titleLabel != nil){
                self.titleLabel!.bounds = CGRectMake(0, 0, self.bounds.width*constant.imageLabelBoundsToSelfBoundsRatio, self.bounds.height*constant.imageLabelBoundsToSelfBoundsRatio)
                self.titleLabel!.center = CGPoint(x: self.bounds.width/2,y: self.bounds.height/2)
            }
            
        }
        
    }

    func onTapDismiss(tapGestureRecognizer:UITapGestureRecognizer){
       self.hostVC.dismissViewControllerAnimated(true, completion: nil)
       
    }
    
    func viewDidLayoutSubviews(){
        
    }
    
    func onPan(panGestureRecognizer:UIPanGestureRecognizer){
        var point:CGPoint = panGestureRecognizer.locationInView(UIApplication.sharedApplication().keyWindow)
        if(panGestureRecognizer.state == UIGestureRecognizerState.Ended){
            if(point.y < constant.minEdgeDistance){
               point.y = constant.minEdgeDistance
            }else if(point.y > UIScreen.mainScreen().bounds.size.height - constant.minEdgeDistance){
                point.y = UIScreen.mainScreen().bounds.size.height - constant.minEdgeDistance
            }
            if(point.x < constant.minEdgeDistance){
                point.x = constant.minEdgeDistance
            }else if(point.x > UIScreen.mainScreen().bounds.size.width - constant.minEdgeDistance){
                point.x = UIScreen.mainScreen().bounds.size.width - constant.minEdgeDistance
            }
            
            UIView.animateWithDuration(0.5, animations: {complete in self.center = point})
            
        }else{
            self.center = point
        }
        
    }
    
    deinit{
        self.removeObserver(self, forKeyPath: "bounds")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    //override func drawRect(rect: CGRect) {
        // Drawing code
//        let bgColor = UIColor.redColor().CGColor
//        
//        let path = CGPathCreateMutable()
//        
//        CGPathAddArc(path, nil, self.bounds.width/2, self.bounds.height/2,self.bounds.width/2, 0, CGFloat(2*M_PI), false)
//        
//        let c = UIGraphicsGetCurrentContext()
//        
//        CGContextSetStrokeColorWithColor(c, UIColor.clearColor().CGColor)
//        CGContextSetFillColorWithColor(c,bgColor)
//        CGContextSetLineWidth(c, 2.0)
//        
//        CGContextAddPath(c, path)
//        
//        CGContextDrawPath(c, CGPathDrawingMode.FillStroke)
    //}
    
}
