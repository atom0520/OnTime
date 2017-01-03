//
//  PlanViewController.swift
//  OnTime
//
//  Created by Atom on 16/5/12.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,PlanTableViewDelegate,UITextFieldDelegate {

    struct Constant {
        static let disabledCheckInBtnLabelTextColor:UIColor = UIColor.init(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
        static let disabledCheckInBtnBgColor:UIColor = UIColor.init(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        static let enabledCheckInBtnLabelTextColor:UIColor = UIColor.redColor()
        static let enabledCheckInBtnBgColor:UIColor = UIColor.init(red: 102/255, green: 204/255, blue: 255/255, alpha: 1.0)
        static let completedCheckInBtnLabelTextColor:UIColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.8)
        static let completedCheckInBtnBgColor:UIColor = UIColor.init(red: 255/255, green: 204/255, blue: 102/255, alpha: 1.0)
    }
    
    var updateCheckInBtnsTimer:NSTimer!
    
    @IBOutlet var checkInPopupView: CheckInPopupView!    
    @IBOutlet var checkInRewardPopupView: CheckInRewardPopupView!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
    }
    
    @IBOutlet weak var patternControl: UISegmentedControl!
    
    @IBAction func alterPattern(sender: UISegmentedControl) {
        tableView.reloadData()
        self.updateCheckInBtns()
    }
    
    var weekdayPlan:[Plan] = []
    
    var weekendPlan:[Plan] = []
    
    var willCheckInPlanIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "📝有时于行"
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.delaysContentTouches = false;
        for view in tableView.subviews {
            if view is UIScrollView {
                (view as? UIScrollView)!.delaysContentTouches = false
            }
        }
        
        checkInPopupView.guaranteeTextField.delegate = self
        
        refreshPlanTableView()
    }
    
    func reloadPlanTableViewDataSource(){
        weekdayPlan = []
        weekendPlan = []
        var planIndex:Int = 0
        
        for planData in DataManager.getInstance().userData.plans{
            let plan:Plan = Plan(
                planIndex:planIndex,
                activity: planData["activity"] as! Int,
                labelText: planData["labelText"] as! String,
                pattern: planData["pattern"] as! Int,
                time: planData["time"] as! [Int],
                notification: planData["notification"] as! Bool)
            
            switch plan.pattern{
            case PlanPattern.everyDay:
                weekdayPlan.append(plan)
                weekendPlan.append(plan)
                break
            case PlanPattern.weekDay:
                weekdayPlan.append(plan)
                break
            case PlanPattern.weekEnd:
                weekendPlan.append(plan)
                break
            default:
                
                break
            }
            
            planIndex+=1
        }
    }
    
    func refreshPlanTableView()
    {
        self.reloadPlanTableViewDataSource()
        self.tableView.reloadData()
        
    }
    
    @IBAction func onTouchAddPlanBtn(sender: AnyObject) {
        let planSetViewController = storyboard!.instantiateViewControllerWithIdentifier("PlanSetViewController") as! PlanSetViewController
        
        planSetViewController.planTableViewDelegate = self
        self.navigationController!.pushViewController(planSetViewController, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch patternControl.selectedSegmentIndex {
        case 0:
            return weekdayPlan.count
        case 1:
            return weekendPlan.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlanTableViewCell") as! PlanTableViewCell
        
        var plan:Plan
        switch patternControl.selectedSegmentIndex {
        case 0:
            plan = weekdayPlan[indexPath.row]
        break
        case 1:
            plan = weekendPlan[indexPath.row]
        break
        default:
            plan = weekdayPlan[indexPath.row]
        break
        }
        switch(plan.activity){
        case PlanActivityTag.GetUpActivityTag:
            cell.activityIcon.text = PlanActivityIcon.GetUpActivityIcon
            break
        case PlanActivityTag.BreakfastActivityTag:
            cell.activityIcon.text = PlanActivityIcon.BreakfastActivityIcon
            break
        case PlanActivityTag.LunchActivityTag:
            cell.activityIcon.text = PlanActivityIcon.LunchActivityIcon
            break
        case PlanActivityTag.DinnerActivityTag:
            cell.activityIcon.text = PlanActivityIcon.DinnerActivityIcon
            break
        case PlanActivityTag.SleepActivityTag:
            cell.activityIcon.text = PlanActivityIcon.SleepActivityIcon
            break
        default:
            cell.activityIcon.text = PlanActivityIcon.ExtActivityIcon
            break
        }
        
        cell.activityNameLabel.text = plan.labelText
        cell.timeLabel.text = NSString.init(format: "%02d:%02d", plan.time[0],plan.time[1]) as String
        cell.planIndex = plan.planIndex
        
        return cell
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //editBtn
        let editAction:UITableViewRowAction = UITableViewRowAction.init(style: .Default, title: " 编辑 ",handler:{
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let planSetViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PlanSetViewController") as! PlanSetViewController
            
            planSetViewController.planTableViewDelegate = self
            planSetViewController.planSetMode = .edit
            switch self.patternControl.selectedSegmentIndex{
            case 0:
                planSetViewController.editedPlanIndex = self.weekdayPlan[indexPath.row].planIndex
                break
            case 1:
                planSetViewController.editedPlanIndex = self.weekendPlan[indexPath.row].planIndex
                break
            default:
                planSetViewController.editedPlanIndex = self.weekdayPlan[indexPath.row].planIndex
                break
            }
                
            self.navigationController!.pushViewController(planSetViewController, animated: true)
            self.tableView.setEditing(false, animated: true)
            
            }
        )
        editAction.backgroundColor = UIColor.init(red: 103/255, green: 204/255, blue: 249/255, alpha: 1.0)
        
        //deleteBtn
        let deleteAction:UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowActionStyle.Destructive, title: " 删除 ",handler:{
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            var selectedPlan:Plan! = nil
            
            switch(self.patternControl.selectedSegmentIndex){
            case 0:
                selectedPlan = self.weekdayPlan[indexPath.row]
                break;
            case 1:
                selectedPlan = self.weekendPlan[indexPath.row]
                break;
            default:
                selectedPlan = self.weekdayPlan[indexPath.row]
                break;
            }
            let planIndex = selectedPlan.planIndex
            DataManager.getInstance().userData.plans.removeAtIndex(planIndex)
            DataManager.getInstance().saveUserDataToArchiver()
            
            self.reloadPlanTableViewDataSource()

            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        )
        
        return [deleteAction,editAction]
    }
    
    func updateCheckInBtns(){
        
        var displayedPlans:[Plan]!
        switch self.patternControl.selectedSegmentIndex {
        case 0:
            displayedPlans = self.weekdayPlan
            break
      
        default:
            displayedPlans = self.weekendPlan
            break
        }
        
        var displayedPlanIndex = 0
        while(displayedPlanIndex<displayedPlans.count){
            var plan = displayedPlans[displayedPlanIndex]
            var planIndex = plan.planIndex
            
            let planCell = self.tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: displayedPlanIndex,
                inSection: 0)) as! PlanTableViewCell
            
            let currTime = TimeManager.getInstance().getCurrentTime()
            
            let planTime = plan.time
            let planMinuteTime = plan.time[0]*60+plan.time[1]
            
            let lastCheckInDate = DataManager.getInstance().userData.plans[planIndex]["lastCheckInDate"] as? [Int]
            if(lastCheckInDate != nil
                    && lastCheckInDate![0]==currTime["year"]!
                    && lastCheckInDate![1]==currTime["month"]!
                    && lastCheckInDate![2]==currTime["day"]! ){
                let newBtnLabelText = "今日已签到"
                planCell.checkInBtn.titleLabel!.text = newBtnLabelText
                planCell.checkInBtn.setTitle(newBtnLabelText, forState: .Normal)
                
                planCell.checkInBtn.backgroundColor = Constant.completedCheckInBtnBgColor
                planCell.checkInBtn.setTitleColor(Constant.completedCheckInBtnLabelTextColor, forState: .Normal)
                
                planCell.checkInBtn.enabled = false
            }else{
                let currMinuteTime = currTime["hour"]!*60+currTime["minute"]!
                
                if(currMinuteTime>=planMinuteTime && currMinuteTime<=planMinuteTime+10){
                    let newBtnLabelText = "签到"
                    planCell.checkInBtn.titleLabel!.text = newBtnLabelText
                    planCell.checkInBtn.setTitle(newBtnLabelText, forState: .Normal)
                    
                    planCell.checkInBtn.backgroundColor = Constant.enabledCheckInBtnBgColor
                    planCell.checkInBtn.setTitleColor(Constant.enabledCheckInBtnLabelTextColor, forState: .Normal)
                    
                    planCell.checkInBtn.enabled = true
                    
                }else if(currMinuteTime<planMinuteTime){
                    
                    planCell.checkInBtn.enabled = false
                    
                    let dMinuteTime = planMinuteTime - currMinuteTime
                    let newBtnLabelText = NSString.init(format: "离签到还有%d小时%d分钟", dMinuteTime/60,dMinuteTime%60) as String
                    
                    planCell.checkInBtn.titleLabel!.text = newBtnLabelText
                    planCell.checkInBtn.setTitle(newBtnLabelText, forState: .Normal)
                    
                    planCell.checkInBtn.backgroundColor = Constant.disabledCheckInBtnBgColor
                    planCell.checkInBtn.setTitleColor(Constant.disabledCheckInBtnLabelTextColor, forState: .Normal)
                    
                }else if(currMinuteTime>planMinuteTime+10){
                    planCell.checkInBtn.enabled = false
                    
                    let newBtnLabelText = "今日签到时间已过"
                    planCell.checkInBtn.titleLabel!.text = newBtnLabelText
                    planCell.checkInBtn.setTitle(newBtnLabelText, forState: .Normal)
                    
                    planCell.checkInBtn.backgroundColor = Constant.disabledCheckInBtnBgColor
                    planCell.checkInBtn.setTitleColor(Constant.disabledCheckInBtnLabelTextColor, forState: .Normal)
                }

            }
            
            displayedPlanIndex += 1
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateCheckInBtns()
        self.updateCheckInBtnsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateCheckInBtns", userInfo: nil, repeats: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onTouchPlanCellCheckInBtn:", name: "onTouchPlanCellCheckInBtn", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.updateCheckInBtnsTimer.invalidate()
        self.updateCheckInBtnsTimer = nil
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "onTouchPlanCellCheckInBtn", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onTouchPlanCellCheckInBtn(notification: NSNotification){
        let notificationDict = notification.object as! Dictionary<String,AnyObject>
        self.willCheckInPlanIndex = notificationDict["planIndex"] as! Int
        
        self.showCheckInPopupView()
    }
    
    func showCheckInPopupView() {
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        checkInPopupView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: screenWidth, height: screenHeight)
        
        checkInPopupView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        
        let randForSelectImage = Int(1+arc4random()%2)
        checkInPopupView.imageVIew.image = UIImage.init(named: "poster_\(randForSelectImage)")
        
        let appKeyWin = UIApplication.sharedApplication().keyWindow!
        appKeyWin.addSubview(checkInPopupView)
        
        checkInPopupView.tag = 998
        
        checkInPopupView.alpha = 0
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.checkInPopupView.alpha = 1
        })
        
        UIView.animateWithDuration(0.25,
                                   animations: {
            ()->Void in self.checkInPopupView.alpha = 1
            },
                                   completion: {
                (completed)->Void in
                if(completed == true){
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlanViewController.onTouchCheckInPopupViewCloseBtn), name: "onTouchCheckInPopupViewCloseBtn", object: nil)
                    
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlanViewController.onTouchCheckInPopupViewCheckInBtn(_:)), name: "onTouchCheckInPopupViewCheckInBtn", object: nil)
                    
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlanViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
                    
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlanViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
                    
                 
                }
            }
        )
    }
    
    func hideCheckInPopupView(){
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.checkInPopupView.alpha = 0
        }) { (completed) -> Void in
            if completed {
                self.checkInPopupView.removeFromSuperview()
            }
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "onTouchCheckInPopupViewCloseBtn", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "onTouchCheckInPopupViewCheckInBtn", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func showCheckInRewardPopupView(healthPromotion:Int,happinessPromotion:Int,glamourPromotion:Int){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        checkInRewardPopupView.frame = CGRect(
            x: 0,
            y: 0,
            width: screenWidth, height: screenHeight )
        
        checkInRewardPopupView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        
        checkInRewardPopupView.healthPromotionLabel.text = String("+\(healthPromotion)")
        checkInRewardPopupView.happinessPromotionLabel.text = String("+\(happinessPromotion)")
        checkInRewardPopupView.glamourPromotionLabel.text = String("+\(glamourPromotion)")
        
        let appKeyWin = UIApplication.sharedApplication().keyWindow!
        appKeyWin.addSubview(checkInRewardPopupView)
        
        checkInRewardPopupView.alpha = 0
        UIView.animateWithDuration(0.25,
                animations: {
                () -> Void in
                self.checkInRewardPopupView.alpha = 1
            
            },
                completion:{
                (completed)->Void in
                    if completed {
                        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlanViewController.onTouchCheckInRewardPopupViewOkBtn), name: "onTouchCheckInRewardPopupViewOkBtn", object: nil)
                    }
        })
    }
    
    func hideCheckInRewardPopupView(){
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.checkInRewardPopupView.alpha = 0
        }) { (completed) -> Void in
            if (completed) {
                self.checkInRewardPopupView.removeFromSuperview()
            }
        }
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "onTouchCheckInRewardPopupViewOkBtn", object: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == self.checkInPopupView.guaranteeTextField){
            textField.resignFirstResponder()
        }
        return true
    }
    
    func onTouchCheckInPopupViewCloseBtn(){
       self.hideCheckInPopupView()
    }
    
    func onTouchCheckInRewardPopupViewOkBtn(){
        self.hideCheckInRewardPopupView()
    }
    
    func onTouchCheckInPopupViewCheckInBtn(notification:NSNotification){
      
        let currTime = TimeManager.getInstance().getCurrentTime()
        DataManager.getInstance().userData.plans[self.willCheckInPlanIndex]["lastCheckInDate"] = [currTime["year"]!,currTime["month"]!,currTime["day"]!]
        
        let healthPromotion:Int = Int(1+arc4random()%5)
        let happinessPromotion:Int = Int(1+arc4random()%5)
        let glamourPromotion:Int = Int(1+arc4random()%5)

        DataManager.getInstance().changeUserHealthBy(healthPromotion)
        DataManager.getInstance().changeUserHappinessBy(happinessPromotion)
        DataManager.getInstance().changeUserGlamourBy(glamourPromotion)
        
        DataManager.getInstance().saveUserDataToArchiver()
        
        self.updateCheckInBtns()
        
        self.hideCheckInPopupView()
        
        self.showCheckInRewardPopupView(healthPromotion,happinessPromotion: happinessPromotion,glamourPromotion: glamourPromotion)
    }
    
    func keyboardWillShow(notification:NSNotification){
        let info = notification.userInfo! as NSDictionary
        let keyboardRect = info.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue()
        
        if checkInPopupView.guaranteeTextField.editing{
            self.moveCheckInViewTextFieldWithKeyboardHeight(checkInPopupView.guaranteeTextField, keyboardHeight: (keyboardRect?.height)!)
        }
    }
    
    func keyboardWillHide(){
        
        checkInPopupView.frame = CGRect(
            x: 0,
            y: 0,
            width: checkInPopupView.frame.width,
            height: checkInPopupView.frame.height)
    }

    func moveCheckInViewTextFieldWithKeyboardHeight(textField: UITextField, keyboardHeight :CGFloat){
        
        let screenRect = UIScreen.mainScreen().bounds
        let screenHeight = screenRect.size.height
        
        let offsetY =  checkInPopupView.checkInWindowView.frame.origin.y + checkInPopupView.guaranteeTextField.frame.origin.y + checkInPopupView.guaranteeTextField.frame.size.height + 8
            - (screenHeight - keyboardHeight)
        
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        
        if(offsetY>=0){
            checkInPopupView.frame = CGRect(
                x: 0,
                y: -offsetY,
                width: checkInPopupView.frame.width,
                height: checkInPopupView.frame.height)
        }
        UIView.commitAnimations()
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
