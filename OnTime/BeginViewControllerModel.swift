//
//  BeginViewControllerModel.swift
//  OnTime
//
//  Created by Atom on 16/5/10.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class BeginViewControllerModel : NSObject, UIPageViewControllerDataSource {
    
    var pageHeadlines: [String] = []
    var pageImages: [UIImage] = []
    
    private struct constantData{
        static let numberOfPages:Int = 4
        static let pageHeadlines:[String!] =
            ["Get Up on Time!",
             "Eat on Time!",
             "Sleep on Time!",
             "Live on Time Now!"]
        static var pageImages: [UIImage!] =
            [nil,
             nil,
             nil,
             nil]
        static var pageImageLabelTexts: [String!] =
            ["⏰",
             "🍱",
             "😴",
             "🕓"]
    }
    
    override init() {
        super.init()

    }
    
    func viewControllerAtIndex(index:Int, storyboard:UIStoryboard) -> BeginPageViewController?{
        if(index >= constantData.numberOfPages){
            return nil
        }
        
        let pageViewController = storyboard.instantiateViewControllerWithIdentifier("BeginPageViewController") as! BeginPageViewController
      
        pageViewController.pageIndex = index
        pageViewController.headline = constantData.pageHeadlines[index]
        pageViewController.image = constantData.pageImages[index]
        pageViewController.imageLabelText = constantData.pageImageLabelTexts[index]
        return pageViewController
    }
    
    func indexOfViewController(viewController: BeginPageViewController)->Int{
        return viewController.pageIndex ?? NSNotFound
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! BeginPageViewController)
        if index == 0 || index == NSNotFound{
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! BeginPageViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == constantData.numberOfPages {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
}
