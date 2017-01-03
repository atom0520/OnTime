//
//  AppearancePromptViewController.swift
//  OnTime
//
//  Created by Atom on 16/5/14.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class AppearancePromptViewController: UIViewController {
    
    var text:String!
    
    @IBOutlet weak var textView: UITextView!
        {
        didSet{
            textView.text = self.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredContentSize: CGSize{
        get{
            if (textView != nil && presentingViewController != nil) {
                return textView.sizeThatFits(presentingViewController!.view.frame.size)
            }
            else{
                return super.preferredContentSize
            }
                
        }
        set{
            super.preferredContentSize = newValue

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
