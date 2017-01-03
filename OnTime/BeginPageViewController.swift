//
//  BeginPageViewController.swift
//  OnTime
//
//  Created by Atom on 16/5/10.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class BeginPageViewController: UIViewController {

    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!{
        didSet{
            
            startButton.layer.cornerRadius = 8
            startButton.layer.masksToBounds = true
            
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBAction func onTouchStartBtn(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstLaunch")

        let newController = storyboard?.instantiateViewControllerWithIdentifier("HomeNavigationController") as UIViewController!
        
        newController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        newController.modalTransitionStyle = .FlipHorizontal
        
        self.presentViewController(newController, animated: true, completion: nil)
        
    }

    var pageIndex:Int = 0
    var headline:String = ""
    var imageLabelText:String = ""
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.pageControl.currentPage = pageIndex
        self.headLabel.text = headline
        self.imageView.image = image
        self.imageLabel.text = self.imageLabelText
        if(pageIndex == pageControl.numberOfPages-1){
            self.startButton.hidden = false
            self.startButton.setTitle(" 😼开启有时生活 ", forState: .Normal)
           
        }else{
            self.startButton.hidden = true
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
