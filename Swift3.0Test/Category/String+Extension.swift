//
//  String+Extension.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/17.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import Foundation

extension String {
    

    
    ///把String转成CGFloat
    func StringToFloat() -> CGFloat{
        
        var cgFloat: CGFloat = 0
        
        if let doubleValue = Double(self)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    /// String -> Int
    func stringToInt() -> Int{
        
        var int: Int?
        if let doubleValue = Int(self) {
            int = Int(doubleValue)
        }
        if int == nil
        {
            return 0
        }
        return int!
    }

    ///得到周几
    static func getWeekFormDateStr(_ dateString :String) -> String{
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        let date = dateFormat.date(from: dateString)
        let interval = Int(date!.timeIntervalSince1970) + TimeZone.current.secondsFromGMT()
        
        let days = Int(interval/86400)
        let weekday = ((days + 4)%7+7)%7
        
        var week : String?
        switch weekday {
        case 0:
            week = "周日"
        case 1:
            week = "周一"
        case 2:
            week = "周二"
        case 3:
            week = "周三"
        case 4:
            week = "周四"
        case 5:
            week = "周五"
        case 6:
            week = "周六"
        default:
            week = ""
        }
        let currentDateStr = dateFormat.string(from: Date())
        
        let day = compareInputDateDifference(dateString, currentDateStr)
        
        if day == -1 {
            week = "昨天"
        }else if day == 0{
            week = "今天"
        }else if day == 1{
            week = "明天"
        }
        
        return week!
    }
    /// 得到 MM/dd 格式 5/1
    static func getMonthAndDay(_ dateString : String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        let currentDate = dateFormat.date(from: dateString)
        dateFormat.dateFormat = "MM/dd"
        let monthDayStr = dateFormat.string(from: currentDate!)
        
        return monthDayStr
        
    }
    ///对比两个时间字符串 得到相差的天数
    static func compareInputDateDifference(_ oneDateStr :String ,_ inputDateStr : String) -> Int {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        let oneDate = dateFormat.date(from: oneDateStr)
        let inputDate = dateFormat.date(from: inputDateStr)
    
       let second = oneDate!.timeIntervalSince(inputDate!)
        
        var day : Int
        
        if second < 0 {// oneDate < inputDate 比较的是天数
            
            day =  Int(second) / (48 * 60 * 60 ) - 1
            
        }else if second > 0{ // oneDate > inputDate
            
            day =  Int(second) / (48 * 60 * 60 ) + 1
            
        }else{// oneDate = inputDate
            
            day = Int(second) / (48 * 60 * 60 )
        }
        
        return day
    }
    ///得到星期
    static func getWeekDay(_ dateTime:String) -> String {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        let date = dateFormat.date(from: dateTime)
        let interval = Int(date!.timeIntervalSince1970) + TimeZone.current.secondsFromGMT()
        
        let days = Int(interval/86400)
        let weekday = ((days + 4)%7+7)%7
        
        var week : String?
        switch weekday {
        case 0:
            week = "星期天"
        case 1:
            week = "星期一"
        case 2:
            week = "星期二"
        case 3:
            week = "星期三"
        case 4:
            week = "星期四"
        case 5:
            week = "星期五"
        case 6:
            week = "星期六"
        default:
            week = ""
        }
        
        return week!
    }
    
    
    //得到农历
    static func getChineseCalendarWithDate(_ dateString : String) -> String {
        
        let chineseYears = ["甲子",   "乙丑",  "丙寅",  "丁卯",  "戊辰",  "己巳",  "庚午",  "辛未",  "壬申",  "癸酉",
                            "甲戌",   "乙亥",  "丙子",  "丁丑",  "戊寅",  "己卯",  "庚辰",  "辛己",  "壬午",  "癸未",
                            "甲申",   "乙酉",  "丙戌",  "丁亥",  "戊子",  "己丑",  "庚寅",  "辛卯",  "壬辰",  "癸巳",
                            "甲午",   "乙未",  "丙申",  "丁酉",  "戊戌",  "己亥",  "庚子",  "辛丑",  "壬寅",  "癸丑",
                            "甲辰",   "乙巳",  "丙午",  "丁未",  "戊申",  "己酉",  "庚戌",  "辛亥",  "壬子",  "癸丑",
                            "甲寅",   "乙卯",  "丙辰",  "丁巳",  "戊午",  "己未",  "庚申",  "辛酉",  "壬戌",  "癸亥"]
        
        let chineseMonths = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月","九月", "十月", "冬月", "腊月",]
        
        let chineseDays = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
                           "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
                           "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
        var dateTemp : Date?
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        dateTemp = dateFormat.date(from: dateString)
        
        let localeCalendar = Calendar(identifier: Calendar.Identifier.chinese)
        
        let localeComp = (localeCalendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from:dateTemp!)
        
        let yearStr = chineseYears[localeComp.year! - 1]
        let monthStr = chineseMonths[localeComp.month! - 1]
        let dayStr = chineseDays[localeComp.day! - 1]
        
        let chineseCal_str = "农历\(yearStr)年\(monthStr)\(dayStr)"
        
        return chineseCal_str
        
    }
}
