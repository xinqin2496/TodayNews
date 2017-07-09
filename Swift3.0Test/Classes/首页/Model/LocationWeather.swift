//
//  LocationWeather.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/9.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class LocationWeather: NSObject {

    var dat_condition : String?
    var dat_low_temperature : Int?
    var wind_direction : String?
    var high_temperature : Int?
    var low_temperature : Int?
    var current_time : Int?
    var tomorrow_weather_icon_id : String?
    var dat_high_temperature : Int?
    var tomorrow_aqi : Int?
    var wind_level : Int?
    var moji_city_id : Int?
    var aqi : Int?
    var dat_weather_icon_id : String?
    var update_time : String?
    var day_condition : String?
    var night_condition : String?
    var tomorrow_quality_level : String?
    var city_name : String?
    var tomorrow_condition : String?
    var current_condition : String?
    var current_temperature : Int?
    var tomorrow_low_temperature : Int?
    var quality_level : String?
    var tomorrow_high_temperature : Int?
    
    init(dict:[String :AnyObject]) {
        super.init()
        dat_condition = dict["dat_condition"] as? String
        dat_low_temperature = dict["dat_low_temperature"] as? Int
        wind_direction = dict["wind_direction"] as? String
        high_temperature = dict["high_temperature"] as? Int
        low_temperature = dict["low_temperature"] as? Int
        current_time = dict["current_time"] as? Int
        tomorrow_weather_icon_id = dict["tomorrow_weather_icon_id"] as? String
        dat_high_temperature = dict["dat_high_temperature"] as? Int
        tomorrow_aqi = dict["tomorrow_aqi"] as? Int
        wind_level = dict["wind_level"] as? Int
        moji_city_id = dict["moji_city_id"] as? Int
        aqi = dict["aqi"] as? Int
        
        dat_weather_icon_id = dict["dat_weather_icon_id"] as? String
        update_time = dict["update_time"] as? String
        day_condition = dict["day_condition"] as? String
        night_condition = dict["night_condition"] as? String
        tomorrow_quality_level = dict["tomorrow_quality_level"] as? String
        city_name = dict["city_name"] as? String
        tomorrow_condition = dict["tomorrow_condition"] as? String
        current_condition = dict["current_condition"] as? String
        
        current_temperature = dict["current_temperature"] as? Int
        tomorrow_low_temperature = dict["tomorrow_low_temperature"] as? Int
        quality_level = dict["quality_level"] as? String
        tomorrow_high_temperature = dict["tomorrow_high_temperature"] as? Int
    }
}
