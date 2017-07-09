//
//  WeatherHeaderView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/17.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class WeatherHeaderView: UIView {
    @IBOutlet weak var currentTempLb: UILabel!
    @IBOutlet weak var currentCodeLb: UILabel!
    @IBOutlet weak var humLb: UILabel!
    @IBOutlet weak var dirLb: UILabel!
    @IBOutlet weak var scLb: UILabel!
    @IBOutlet weak var feeLb: UILabel!
    @IBOutlet weak var aqiLb: UILabel!
    @IBOutlet weak var pmLb: UILabel!
    
    @IBOutlet weak var descLb: UILabel!
    
    
    var weatherModel:WeatherModel? {
        didSet{
            
            var observeDict : observeModel?
            
            var evnDict :evnModel?
            
            if let dict = weatherModel?.observe! {
                observeDict = dict
            }
            
            if let dict = weatherModel?.evn! {
                evnDict = dict
            }
            
            let forecastModel = weatherModel?.forecast15[1]
            
            if let currentTemp = observeDict?.temp! {
                currentTempLb.text = "\(currentTemp)"
            }
            
            var contentDict : dayOrNight?
            
            var dayTime : Int?
            
            var nightTime : Int?
            
            if let day = forecastModel?.sunrise {
                let dayStr = (day as NSString).substring(to: 2)
                
                dayTime = Int(dayStr)
            }
            if let night = forecastModel?.sunset {
                nightTime = Int((night as NSString).substring(to: 2))
            }
            
            let currentDate :Date = Date()
            
            let dateFormatter : DateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "HH"
            
            let hour = Int(dateFormatter.string(from: currentDate))
            
            if hour! >= dayTime!   && hour! <= nightTime! {//白天
                
                contentDict = forecastModel?.day!
            }else{
                contentDict = forecastModel?.night!
            }
            
            currentCodeLb.text = contentDict?.wthr!
            humLb.text = observeDict?.shidu!
            dirLb.text = observeDict?.wd!
            scLb.text = observeDict?.wp!
            
            aqiLb.text = "\(evnDict!.aqi!)  \(evnDict!.quality!)"
            
            if let suggest = evnDict?.suggest {
                descLb.text = "\(suggest)"
            }

            if let tiganStr = observeDict?.tigan {
                feeLb.text = "\(tiganStr)"
            }
            let mpstr = evnDict?.mp!
            var pmStr = ""
            
            if (mpstr?.range(of: "PM10")) != nil {
                
                pmStr = "(\(evnDict!.pm10!)ug/m³)/h"
            }else{
                pmStr = "(\(evnDict!.pm25!)ug/m³)/h"
            }
            
            pmLb.text = mpstr! + pmStr
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        aqiLb.adjustsFontSizeToFitWidth = true
        pmLb.adjustsFontSizeToFitWidth = true
    }
    
}
