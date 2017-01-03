//
//  HomeViewController.swift
//  OnTime
//
//  Created by Atom on 16/5/10.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, CircleMenuDelegate,UIViewControllerTransitioningDelegate {
    
    var suggestionClockImageView:UIImageView!
    var suggestionClockLabelImage:UILabel!
    var suggestionBanLabelImage:UILabel!
    var clockView:ClockView!
    var updateSuggestionTimer:NSTimer!
    
    struct Suggestion{
        var startTime:[Int]
        var endTime:[Int]
        var suggestionLabelText:String!
        var suggestionImageName:String!
        var suggestionLabelImage:String!
        var ban:Bool
    }
    
    let suggestionData:[Suggestion] =
        [Suggestion(startTime: [0,0],endTime: [7,0],suggestionLabelText: "熟睡中。。。",suggestionImageName: nil,suggestionLabelImage: "💤", ban: false),
         Suggestion(startTime: [7,00],endTime: [7,10],suggestionLabelText: "起床啦！！！",suggestionImageName: nil,suggestionLabelImage: "⏰", ban: false),
         Suggestion(startTime: [7,10],endTime: [7,30],suggestionLabelText: "晨起排便",suggestionImageName: nil,suggestionLabelImage: "🚽", ban: false),
         Suggestion(startTime: [7,30],endTime: [8,0],suggestionLabelText: "早餐前洗漱",suggestionImageName: nil,suggestionLabelImage: "🚰", ban: false),
         Suggestion(startTime: [8,0],endTime: [8,30],suggestionLabelText: "吃早餐啦！！！",suggestionImageName: nil,suggestionLabelImage: "🍞", ban: false),
         Suggestion(startTime: [8,30],endTime: [9,0],suggestionLabelText: "避免运动",suggestionImageName: nil,suggestionLabelImage: "⛹🏻", ban: true),
         Suggestion(startTime: [9,0],endTime: [10,30],suggestionLabelText: "工作学习",suggestionImageName: nil,suggestionLabelImage: "📚", ban: false),
         Suggestion(startTime: [10,30],endTime: [11,0],suggestionLabelText: "吃点水果吧～",suggestionImageName: nil,suggestionLabelImage: "🍎", ban: false),
         Suggestion(startTime: [11,0],endTime: [12,0],suggestionLabelText: "自由活动",suggestionImageName: nil,suggestionLabelImage: "🎲", ban: false),
         Suggestion(startTime: [12,0],endTime: [12,30],suggestionLabelText: "吃午饭啦！！！",suggestionImageName: nil,suggestionLabelImage: "🍱", ban: false),
         Suggestion(startTime: [12,30],endTime: [14,00],suggestionLabelText: "午间休憩",suggestionImageName: nil,suggestionLabelImage: "😴", ban: false),
         Suggestion(startTime: [14,00],endTime: [15,40],suggestionLabelText: "自由活动",suggestionImageName: nil,suggestionLabelImage: "🎲", ban: false),
         Suggestion(startTime: [15,40],endTime: [17,00],suggestionLabelText: "锻炼身体",suggestionImageName: nil,suggestionLabelImage: "⛹🏻", ban: false),
         Suggestion(startTime: [17,00],endTime: [18,00],suggestionLabelText: "自由活动",suggestionImageName: nil,suggestionLabelImage: "🎲", ban: false),
         Suggestion(startTime: [18,00],endTime: [18,30],suggestionLabelText: "吃晚饭啦，别吃太多！！！",suggestionImageName: nil,suggestionLabelImage: "🍛", ban: false),
         Suggestion(startTime: [18,30],endTime: [18,50],suggestionLabelText: "饭后小憩",suggestionImageName: nil,suggestionLabelImage: "😪", ban: false),
         Suggestion(startTime: [18,50],endTime: [19,10],suggestionLabelText: "饭后走一走～",suggestionImageName: nil,suggestionLabelImage: "🚶🏻", ban: false),
         Suggestion(startTime: [19,10],endTime: [19,30],suggestionLabelText: "喝杯酸奶吧～",suggestionImageName: nil,suggestionLabelImage: "🍼", ban: false),
         Suggestion(startTime: [19,30],endTime: [21,0],suggestionLabelText: "自由活动",suggestionImageName: nil,suggestionLabelImage: "🎲", ban: false),
         Suggestion(startTime: [21,30],endTime: [22,00],suggestionLabelText: "洗个热水澡",suggestionImageName: nil,suggestionLabelImage: "🚿", ban: false),
         Suggestion(startTime: [22,00],endTime: [23,00],suggestionLabelText: "睡前放松",suggestionImageName: nil,suggestionLabelImage: "🛋", ban: false),
         Suggestion(startTime: [23,00],endTime: [23,10],suggestionLabelText: "睡觉啦！！！",suggestionImageName: nil,suggestionLabelImage: "😴", ban: false),
         Suggestion(startTime: [23,10],endTime: [24,00],suggestionLabelText: "熟睡中。。。",suggestionImageName: nil,suggestionLabelImage: "💤", ban: false)]
    
    @IBOutlet weak var circleMenu: CircleMenu!{
        didSet{
            circleMenu.delegate = self
        }
    }
    
    @IBOutlet weak var suggestionView: UIView!
    @IBOutlet weak var currentTimeDigitLabel: UILabel!
  
    @IBOutlet weak var suggestionLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
        self.view.bringSubviewToFront(circleMenu)
        circleMenu.titleLabel?.textAlignment = NSTextAlignment.Center
        
        //时钟view
        self.clockView =  ClockView(frame: CGRect(x: 0, y: 0, width: 320, height: 320),clockRadius: 160,bgColor: UIColor.clearColor())
        
        //self.view.addSubview(clockView)
        self.view.insertSubview(clockView, belowSubview: suggestionView)
        clockView.translatesAutoresizingMaskIntoConstraints = false
        
        //if #available(iOS 9.0, *) {
            
            let widthConstraint = clockView.widthAnchor.constraintEqualToConstant(320)
            let heightConstraint = clockView.heightAnchor.constraintEqualToConstant(320)
            
            let centerXConstraint = clockView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
            
            let bottomConstraint = clockView.bottomAnchor.constraintEqualToAnchor(suggestionView.bottomAnchor)
            
            NSLayoutConstraint.activateConstraints([widthConstraint,heightConstraint,centerXConstraint,bottomConstraint])

        //}
        
        //小贴士view
        suggestionClockImageView = UIImageView(frame: CGRect(x: clockView.centerPoint.x-64, y: clockView.centerPoint.y-64, width: 128.0, height: 128.0))
       
        suggestionClockImageView.contentMode = UIViewContentMode.ScaleAspectFit
        clockView.insertSubview(suggestionClockImageView, belowSubview: clockView.secondHandView)
        
        suggestionClockLabelImage = UILabel(frame: CGRect(x: clockView.centerPoint.x-80, y: clockView.centerPoint.y-80, width: 160.0, height: 160.0))
        
        suggestionClockLabelImage.font = UIFont.boldSystemFontOfSize(118.0)
        suggestionClockLabelImage.textAlignment = NSTextAlignment.Center

        clockView.insertSubview(suggestionClockLabelImage, belowSubview: clockView.secondHandView)
        
        suggestionBanLabelImage = UILabel(frame: CGRect(x: clockView.centerPoint.x-70, y: clockView.centerPoint.y-70, width: 140.0, height: 140.0))
        suggestionBanLabelImage.font = UIFont.boldSystemFontOfSize(80.0)
        suggestionBanLabelImage.textAlignment = NSTextAlignment.Center
        suggestionBanLabelImage.text = "🚫"
        suggestionBanLabelImage.hidden = true
        
        clockView.insertSubview(suggestionBanLabelImage, aboveSubview: suggestionClockLabelImage)
        
        updateSuggestion()
        
        self.updateSuggestionTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateSuggestion"), userInfo: nil, repeats: true)
        
        updateUserAttrs()
    }
    
    func circleMenu(circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int) {
        
        switch atIndex {
        case 0:
            button.backgroundColor = UIColor(red:0.19, green:0.57, blue:1, alpha:1)
            button.setTitle("❤️", forState: .Normal)
            button.setTitle("❤️", forState: .Highlighted)
            break
        case 1:
            button.backgroundColor = UIColor(red:0.22, green:0.74, blue:0, alpha:1)

            button.setTitle("📝", forState: .Normal)
            button.setTitle("📝", forState: .Highlighted)
            break
        case 2:
            button.backgroundColor = UIColor(red:0.96, green:0.23, blue:0.21, alpha:1)
            button.setTitle("😶", forState: .Normal)
            button.setTitle("😶", forState: .Highlighted)
            break
    
        default:
            break
        }
    
        button.titleLabel?.font = UIFont(name: (button.titleLabel?.font?.fontName)!, size: 24)
        button.tintColor = UIColor.init(colorLiteralRed:0, green: 0, blue:0, alpha: 0.3)
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonWillSelected button: CircleMenuButton, atIndex: Int) {
       
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        
        var newController:UIViewController! = nil;
        switch(atIndex){
        case 0:
            newController = storyboard?.instantiateViewControllerWithIdentifier("ConsultNavigationController") as UIViewController!

            break
        case 1:
           newController = storyboard?.instantiateViewControllerWithIdentifier("PlanNavigationController") as UIViewController!
           
            break
        case 2:
           newController = storyboard?.instantiateViewControllerWithIdentifier("AppearanceNavigationController") as UIViewController!
            
            break
        default:
            break
        }
        
        newController.transitioningDelegate = self
        newController.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        self.navigationController?.topViewController?.presentViewController(newController, animated: true, completion: nil)
        
        self.updateSuggestionTimer.invalidate()
        self.updateSuggestionTimer = nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FloatingCircleAnimatedTransitioning.init(transitionType: FloatingCircleAnimatedTransitionType.Present, circleShrinkAnimationEndRect: self.circleMenu.frame)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FloatingCircleAnimatedTransitioning.init(transitionType: FloatingCircleAnimatedTransitionType.Dismiss,  circleShrinkAnimationEndRect: self.circleMenu.frame)
    }
    
    func updateSuggestion(){
        
        let currTime = TimeManager.getInstance().getCurrentTime()
        let hour = currTime["hour"]!
        let minute = currTime["minute"]!
        let second = currTime["second"]!
        currentTimeDigitLabel.text = NSString.init(format: "%02d:%02d:%02d", hour,minute,second) as String
       
        //print("updateSuggestion at %02d:%02d:%02d", hour,minute,second)
//        let currentSuggestion:Suggestion!
//        for(var i:Int = 0; i < suggestionData.count; i+=1){
//            let suggestion = suggestionData[i]
        for suggestion in suggestionData{
            
            if (suggestion.endTime[0] > hour || (suggestion.endTime[0] == hour && suggestion.endTime[1] > minute))

            {
                let currentSuggestion = suggestion
                
                suggestionLabel.text = currentSuggestion.suggestionLabelText
                
                if(currentSuggestion.suggestionImageName != nil){
                    suggestionClockImageView.image = UIImage(named: currentSuggestion.suggestionImageName)
                    suggestionClockLabelImage.text = nil
                }else{
                    suggestionClockImageView.image = nil
                    suggestionClockLabelImage.text = currentSuggestion.suggestionLabelImage
                }
                
                suggestionBanLabelImage.hidden = !currentSuggestion.ban
                
                break
                
            }
        }

    }
    
    func updateUserAttrs(){
        let currTime = TimeManager.getInstance().getCurrentTime()
        let lastOpenAppDateData = DataManager.getInstance().userData.lastOpenAppDate as! [Int]
        
        if(lastOpenAppDateData.count == 0){
            DataManager.getInstance().userData.health = 80
            DataManager.getInstance().userData.happiness = 80
            DataManager.getInstance().userData.glamour = 50
            
            DataManager.getInstance().userData.lastOpenAppDate =
                [currTime["year"]!,currTime["month"]!,currTime["day"]!]
            DataManager.getInstance().saveUserDataToArchiver()
            
        }else{
            let lastOpenAppDateStr = String.init(format: "%4d-%2d-%2d", lastOpenAppDateData[0],lastOpenAppDateData[1],lastOpenAppDateData[2])
            //let lastOpenAppDateStr = "2016-12-27"
            
            let currentDateStr = String.init(format: "%4d-%2d-%2d", currTime["year"]!,currTime["month"]!,currTime["day"]!)
            
            let dm:NSDateFormatter = NSDateFormatter.init()
            dm.dateFormat = "yyyy-MM-dd"
            
            let lastOpenAppDate:NSDate = dm.dateFromString(lastOpenAppDateStr)!
            let currDate:NSDate = dm.dateFromString(currentDateStr)!
        
            let intervalSeconds:NSTimeInterval = currDate.timeIntervalSinceDate(lastOpenAppDate)
            
            let secondsPerDay = 86400
            var intervalDays = (Int(intervalSeconds))/secondsPerDay
            
            if(intervalDays>100){
                intervalDays = 100
            }
            
            if(intervalDays>0){
                DataManager.getInstance().changeUserGlamourBy(-GlobalConstant.userGlamourDailyDecrease*intervalDays)
                DataManager.getInstance().changeUserHealthBy(-GlobalConstant.userHealthDailyDecrease*intervalDays)
                DataManager.getInstance().changeUserHappinessBy(-GlobalConstant.userHappinessDailyDecrease*intervalDays)
               
            }
         
            DataManager.getInstance().userData.lastOpenAppDate =
                [currTime["year"]!,currTime["month"]!,currTime["day"]!]
            
            DataManager.getInstance().saveUserDataToArchiver()
        }
        
        

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
