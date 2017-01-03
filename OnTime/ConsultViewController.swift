//
//  ConsultViewController.swift
//  OnTime
//
//  Created by Atom on 16/8/15.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class ConsultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    enum MessageSender{
        case consultant
        case user
    }
    
    struct MessageVars{
        var text:String
        var sender:MessageSender
        var loaded:Bool
    }
    
    struct constant{
        static let sendMessageViewFrameHeight:CGFloat = 42
        
        static let messageTextFontSize:CGFloat = 14
        
        static let messageBubbleImageViewSpacingToLeftOrRightMargins:CGFloat = 64
        static let messageBubbleImageViewSpacingToTopMargins:CGFloat = 12
        static let messageBubbleImageViewExtraWidthToTextLabelWidth:CGFloat = 36
        static let messageBubbleImageViewExtraHeightToTextLabelHeight:CGFloat = 24
        
        static let messageTextBoundingRectWidth:Double = 188
        static let messageTextLabelSpacingToLeftOrRightMargins:CGFloat = constant.messageBubbleImageViewSpacingToLeftOrRightMargins + 20
        static let messageTextLabelSpacingToTopMargins:CGFloat = constant.messageBubbleImageViewSpacingToTopMargins + 8
        
        static let messageSenderImageViewSpacingToLeftOrRightMargins:CGFloat = 8
        static let messageSenderImageViewSpacingToTopMargins:CGFloat = 8
        
        static let messageSenderImageSideLength:CGFloat = 48
        
        static let tableViewRowExtraHeightToTextBoundingRectHeight:CGFloat = 2*constant.messageBubbleImageViewSpacingToTopMargins +
            constant.messageBubbleImageViewExtraHeightToTextLabelHeight + 8
        
    }
    
    let consultantTexts = [
        "welcome1":"Hi! 请问你需要什么帮助吗？😊",
        
        "welcome2":"回复1 了解睡眠不规律的危害\n回复2 了解饮食不规律的危害\n回复3 获取推荐日常作息时间表",
        
        "respond1":"睡眠不规律的危害包括：\n1. 短期记忆力衰退\n2. 学习能力下降\n3. 内分泌系统紊乱\n4. 免疫系统能力下降\n5. 心脏疾病风险增加\n6. 罹患癌症风险增加\n\nIn other words, 睡眠不规律会让人变胖、变丑、变笨、记忆力下降、容易忘事、容易生病、等等等等，甚至还会让人更易患上癌症！😱",
        
        "respond2":"饮食不规律的危害包括：\n1. 打乱胃肠消化的生物钟，诱发胃肠疾病，严重损害胃肠功能\n\n2. 引起营养失衡，导致皮肤干燥、贫血、细胞衰老等营养缺乏症状，诱发骨质疏松\n\n3. 造成胃结肠反射作用失调，产生便秘等症状，导致身体排毒不畅，引发皮肤疾病，如痤疮",
        
        "respond3":"推荐日常作息时间表：\n07:00-07:10 ⏰起床\n07:10-07:30 🚽晨起排便\n07:30-08:00 🚰洗漱\n08:00-08:30 🍞吃早餐\n08:30-09:00 🚫避免运动\n09:00-10:30 📚工作学习\n10:30-11:00 🍎吃点水果\n11:00-12:00 🎲自由活动\n12:00-12:30 🍱吃午饭\n12:30-14:00 😴午间休息\n14:00-15:40 🎲自由活动\n15:40-17:00 ⛹🏻锻炼身体\n17:00-18:00 🎲自由活动\n18:00-18:30 🍛吃晚饭\n18:30-18:50 😪饭后小憩\n18:50-19:10 🚶🏻饭后慢走\n19:10-19:30 🍼喝杯酸奶\n19:30-21:00 🎲自由活动\n21:30-22:00 🚿洗澡\n22:00-23:00 🛋睡前放松\n23:00-次日07:00 💤睡觉",
        
        "chat1":"身体是革命的本钱！💰💰",
        
        "chat2":"健康是人生大写的“1”，而财富、事业、家庭、感情等等都是1后面的0，只有依附于这个1，0的存在才会有意义，如果没有了这个1，即使有再多的0，最终一切也只有0啊！😔",
        
        "chat3":"珍爱生命👼🏻，远离熬夜！",
        
        "chat4":"早餐吃好、午餐吃饱、晚餐吃少！"
        
    ]
    
    let consultantChatNum:Int = 4
    //var oldViewFrameHeight:CGFloat!
    var oldViewFrame:CGRect!

    var messageSenderImageNames = [MessageSender.consultant:"mushroom",MessageSender.user:"snail"]
    var messageBubbleImageNames = [MessageSender.consultant:"message_bubble_1",MessageSender.user:"message_bubble_2"]

    var messagesVars:[MessageVars] = []
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.delegate = self
            
        }
    }
    
    @IBOutlet weak var messageSendView: UIView!{
        didSet{
        }
    }

    @IBAction func onClickSendMessageBtn(sender: UIButton?) {
        if(textField.text != ""){
            var text = textField.text!
            textField.text = ""
            self.messagesVars.append(MessageVars(text: text, sender: MessageSender.user, loaded: false))
            
            self.tableView.reloadData()

//            UIView.animateWithDuration(1.0,
//                animations: {
//                    self.tableView.contentOffset.y = max(0, self.tableView.contentSize.height-self.tableView.frame.height)
//                }, completion: nil)
            self.tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: self.messagesVars.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
            self.performSelector("consultantRespond:", withObject: text, afterDelay:1.5)
            
            //self.tableView.insertRowsAtIndexPaths([NSIndexPath.init(forRow: (self.messagesVars.count-1), inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
            //print("self.messagesVars:",self.messagesVars)
            
        }
    }
    
    func consultantRespond(text:String){
       
        switch(text){
        case "1":
            self.messagesVars.append(MessageVars(text: consultantTexts["respond1"]!, sender: MessageSender.consultant, loaded: false))
            break
        case "2":
            self.messagesVars.append(MessageVars(text: consultantTexts["respond2"]!, sender: MessageSender.consultant, loaded: false))
            break
        case "3":
            self.messagesVars.append(MessageVars(text: consultantTexts["respond3"]!, sender: MessageSender.consultant, loaded: false))
            break
        default:
            let randForSelectText = Int(arc4random())%(self.consultantChatNum+1)
            switch randForSelectText {
            case 0:
                self.messagesVars.append(MessageVars(text: consultantTexts["welcome2"]!, sender: MessageSender.consultant, loaded: false))
                break
            default:
                let textKey = String.init(format: "chat%d", randForSelectText)
                self.messagesVars.append(MessageVars(text: consultantTexts[textKey]!, sender: MessageSender.consultant, loaded: false))
                break
            }
            
            break
        }
        self.tableView.reloadData()
        
        
        self.tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: self.messagesVars.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
//        UIView.animateWithDuration(1.0,
//            animations: {
//                self.tableView.contentOffset.y = max(0, self.tableView.contentSize.height-self.tableView.frame.height)
//            }, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messagesVars.append(MessageVars(text: consultantTexts["welcome1"]!, sender: MessageSender.consultant, loaded: false))
        self.messagesVars.append(MessageVars(text: consultantTexts["welcome2"]!, sender: MessageSender.consultant, loaded: false))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 5.0{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //self.oldViewFrameHeight = self.view.frame.height
        self.oldViewFrame = self.view.frame
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesVars.count
    }
    
    func keyboardWillShow(aNotification:NSNotification){
        let info = aNotification.userInfo! as NSDictionary
        let keyboardRect = info.objectForKey(UIKeyboardFrameEndUserInfoKey)!.CGRectValue()
        
        if self.textField.editing{
            moveTextFieldWithKeyboardHeight(self.textField, keyboardHeight: keyboardRect.height)
        }
    }
    
    func keyboardWillHide(aNotification:NSNotification){
      
        UIView.animateWithDuration(1.0,
            animations: {

//                var frame = self.view.frame
//                frame.size = CGSizeMake(frame.size.width, self.oldViewFrameHeight)
//                self.view.frame = frame
                self.view.frame = CGRectMake(0,  self.oldViewFrame.origin.y, self.oldViewFrame.width, self.oldViewFrame.height)

            },
           completion:{(completed) -> Void in
                if(completed == true){

                }
            }
        )
    }
    
    func moveTextFieldWithKeyboardHeight(textField: UITextField, keyboardHeight :CGFloat){
//        print("self.view frame is ",self.view.frame)
//        print("self.tableView.frame is ",self.tableView.frame)
        self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y,self.tableView.superview!.frame.width, self.tableView.superview!.frame.height-constant.sendMessageViewFrameHeight)
        
        self.messageSendView.frame = CGRectMake(0,self.messageSendView.superview!.frame.height-constant.sendMessageViewFrameHeight,self.messageSendView.superview!.frame.width, constant.sendMessageViewFrameHeight)
        
 
        UIView.animateWithDuration(1.0,
            animations: {
//                var frame = self.view.frame
//                frame.size = CGSizeMake(frame.size.width, self.oldViewFrameHeight-keyboardHeight)
//                self.view.frame = frame
                
                self.view.frame = CGRectMake(0, self.oldViewFrame.origin.y, self.oldViewFrame.width, self.oldViewFrame.height-keyboardHeight)
                
                self.tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: self.messagesVars.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            },
            completion:{(completed) -> Void in
                if(completed == true){
                    

                }
            }
        )
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let text = self.messagesVars[indexPath.row].text
        
    
        let textBoundingRect = NSString.init(string: text).boundingRectWithSize(CGSize.init(width: constant.messageTextBoundingRectWidth, height: Double(MAXFLOAT)), options: [NSStringDrawingOptions.UsesLineFragmentOrigin,NSStringDrawingOptions.UsesFontLeading], attributes: [NSFontAttributeName:UIFont.systemFontOfSize(constant.messageTextFontSize)], context: nil)
        return textBoundingRect.height+constant.tableViewRowExtraHeightToTextBoundingRectHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("testCell")
        as UITableViewCell!
        
        while (cell.contentView.subviews.last != nil) {
            cell.contentView.subviews.last?.removeFromSuperview()
        }
        
        let sender:MessageSender = self.messagesVars[indexPath.row].sender
        

        let text = self.messagesVars[indexPath.row].text
        
        let textBoundingRect = NSString.init(string: text).boundingRectWithSize(CGSize.init(width: constant.messageTextBoundingRectWidth, height: Double(MAXFLOAT)), options: [NSStringDrawingOptions.UsesLineFragmentOrigin,NSStringDrawingOptions.UsesFontLeading], attributes: [NSFontAttributeName:UIFont.systemFontOfSize(constant.messageTextFontSize)], context: nil)
        
        let keyWindow = UIApplication.sharedApplication().keyWindow!
        
        var textLabelFrameMinX:CGFloat = 0
        var messageBubbleImageViewFrameMinX:CGFloat = 0
        var messageBubbleImageName:String = messageBubbleImageNames[sender]!
        var senderImageName:String = messageSenderImageNames[sender]!
        var senderImageViewFrameMinX:CGFloat = 0
        
        if(sender == MessageSender.consultant){
            textLabelFrameMinX = constant.messageTextLabelSpacingToLeftOrRightMargins
            messageBubbleImageViewFrameMinX = constant.messageBubbleImageViewSpacingToLeftOrRightMargins
            //messageBubbleImageName = messageBubbleImageNames[MessageSender.consultant]!
            //senderImageName = messageSenderImageNames  [MessageSender.consultant]!
            senderImageViewFrameMinX = constant.messageSenderImageViewSpacingToLeftOrRightMargins
            
        }else if(sender == MessageSender.user){
            textLabelFrameMinX = keyWindow.frame.width - constant.messageTextLabelSpacingToLeftOrRightMargins - textBoundingRect.width
            messageBubbleImageViewFrameMinX = keyWindow.frame.width - constant.messageBubbleImageViewSpacingToLeftOrRightMargins - (textBoundingRect.width+constant.messageBubbleImageViewExtraWidthToTextLabelWidth)
            //messageBubbleImageName =
            //senderImageName = messageSenderImageNames  [MessageSender.user]!
            senderImageViewFrameMinX = keyWindow.frame.width - constant.messageSenderImageViewSpacingToLeftOrRightMargins - constant.messageSenderImageSideLength
        }
        
        let messageBubbleImage:UIImage = UIImage.init(named: messageBubbleImageName)!
        let messageBubbleImageView:UIImageView = UIImageView.init(image: messageBubbleImage.stretchableImageWithLeftCapWidth(Int(messageBubbleImage.size.width*1/2.0), topCapHeight: Int(messageBubbleImage.size.height*2/3.0)))
        
        messageBubbleImageView.frame = CGRect(x: messageBubbleImageViewFrameMinX, y: constant.messageBubbleImageViewSpacingToTopMargins, width: textBoundingRect.width+constant.messageBubbleImageViewExtraWidthToTextLabelWidth, height: textBoundingRect.height+constant.messageBubbleImageViewExtraHeightToTextLabelHeight)
        //print("messageBubbleImageView.frame is ",messageBubbleImageView.frame)
        
        let textLabel = UILabel.init(frame: CGRect.init(x: textLabelFrameMinX, y: constant.messageTextLabelSpacingToTopMargins, width: textBoundingRect.width, height: textBoundingRect.height))
        
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.font = UIFont.systemFontOfSize(14.0)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        textLabel.text = self.messagesVars[indexPath.row].text
        
        
        let senderImage = UIImage.init(named: senderImageName)
        let senderImageView = UIImageView.init(image: senderImage)
        senderImageView.frame = CGRect(x: senderImageViewFrameMinX, y: constant.messageSenderImageViewSpacingToTopMargins, width: constant.messageSenderImageSideLength, height: constant.messageSenderImageSideLength)
        
        //textView.text = self.texts[indexPath.row]
        //textView.translatesAutoresizingMaskIntoConstraints = false
        senderImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        cell.contentView.addSubview(senderImageView)
        cell.contentView.addSubview(messageBubbleImageView)
        cell.contentView.addSubview(textLabel)
        
        if(self.messagesVars[indexPath.row].loaded==false){
            if(indexPath.row == self.messagesVars.count-1){
                //print("this is the last cell!")
                cell.alpha = 0;
                cell.frame = CGRect(x: cell.frame.minX,y: cell.frame.minY+20,width: cell.frame.width,height: cell.frame.height)
                
                UIView.animateWithDuration(1.0,
                   animations:{
                      cell.frame = CGRect(x: cell!.frame.minX,y: cell.frame.minY,width: cell.frame.width,height: cell!.frame.height)
                      cell.alpha = 1
                    },
                   completion: nil)
            }
            self.messagesVars[indexPath.row].loaded=true

        }
        
        
        return cell
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.onClickSendMessageBtn(nil)
        if textField == self.textField{
            textField.resignFirstResponder()
        }
        return true
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
