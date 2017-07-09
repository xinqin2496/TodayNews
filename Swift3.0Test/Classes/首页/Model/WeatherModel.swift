//
//  WeatherModel.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/17.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

//网页版 中华万年历的天气 http://yun.rili.cn/tianqi/index.html?city=101020100

class WeatherModel: NSObject {

    var evn : evnModel?
    
    var observe : observeModel?
    
    var forecast15 = [WeatherForecastModel]()
    
    var hourfc = [WeatherHourfcModel]()
    
    var indexes = [WeatherIndexesModel]()
    
    init(dict :[String :AnyObject]) {
        super.init()
        
        if let evnDict = dict["evn"] {
            evn = evnModel(dict: evnDict as! [String : AnyObject])
        }
        
        if let observeDict = dict["observe"] {
            observe = observeModel(dict: observeDict as! [String : AnyObject])
        }
        
        
        if let forecastArr = dict["forecast15"] as? [AnyObject] {
            for item in forecastArr {
                let forecast = WeatherForecastModel(dict: item as! [String : AnyObject])
                forecast15.append(forecast)
            }
        }
        
        if let hourfcArr = dict["hourfc"] as? [AnyObject] {
            for item in hourfcArr {
                let hour = WeatherHourfcModel(dict: item as! [String : AnyObject])
                hourfc.append(hour)
            }
        }
        
        if let indexesArr = dict["indexes"] as? [AnyObject] {
            for item in indexesArr {
                let index = WeatherIndexesModel(dict: item as! [String : AnyObject])
                indexes.append(index)
            }
        }
    }
    
    
}

class evnModel: NSObject {
    
    var aqi  : Int?
    var co  : Int?
    var no2  : Int?
    var o3  : Int?
    var pm10  : Int?
    var pm25  : Int?
    var so2  : Int?
    var mp : String?
    var quality : String?
    var suggest : String?
    var time : String?
    
    init(dict:[ String : AnyObject]) {
        super .init()
        
         aqi = dict["aqi"] as? Int
         co = dict["co"] as? Int
         no2 = dict["no2"] as? Int
         o3 = dict["o3"] as? Int
         pm10 = dict["pm10"] as? Int
         pm25 = dict["pm25"] as? Int
         so2 = dict["so2"] as? Int
         mp = dict["mp"] as? String
         quality = dict["quality"] as? String
         suggest = dict["suggest"] as? String
         time = dict["time"] as? String
    }
}
//15天数据
class WeatherForecastModel: NSObject {
    
    var aqi : Int?
    var date : String?
    var high : Int?
    var low :  Int?
    var sunrise  : String?
    var sunset : String?
    var day : dayOrNight?
    var night :dayOrNight?
    
    init(dict:[ String : AnyObject]) {
        super.init()
        aqi = dict["aqi"] as? Int
        date = dict["date"] as? String
        high = dict["high"] as? Int
        low = dict["low"] as? Int
        sunrise = dict["sunrise"] as? String
        sunset = dict["sunset"] as? String
        if let dayDict = dict["day"] {
            day = dayOrNight(dict: dayDict as! [String :AnyObject])
        }
        if let nightDict = dict["night"] {
            night = dayOrNight(dict: nightDict as! [String :AnyObject])
        }
    }
}

class dayOrNight: NSObject {
    
    var bgPic : String?
    var notice : String?
    var type : String?
    var wd  : String?
    var wp : String?
    var wthr : String?
    
    init(dict:[ String : AnyObject]) {
        
        super.init()
        bgPic = dict["bgPic"] as? String
        notice = dict["notice"] as? String
        type = dict["type"] as? String
        wd = dict["wd"] as? String
        wp = dict["wp"] as? String
        wthr = dict["wthr"] as? String
    }
    
}
//24小时数据
class WeatherHourfcModel:NSObject {
    
    var hourfcUrl :String?
    var shidu   : String?
    var time : String?
    var type : Int?
    var wd   : String?
    var wp : String?
    var wthr : Int?
    
    init(dict:[ String : AnyObject]) {
        
        super.init()
        hourfcUrl = dict["hourfcUrl"] as? String
        shidu = dict["shidu"] as? String
        time = dict["time"] as? String
        type = dict["type"] as? Int
        wd = dict["wd"] as? String
        wp = dict["wp"] as? String
        wthr = dict["wthr"] as? Int
    }
    
}
//生活指数
class WeatherIndexesModel:NSObject {
    
    var desc :String?
    var name   : String?
    var value   : String?
    var valueV2 : String?
    
    init(dict:[ String : AnyObject]) {
        
        super.init()
        desc = dict["desc"] as? String
        name = dict["name"] as? String
        value = dict["value"] as? String
        valueV2 = dict["valueV2"] as? String
    }
    
}

class observeModel: NSObject {
    
    var shidu : String?
    var wd : String?
    var wp : String?
    var temp : Int?
    var tigan : Int?
    
    init(dict:[ String : AnyObject]) {
        super.init()
        shidu = dict["shidu"] as? String
        wd = dict["wd"] as? String
        wp = dict["wp"] as? String
        temp = dict["temp"] as? Int
        tigan = dict["tigan"] as? Int
    }
    
}


