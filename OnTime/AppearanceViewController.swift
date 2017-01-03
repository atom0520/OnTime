//
//  AppearanceViewController.swift
//  OnTime
//
//  Created by Atom on 16/5/14.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class AppearanceViewController: UIViewController, UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var faceView: FaceView! {
        didSet{
            faceView.backgroundColor = UIColor.clearColor()
        }
    }
    
    @IBOutlet weak var healthValueLabel: UILabel!{
        didSet{
            healthValueLabel.text = "\(DataManager.getInstance().userData.health)/100"
        }
    }
    
    @IBOutlet weak var happinessValueLabel: UILabel!{
        didSet{
            happinessValueLabel.text = "\(DataManager.getInstance().userData.happiness)/100"
        }
    }
    
    @IBOutlet weak var glamourValueLabel: UILabel!{
        didSet{
            glamourValueLabel.text = "\(DataManager.getInstance().userData.glamour)"
        }
    }
    
    @IBAction func onTouchTestBtn1(sender: UIButton) {
        DataManager.getInstance().userData.health += 10
        self.refreshStateValueLabels()
        
        self.faceView.setNeedsDisplay()
    }
   
    @IBAction func onTouchTestBtn2(sender: UIButton) {
        DataManager.getInstance().userData.health -= 10
        self.refreshStateValueLabels()

        self.faceView.setNeedsDisplay()
    }
    
    @IBAction func onTouchTestBtn3(sender: UIButton) {
        DataManager.getInstance().userData.happiness += 10
        self.refreshStateValueLabels()
        
        self.faceView.setNeedsDisplay()
    }
    
    @IBAction func onTouchTestBtn4(sender: UIButton) {
        DataManager.getInstance().userData.happiness -= 10
        self.refreshStateValueLabels()
        
        self.faceView.setNeedsDisplay()
    }
    
    @IBAction func onTouchTestBtn5(sender: UIButton) {
        DataManager.getInstance().userData.glamour += 10
        self.refreshStateValueLabels()
        
        self.faceView.setNeedsDisplay()
    }
    
    @IBAction func onTouchTestBtn6(sender: UIButton) {
        DataManager.getInstance().userData.glamour -= 10
        self.refreshStateValueLabels()
        
        self.faceView.setNeedsDisplay()
    }
    
    func refreshStateValueLabels(){
        self.healthValueLabel.text = "\(DataManager.getInstance().userData.health)/100"
        self.happinessValueLabel.text = "\(DataManager.getInstance().userData.happiness)/100"
        self.glamourValueLabel.text = "\(DataManager.getInstance().userData.glamour)"
    }
    
    @IBOutlet weak var reflectionView: UIView!{
        didSet{
            let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()

            reflectionView.layer.cornerRadius = 8
            reflectionView.layer.masksToBounds = true
            reflectionView.layer.borderWidth = 1
            reflectionView.layer.borderColor = CGColorCreate(colorSpace, [CGFloat]([0,0,0,1]))!
        }
    }
    
    @IBAction func onTouchMirrorPromptBtn(sender: UIButton) {
        
        self.showPromtPopupView(UIPopoverArrowDirection.Down, sourceView: sender, sourceRect: CGRect.init(x: sender.bounds.width/2.0, y: 0, width: 0, height: 0), promptText: "📢温馨提示\t\n良好的生活作息规律能够带来健康的身体、愉快的心情以及迷人的容颜，从而改变镜中自己的精神面貌喔！😼")
    }

    @IBAction func onTouchHealthPromptBtn(sender: UIButton) {
 
        self.showPromtPopupView(UIPopoverArrowDirection.Up, sourceView: sender, sourceRect: CGRect.init(x: sender.bounds.width/2.0, y: sender.bounds.height-6, width: 0, height: 0), promptText: " 健康值 ")
    }
    
    @IBAction func onTouchHappinessPromptBtn(sender: UIButton) {

        self.showPromtPopupView(UIPopoverArrowDirection.Up, sourceView: sender, sourceRect: CGRect.init(x: sender.bounds.width/2.0, y: sender.bounds.height-6, width: 0, height: 0), promptText: " 心情值 ")
    }
    
    @IBAction func onTouchGlamourPromptBtn(sender: UIButton) {
 
        self.showPromtPopupView(UIPopoverArrowDirection.Up, sourceView: sender, sourceRect: CGRect.init(x: sender.bounds.width/2.0, y: sender.bounds.height-6, width: 0, height: 0), promptText: " 魅力值 ")
    }
    
    func showPromtPopupView(arrowDirection:UIPopoverArrowDirection,sourceView:UIView,sourceRect:CGRect,promptText:String){
        
        let apvc = storyboard!.instantiateViewControllerWithIdentifier("AppearancePromptViewController") as! AppearancePromptViewController
        
        apvc.modalPresentationStyle = .Popover
      
        apvc.popoverPresentationController!.permittedArrowDirections = arrowDirection
        
        apvc.popoverPresentationController!.delegate = self
        
        apvc.popoverPresentationController!.sourceView = sourceView
        
        apvc.popoverPresentationController!.sourceRect = sourceRect
        apvc.popoverPresentationController!.canOverlapSourceViewRect = false
     
        apvc.popoverPresentationController!.popoverLayoutMargins = UIEdgeInsetsMake(0,0,0,0)
        apvc.text = promptText
        
        self.presentViewController(apvc, animated: true, completion: {done in })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "😶有时于形"

//        DataManager.getInstance().userData.health = 80
//        DataManager.getInstance().userData.happiness = 72
//        DataManager.getInstance().userData.glamour = 188
        self.faceView.setNeedsDisplay()
        self.refreshStateValueLabels()
    }
    

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
