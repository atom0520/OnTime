//
//  PlanSetViewController.swift
//  OnTime
//
//  Created by Atom on 16/5/12.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

struct Plan {
    var planIndex:Int
    var activity:Int
    var labelText:String
    var pattern:Int
    var time:[Int]
    var notification:Bool
}

struct PlanActivityTag{
    static let GetUpActivityTag = 0
    static let BreakfastActivityTag = 1
    static let LunchActivityTag = 2
    static let DinnerActivityTag = 3
    static let SleepActivityTag = 4
    static let ExtActivityTag = 5
}

struct PlanActivityIcon{
    static let GetUpActivityIcon = "☀️"
    static let BreakfastActivityIcon = "🍞"
    static let LunchActivityIcon = "🍱"
    static let DinnerActivityIcon = "🍛"
    static let SleepActivityIcon = "🌙"
    static let ExtActivityIcon = "❓"
}

struct PlanPattern{
     static let everyDay = 0
     static let weekDay = 1
     static let weekEnd = 2
}

enum PlanSetMode{
    case add
    case edit
}

protocol PlanTableViewDelegate {
      func refreshPlanTableView()
}

class PlanSetViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    struct Constant{
        static let ActivitySetCellIndex:Int = 0
        static let ActivitySetCellIndentifier = "PlanSetViewActivitySetCell"
        static let LabelSetCellIndex:Int = 1
        static let LabelSetCellIndentifier = "PlanSetViewLabelSetCell"
        static let PatternSetCellIndex:Int = 2
        static let PatternSetCellIndentifier = "PlanSetViewPatternSetCell"
        static let TimeSetCellIndex:Int = 3
        static let TimeSetCellIndentifier = "PlanSetViewTimeSetCell"
        static let NotificationSetCellIndex:Int = 4
        static let NotificationSetCellIndentifier = "PlanSetViewNotificationSetCell"
    }
    
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    
    var planTableViewDelegate:PlanTableViewDelegate?
    
    var selectedActivityTag:Int = -1
    var selectedPattern:Int = -1
    var selectedTime:[Int] = [-1,-1]

    var planActivitySetCell:PlanSetViewActivitySetCell!
    var planLabelSetCell:PlanSetViewLabelSetCell!
    var planPatternSetCell:PlanSetViewPatternSetCell!
    var planTimeSetCell:PlanSetViewTimeSetCell!
    var planNotificationSetCell:PlanSetViewNotificationSetCell!
    
    var planSetMode:PlanSetMode = PlanSetMode.add
    var editedPlanIndex:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.planSetMode {
        case .add:
            self.navigationItem.title = "📝添加DIY计划"
            break
        case .edit:
            self.navigationItem.title = "📝编辑DIY计划"

            
            break
        default:
            self.navigationItem.title = "📝添加DIY计划"
            break
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        let screenRect = UIScreen.mainScreen().bounds
        self.screenWidth = screenRect.size.width
        self.screenHeight = screenRect.size.height
        
    }
    
    func initEditedPlanData(){
        let editedPlanData = DataManager.getInstance().userData.plans[self.editedPlanIndex]
        var activityBtn:UIButton! = nil;
        
        self.selectedActivityTag = editedPlanData["activity"] as! Int
        
        self.refreshAfterSelectActivity()
        
        if(self.selectedActivityTag == PlanActivityTag.ExtActivityTag){
            self.planLabelSetCell.labelSetTextField.text = editedPlanData["labelText"] as! String
        }
        
        self.selectedPattern = editedPlanData["pattern"] as! Int
        self.planPatternSetCell.patternSetLabel.text =   patternSetView.pickerViewTitles[self.selectedPattern]
        
        self.selectedTime = editedPlanData["time"] as! [Int]
        self.planTimeSetCell.timeSetLabel.text = NSString.init(format: "%02d:%02d", self.selectedTime[0],self.selectedTime[1]) as String
        
        self.planNotificationSetCell.notificationSwitch.on = editedPlanData["notification"] as! Bool
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet var patternSetView: PatternSetView!{
        didSet{
            patternSetView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet var timeSetView: TimeSetView!{
        didSet{
            timeSetView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    @IBAction func onTouchBackBtn(sender: AnyObject) {
       self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func savePlan(sender: UIBarButtonItem) {
        
        var newPlanActivity:Int = -1
        var newPlanLabelText:String = ""
        var newPlanPattern:Int = -1
        var newPlanTime:[Int] = [-1,-1]
        var newPlanNotification:Bool = true
        
        if(selectedActivityTag != -1){
            newPlanActivity = selectedActivityTag
        }else{
            print("no activity is selected!")
            return
        }
        
        newPlanLabelText = self.planLabelSetCell.labelSetTextField.text!
        
        if(selectedPattern == -1){
            print("invalid pattern,the selectedPattern is \(selectedPattern)")
            return
        }else{
            newPlanPattern = selectedPattern
        }

        newPlanTime = selectedTime
        
        newPlanNotification = planNotificationSetCell.notificationSwitch.on
        
        let newPlan:Dictionary<String,AnyObject> =
            ["activity":newPlanActivity,
             "labelText":newPlanLabelText,
             "pattern":newPlanPattern,
             "time":newPlanTime,
             "notification":newPlanNotification
        ]
        
        switch planSetMode {
        case .edit:
            
            DataManager.getInstance().userData.plans[self.editedPlanIndex] = newPlan
        
//            DataManager.getInstance().userData.plans[self.editedPlanIndex]["activity"] = newPlanActivity
//            
//            DataManager.getInstance().userData.plans[self.editedPlanIndex]["labelText"] = newPlanLabelText
//            
//            DataManager.getInstance().userData.plans[self.editedPlanIndex]["pattern"] = newPlanPattern
//            
//            DataManager.getInstance().userData.plans[self.editedPlanIndex]["time"] = newPlanTime
//            
//            DataManager.getInstance().userData.plans[self.editedPlanIndex]["notification"] = newPlanNotification

            break
        case .add:
           
            
            DataManager.getInstance().userData.plans.append(newPlan)
            break
        default:
            
            DataManager.getInstance().userData.plans.append(newPlan)
            break
        }
        DataManager.getInstance().sortUserPlanData()
        
        DataManager.getInstance().saveUserDataToArchiver()
        
        planTableViewDelegate!.refreshPlanTableView()
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == planLabelSetCell.labelSetTextField)
        {
            textField.resignFirstResponder()
            
        }
            return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
//        let patternSetCell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: Constant.PatternSetCellIndex)) as! PlanSetViewPatternSetCell
        if(self.planPatternSetCell.selected == true){
            self.planPatternSetCell.selected = false
            hidePatternSetView()
        }
//        let timeSetCell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: Constant.TimeSetCellIndex)) as! PlanSetViewTimeSetCell
        if(self.planTimeSetCell.selected == true){
            self.planTimeSetCell.selected = false
            hideTimeSetView()
        }
        
    }
    
    @IBAction func setPattern(sender: UIButton) {
        selectedPattern = patternSetView.patternPickerView.selectedRowInComponent(0)

        self.planPatternSetCell.patternSetLabel.text =   patternSetView.pickerViewTitles[self.selectedPattern]
        self.planPatternSetCell.selected = false
        
        hidePatternSetView()
        
    }
    
    @IBAction func setTime(sender: UIButton) {
        
        selectedTime = [
            Int((timeSetView.hourTitles[timeSetView.hourPickerView.selectedRowInComponent(0)] as NSString).intValue),
            Int((timeSetView.minuteTitles[timeSetView.minutePickerView.selectedRowInComponent(0)] as NSString).intValue),
        ]
        
        self.planTimeSetCell.timeSetLabel.text =   NSString.init(format: "%02d:%02d", self.selectedTime[0], self.selectedTime[1]) as String
        
        self.planTimeSetCell.selected = false
        hideTimeSetView()
    }
    
    @IBAction func touchActivityBtn(sender: UIButton) {
       
        if(sender.tag != self.selectedActivityTag){
            self.selectedActivityTag = sender.tag
        }else{
            self.selectedActivityTag = -1
        }
        
        self.refreshAfterSelectActivity()
    }
    
    func refreshAfterSelectActivity(){
        for tag in [PlanActivityTag.GetUpActivityTag,
                    PlanActivityTag.BreakfastActivityTag,
                    PlanActivityTag.LunchActivityTag,
                    PlanActivityTag.DinnerActivityTag,
                    PlanActivityTag.SleepActivityTag,
                    PlanActivityTag.ExtActivityTag
            ] {
                
                var activityBtn:UIButton! = nil;
                
                switch(tag){
                case PlanActivityTag.GetUpActivityTag:
                    activityBtn=self.planActivitySetCell.getUpActivityBtn
                    break
                case PlanActivityTag.BreakfastActivityTag:
                    activityBtn=self.planActivitySetCell.breakfastActivityBtn
                    break
                case PlanActivityTag.LunchActivityTag:
                    activityBtn=self.planActivitySetCell.lunchActivityBtn
                    break
                case PlanActivityTag.DinnerActivityTag:
                    activityBtn=self.planActivitySetCell.dinnerActivityBtn
                    break
                case PlanActivityTag.SleepActivityTag:
                    activityBtn=self.planActivitySetCell.sleepActivityBtn
                    break
                case PlanActivityTag.ExtActivityTag:
                    activityBtn=self.planActivitySetCell.etcActivityBtn
                    break
                default:
                    break
                }
                
                if(tag==self.selectedActivityTag){
                    activityBtn.layer.masksToBounds = true
                    let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
                    let borderColor:CGColor = CGColorCreate(colorSpace, [CGFloat]([0.2,0.6,1,1]))!
                    activityBtn.layer.borderColor = borderColor
                    activityBtn.layer.borderWidth = 2
                    
                }else{
                    
                    activityBtn.layer.borderWidth = 0
                }
        }
        
        
        switch(self.selectedActivityTag){
        case PlanActivityTag.GetUpActivityTag:
            self.planLabelSetCell.labelSetTextField.enabled = false;
            self.planLabelSetCell.labelSetTextField.text = "起床"
            break
        case PlanActivityTag.BreakfastActivityTag:
            self.planLabelSetCell.labelSetTextField.enabled = false;
            self.planLabelSetCell.labelSetTextField.text = "吃早餐"
            
            break
        case PlanActivityTag.LunchActivityTag:
            self.planLabelSetCell.labelSetTextField.enabled = false;
            self.planLabelSetCell.labelSetTextField.text = "吃午餐"
            
            break
        case PlanActivityTag.DinnerActivityTag:
            self.planLabelSetCell.labelSetTextField.enabled = false;
            self.planLabelSetCell.labelSetTextField.text = "吃晚餐"
            
            break
        case PlanActivityTag.SleepActivityTag:
            self.planLabelSetCell.labelSetTextField.enabled = false;
            self.planLabelSetCell.labelSetTextField.text = "睡觉"
            
            break
        case PlanActivityTag.ExtActivityTag:
            if(self.planLabelSetCell.labelSetTextField.enabled==false){
                self.planLabelSetCell.labelSetTextField.text = ""
            }
            self.planLabelSetCell.labelSetTextField.enabled = true;
            
            
            break
        case -1:
            if(self.planLabelSetCell.labelSetTextField.enabled==false){
                self.planLabelSetCell.labelSetTextField.text = ""
            }
            self.planLabelSetCell.labelSetTextField.enabled = true;
            break
        default:
            break
        }
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch(section){
    
        case 2:
            return "可设置为每日、工作日、周末"
            //break
        default:
            return ""
            //break
        }
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.section == Constant.NotificationSetCellIndex){
            switch self.planSetMode {
            case .edit:
                self.initEditedPlanData()
                break
            default:
                break
            }
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
    
        switch(indexPath.section){
        case Constant.ActivitySetCellIndex:
            tableView.rowHeight = 112
            let cell = tableView.dequeueReusableCellWithIdentifier(Constant.ActivitySetCellIndentifier, forIndexPath: indexPath) as! PlanSetViewActivitySetCell
            self.planActivitySetCell = cell
            
            return cell
        case Constant.LabelSetCellIndex:
            tableView.rowHeight = 48
            let cell = tableView.dequeueReusableCellWithIdentifier(Constant.LabelSetCellIndentifier, forIndexPath: indexPath) as! PlanSetViewLabelSetCell
            
            //cell.superViewController = self
            cell.labelSetTextField.delegate = self
            self.planLabelSetCell = cell
            
            return cell
        case Constant.PatternSetCellIndex:
            tableView.rowHeight = 48
            let cell = tableView.dequeueReusableCellWithIdentifier(Constant.PatternSetCellIndentifier, forIndexPath: indexPath) as! PlanSetViewPatternSetCell
            cell.patternSetLabel.text = "未设置"
      
            self.planPatternSetCell = cell
            return cell
            
        case Constant.TimeSetCellIndex:
            tableView.rowHeight = 48
            let cell = tableView.dequeueReusableCellWithIdentifier(Constant.TimeSetCellIndentifier, forIndexPath: indexPath) as! PlanSetViewTimeSetCell
            cell.timeSetLabel.text = "未设置"
            self.planTimeSetCell = cell
            return cell
            
        case Constant.NotificationSetCellIndex:
            tableView.rowHeight = 48
            let cell = tableView.dequeueReusableCellWithIdentifier(Constant.NotificationSetCellIndentifier, forIndexPath: indexPath) as! PlanSetViewNotificationSetCell
            
            self.planNotificationSetCell = cell
            
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("defaultCell", forIndexPath: indexPath)
            return cell
            
        }
    }
 
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        switch(indexPath.section){
        case 2:
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                
                if (cell.selected == false){
                    self.planLabelSetCell.labelSetTextField.endEditing(true)
                    hideTimeSetView()
                    
                    showPatternSetView()
                    return indexPath
                }else{
                    cell.selected = false
                    hidePatternSetView()
                    return nil
                }
            }else{
                return nil
            }
            
            break
        case 3:
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                
                if (cell.selected == false){
                    
                    self.planLabelSetCell.labelSetTextField.endEditing(true)

                    hidePatternSetView()
                    showTimeSetView()
                    return indexPath
                }else{
                    cell.selected = false
                    hideTimeSetView()
                    return nil
                }
            }else{
                return nil
            }

            break
        default:
            return indexPath
            break
        }
    }

    
    func showPatternSetView(){
        view.insertSubview(patternSetView, atIndex: 10)
        
        
        //if #available(iOS 9.0, *) {
            
            let bottomConstraint = patternSetView.topAnchor.constraintEqualToAnchor(self.view.bottomAnchor)
            
            let leftConstraint = patternSetView.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor)
            
            let rightConstraint = patternSetView.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor)
            
            let heightConstraint = patternSetView.heightAnchor.constraintEqualToConstant(160)

            NSLayoutConstraint.activateConstraints([bottomConstraint,leftConstraint,rightConstraint,heightConstraint])
            
        //}
      
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()

        patternSetView.layer.shadowRadius = 12
        patternSetView.layer.shadowColor = CGColorCreate(colorSpace, [CGFloat]([0,0,0,1]))!
        patternSetView.layer.shadowOpacity = 0.5
        patternSetView.layer.shadowOffset = CGSizeMake(6, 6)
        
        patternSetView.layer.cornerRadius = 8
        
        view.layoutIfNeeded()
        
        
        UIView.animateWithDuration(0.3, animations: { self.patternSetView.frame = CGRectMake(0, self.screenHeight - self.patternSetView.frame.height, self.patternSetView.frame.width, self.patternSetView.frame.height) },completion:{done in})

    }
    
    func showTimeSetView(){
        
        timeSetView.hourTitles = []

        switch selectedActivityTag {
        case PlanActivityTag.GetUpActivityTag:
            for i in 07...23{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            for i in 00...06{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            break
        case PlanActivityTag.BreakfastActivityTag:
            for i in 08...23{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            for i in 00...07{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            break
        case PlanActivityTag.LunchActivityTag:
            for i in 12...23{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            for i in 00...11{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            break
        case PlanActivityTag.DinnerActivityTag:
            for i in 18...23{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            for i in 00...17{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            break
        case PlanActivityTag.SleepActivityTag:
            for i in 23...23{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            for i in 00...22{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            break
        case PlanActivityTag.ExtActivityTag:
          
            for i in 00...23{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            break
        default:
            for i in 00...23{
                timeSetView.hourTitles.append(String.init(format: "%02d", i))
            }
            break
        }
        
        
        timeSetView.minuteTitles = []
        for i in 0...59{
           timeSetView.minuteTitles.append(String.init(format: "%02d", i))
        }
        
        timeSetView.refreshPickerViews()
        
        view.insertSubview(timeSetView, atIndex: 10)
        
        //if #available(iOS 9.0, *) {
            
            let bottomConstraint = timeSetView.topAnchor.constraintEqualToAnchor(self.view.bottomAnchor)
            
            let leftConstraint = timeSetView.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor)
            
            let rightConstraint = timeSetView.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor)
            
            let heightConstraint = timeSetView.heightAnchor.constraintEqualToConstant(160)
            
            NSLayoutConstraint.activateConstraints([bottomConstraint,leftConstraint,rightConstraint,heightConstraint])
            
        //} 
       
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        timeSetView.layer.shadowRadius = 12
        timeSetView.layer.shadowColor = CGColorCreate(colorSpace, [CGFloat]([0,0,0,1]))!
        timeSetView.layer.shadowOpacity = 0.5
        timeSetView.layer.shadowOffset = CGSizeMake(6, 6)
        
        timeSetView.layer.cornerRadius = 8
        
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.3, animations: { self.timeSetView.frame = CGRectMake(0, self.screenHeight - self.timeSetView.frame.size.height, self.timeSetView.frame.size.width, self.timeSetView.frame.size.height) },completion:{done in})
        
    }
    
    func hidePatternSetView(){
        UIView.animateWithDuration(0.3, animations: {self.patternSetView.frame = CGRectMake(0, self.screenHeight, self.patternSetView.frame.size.width, self.patternSetView.frame.size.height)},
                                   completion:{completed in
                                    if completed==true && self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.selected == false && self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3))!.selected == false {
                                        self.patternSetView.removeFromSuperview() 
                                    }
        })
    }

    func hideTimeSetView(){
        UIView.animateWithDuration(0.3, animations: {self.timeSetView.frame = CGRectMake(0, self.screenHeight, self.timeSetView.frame.size.width, self.timeSetView.frame.size.height)},
                                   completion:{completed in
                                    if completed==true && self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))!.selected == false && self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3))!.selected == false {
                                        self.timeSetView.removeFromSuperview()
                                    }
        })
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
