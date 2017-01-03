//
//  DataManager.swift
//  OnTime
//
//  Created by Atom on 16/5/19.
//  Copyright © 2016年 Atom. All rights reserved.
//

import Foundation

class DataManager{
    static var instance:DataManager!
    
    class UserData:NSObject, NSCoding{
        
        var health:Int = 0
        var happiness:Int = 0
        var glamour:Int = 0
        var plans:[Dictionary<String,AnyObject>] = []
        var lastOpenAppDate:[Int] = []
        
        func encodeWithCoder(aCoder: NSCoder){
            aCoder.encodeObject(self.health, forKey: "health")
            aCoder.encodeObject(self.happiness, forKey: "happiness")
            aCoder.encodeObject(self.glamour, forKey: "glamour")
            aCoder.encodeObject(self.plans, forKey: "plans")
            aCoder.encodeObject(self.lastOpenAppDate, forKey: "lastOpenAppDate")
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init()
            self.health = aDecoder.decodeObjectForKey("health") as! Int
            self.happiness = aDecoder.decodeObjectForKey("happiness") as! Int
            self.glamour = aDecoder.decodeObjectForKey("glamour") as! Int
            self.plans = aDecoder.decodeObjectForKey("plans") as! [Dictionary<String,AnyObject>]
//            if let lastOpenAppDate = aDecoder.decodeObjectForKey("lastOpenAppDate") as? [Int]{
//                self.lastOpenAppDate = lastOpenAppDate
//            }else{
//                self.lastOpenAppDate = []
//            }
            self.lastOpenAppDate = aDecoder.decodeObjectForKey("lastOpenAppDate") as! [Int]
        }
        
        override init() {
          
        }
 
    }
    
    var userData:UserData!
    
    struct constant {
        static let userDataFileName:String = "userData.data"
    }
    
    static func getInstance() -> DataManager{
        if(instance != nil){
            return instance
        }else{
            instance = DataManager()
            if(instance.loadUserDataFromArchiver() == false){
               instance.userData = UserData()

               instance.saveUserDataToArchiver()
            }
            
            return instance
        }
    }
    
    func saveDataToArchiver(fileName:String, data:AnyObject){
        let saveFilePath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString).stringByAppendingString("/\(fileName)")
        //let saveFilePath = NSHomeDirectory().stringByAppendingString(fileName)
        //print("saveFilePath is \(saveFilePath)")
        
        NSKeyedArchiver.archiveRootObject(self.userData!, toFile: saveFilePath)

    }
    
    func saveUserDataToArchiver(){
        saveDataToArchiver(constant.userDataFileName, data:userData)

    }
    
    func loadDataFromArchiver(fileName:String) -> AnyObject?{
        let loadFilePath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString).stringByAppendingString("/\(fileName)")
        //let loadFilePath = NSHomeDirectory().stringByAppendingString(fileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(loadFilePath){
            return NSKeyedUnarchiver.unarchiveObjectWithFile(loadFilePath)
        }else{
            return nil
        }
    }
    
    func loadUserDataFromArchiver() -> Bool{
        
        if let loadUserData = loadDataFromArchiver(constant.userDataFileName) as! UserData?{
            
            self.userData = loadUserData
            return true
        }else{
        
            return false
        }
    }
    
    func sortUserPlanData(){
        var i = self.userData.plans.count-1
        
        while(i>=0){
            var j = 0
            while(j<=i-1){
                var hour1 = self.userData.plans[j]["time"]![0] as! Int
                var min1 = self.userData.plans[j]["time"]![1] as! Int
                var hour2 = self.userData.plans[j+1]["time"]![0] as! Int
                var min2 = self.userData.plans[j+1]["time"]![1] as! Int
                
                if(hour1>hour2){
                    var tempPlanData = self.userData.plans[j]
                    self.userData.plans[j] = self.userData.plans[j+1]
                    self.userData.plans[j+1] = tempPlanData
                }else if(hour1 == hour2 && min1>min2){
                    var tempPlanData = self.userData.plans[j]
                    self.userData.plans[j] = self.userData.plans[j+1]
                    self.userData.plans[j+1] = tempPlanData
                }
                
                j+=1
            }
            i -= 1
        }
    }
    
    func changeUserGlamourBy(dValue:Int){
        self.userData.glamour += dValue
        if(self.userData.glamour<0)
        {
            self.userData.glamour = 0
        }
    }
    
    func changeUserHealthBy(dValue:Int){
        self.userData.health += dValue
        if(self.userData.health<0)
        {
            self.userData.health = 0
        }
        if(self.userData.health>100)
        {
            self.userData.health = 100
        }
        
    }
    
    func changeUserHappinessBy(dValue:Int){
        self.userData.happiness += dValue
        if(self.userData.happiness<0)
        {
            self.userData.happiness = 0
        }
        if(self.userData.happiness>100)
        {
            self.userData.happiness = 100
        }
        
    }
}
