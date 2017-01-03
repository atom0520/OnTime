//
//  TimeManager.swift
//  OnTime
//
//  Created by Atom on 16/5/18.
//  Copyright © 2016年 Atom. All rights reserved.
//

import Foundation

class TimeManager{
    static var instance:TimeManager!
    
    static func getInstance() -> TimeManager{
        if(instance != nil){
            return instance
        }else{
            instance = TimeManager()
            return instance
        }
    }
    func getCurrentTime()->Dictionary<String,Int>{
        let currentDate = NSDate()
        
        let calendar = NSCalendar.currentCalendar()
        
        let unitFlags = NSCalendarUnit.init(rawValue: NSCalendarUnit.Year.rawValue | NSCalendarUnit.Month.rawValue | NSCalendarUnit.Day.rawValue | NSCalendarUnit.Hour.rawValue | NSCalendarUnit.Minute.rawValue | NSCalendarUnit.Second.rawValue | NSCalendarUnit.Weekday.rawValue)
        
        let dateComponent = calendar.components(unitFlags, fromDate: currentDate)
       
        //let dateComponent = NSDateComponents()
        
        let year:Int = dateComponent.year
        let month:Int = dateComponent.month
        let day:Int = dateComponent.day
        let hour:Int = dateComponent.hour
        let minute:Int = dateComponent.minute
        let second:Int = dateComponent.second
        let weekday = dateComponent.weekday
        
        return ["year":year,"month":month,"day":day,"hour":hour,"minute":minute,"second":second,"weekday":weekday]

    }
}
