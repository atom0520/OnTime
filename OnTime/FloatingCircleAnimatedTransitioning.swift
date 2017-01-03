//
//  FloatingCircleAnimatedTransitioning.swift
//  OnTime
//
//  Created by Atom on 16/6/9.
//  Copyright © 2016年 Atom. All rights reserved.
//

import Foundation
import UIKit

enum FloatingCircleAnimatedTransitionType{
    case Present
    case Dismiss
}

class FloatingCircleAnimatedTransitioning:NSObject,UIViewControllerAnimatedTransitioning,CAAnimationDelegate{
    
    struct constant{
        static let floatingCircleButtonTag:Int = 100
        static let floatingClockViewTag:Int = 200
    }
    
    var transitionType:FloatingCircleAnimatedTransitionType = FloatingCircleAnimatedTransitionType.Present
    var transitionContext:UIViewControllerContextTransitioning!
    var toVC:UIViewController!
    var fromVC:UIViewController!
    var circleShrinkAnimationEndRect:CGRect!
   
    
    init(transitionType:FloatingCircleAnimatedTransitionType,circleShrinkAnimationEndRect:CGRect) {
        super.init()
        self.transitionType = transitionType
        self.circleShrinkAnimationEndRect = circleShrinkAnimationEndRect
    }
        
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.0;
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        switch(transitionType){
        case .Present:
            animatePresentTransition(transitionContext)
            break;
        case .Dismiss:
            animateDismissTransition(transitionContext)
            break;
        }
        
    }
    
    func animatePresentTransition(transitionContext:UIViewControllerContextTransitioning){
        self.transitionContext = transitionContext
        
        if let fromNav:UINavigationController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? UINavigationController{
            self.fromVC = fromNav.viewControllers.last
        }
        
        let homeVC:HomeViewController = self.fromVC as! HomeViewController
        
        self.toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        //let floatingCircleButton = FloatingCircleView(frame: self.circleShrinkAnimationEndRect, image: UIImage(named:"mushroom")!,hostVC: self.toVC )
        
        let floatingCircleButton = FloatingCircleButton(frame: self.circleShrinkAnimationEndRect, text:"🕓",textFontSize: homeVC.circleMenu.titleLabel!.font.pointSize,hostVC: self.toVC ) as FloatingCircleButton 
        
        floatingCircleButton.userInteractionEnabled = true
        floatingCircleButton.layer.masksToBounds = true
        floatingCircleButton.tag = constant.floatingCircleButtonTag
        
        UIApplication.sharedApplication().keyWindow!.addSubview(floatingCircleButton)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: floatingCircleButton, action: "onPan:")
        floatingCircleButton.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: floatingCircleButton, action: "onTapDismiss:")
        floatingCircleButton.addGestureRecognizer(tapGestureRecognizer)
    
        let containerView = transitionContext.containerView()
        
        containerView.addSubview(self.toVC.view)
        containerView.addSubview(self.fromVC.view)
        
        let endCircle = UIBezierPath(ovalInRect: self.circleShrinkAnimationEndRect)
        
        let radius:CGFloat = sqrt(UIScreen.mainScreen().bounds.height * UIScreen.mainScreen().bounds.height + UIScreen.mainScreen().bounds.width * UIScreen.mainScreen().bounds.width)/2
        
        let beginCircle = UIBezierPath(arcCenter: containerView.center, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        let maskLayer:CAShapeLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.greenColor().CGColor
        maskLayer.path = endCircle.CGPath

        fromVC.view.layer.mask = maskLayer
        
        let circleShrinkAnimation = CABasicAnimation(keyPath: "path")
        circleShrinkAnimation.duration = 0.8
        circleShrinkAnimation.fromValue = beginCircle.CGPath
        circleShrinkAnimation.toValue = endCircle.CGPath
        circleShrinkAnimation.delegate = self
        circleShrinkAnimation.setValue(1, forKey: "presentAnimationId")
        maskLayer.addAnimation(circleShrinkAnimation, forKey: "path")
    
    }
    
    func animateDismissTransition(transitionContext:UIViewControllerContextTransitioning){
        self.transitionContext = transitionContext
       
        self.fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
       
        if let toNav:UINavigationController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? UINavigationController{
            self.toVC = toNav.viewControllers.last
        }
        
        let homeVC:HomeViewController = self.toVC as! HomeViewController
        
        let floatingCircleButton = UIApplication.sharedApplication().keyWindow!.viewWithTag(constant.floatingCircleButtonTag) as! FloatingCircleButton
        
        
        floatingCircleButton.hidden = true;
    
//        let maskLayer:CALayer = CALayer()
//        maskLayer.frame = CGRectMake(0, 0, 0, 0)
//        homeVC.view.layer.mask = maskLayer
        
        let beginPoint:CGPoint = floatingCircleButton.center

        let endPoint:CGPoint = homeVC.clockView.center
        
        let animPath = UIBezierPath.init()
        animPath.moveToPoint(beginPoint)
        animPath.addLineToPoint(endPoint)
    
    
    let floatingClockView = ClockView(frame: floatingCircleButton.frame, clockRadius: floatingCircleButton.frame.width/2, bgColor: UIColor.clearColor())
     
    floatingClockView.tag = constant.floatingClockViewTag
 
    UIApplication.sharedApplication().keyWindow!.addSubview(floatingClockView)

    UIView.animateWithDuration(0.8,
                               animations: {
            floatingCircleButton.bounds = homeVC.clockView.dialView.bounds
            floatingCircleButton.center = homeVC.clockView.center
            
            floatingClockView.bounds = homeVC.clockView.dialView.bounds
            floatingClockView.center = homeVC.clockView.center

            
        },
                               completion:{complete in
                                let floatingCircleButton = UIApplication.sharedApplication().keyWindow?.viewWithTag(constant.floatingCircleButtonTag) as! FloatingCircleButton
                                
                                let containerView = transitionContext.containerView()
                                containerView.addSubview(self.toVC.view)
                                
                                let radius:CGFloat = sqrt(containerView.frame.size.height*containerView.frame.size.height+containerView.frame.size.width*containerView.frame.size.width)/2
                                
                                let beginCircle = UIBezierPath(ovalInRect: floatingCircleButton.frame)
                                
                                let endCircle = UIBezierPath(arcCenter: containerView.center, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
                                
                                let maskLayer = CAShapeLayer()
                                //maskLayer.fillColor = UIColor.redColor().CGColor
                                maskLayer.path = endCircle.CGPath
                                self.toVC.view.layer.mask = maskLayer
                                
                                let circleExpandAnimation = CABasicAnimation(keyPath: "path")
                                circleExpandAnimation.duration = 0.8
                                circleExpandAnimation.fromValue = beginCircle.CGPath
                                circleExpandAnimation.toValue = endCircle.CGPath
                                circleExpandAnimation.delegate = self
                                circleExpandAnimation.setValue(1, forKey: "dismissAnimationId")
                                maskLayer.addAnimation(circleExpandAnimation, forKey: "path")
                                
                               
                          })
        
    }
    
    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        switch self.transitionType {
        case .Present:
            animationPresentDidStop(anim, finished: flag)
            break
        case .Dismiss:
          
            animationDismissDidStop(anim, finished: flag)
            break
            
        }
    }
    
    func animationPresentDidStop(anim: CAAnimation, finished flag: Bool){
        self.transitionContext.completeTransition(true)
        self.fromVC.view.layer.mask = nil
        self.fromVC.view.removeFromSuperview()
    }
    
    func animationDismissDidStop(anim: CAAnimation, finished flag: Bool){
    
        if((anim.valueForKey("dismissAnimationId") as? Int) == 1)
        {
            self.fromVC.view.removeFromSuperview()
            
            let floatingCircleButton = UIApplication.sharedApplication().keyWindow!.viewWithTag(constant.floatingCircleButtonTag) as! FloatingCircleButton
            floatingCircleButton.layer.removeAllAnimations()
            floatingCircleButton.removeFromSuperview()
            
            let floatingClockView = UIApplication.sharedApplication().keyWindow!.viewWithTag(constant.floatingClockViewTag) as! ClockView

            floatingClockView.layer.removeAllAnimations()
            floatingClockView.removeFromSuperview()
//            self.transitionContext.containerView()!.alpha = 0.0
//            self.transitionContext.containerView()!.layoutIfNeeded()
//            self.transitionContext.containerView()!.layoutSubviews()
//            self.transitionContext.containerView()!.setNeedsLayout()
//            self.transitionContext.containerView()!.superview!.setNeedsLayout()
            
            if let toNav:UINavigationController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? UINavigationController{
            let homeViewController = toNav.storyboard?.instantiateViewControllerWithIdentifier("homeViewController") as! HomeViewController
                toNav.pushViewController(homeViewController, animated: false)
                
            }
            
            self.transitionContext.completeTransition(true)
            //self.toVC.view.layer.mask = nil
        }
    
    }
    
}
