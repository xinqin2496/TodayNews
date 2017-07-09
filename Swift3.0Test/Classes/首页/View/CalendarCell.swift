//
//  CalendarCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/17.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {

    @IBOutlet weak var sunriseLb: UILabel!
    @IBOutlet weak var sunsetLb: UILabel!
    @IBOutlet weak var NLLb: UILabel!
    @IBOutlet weak var weekLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var codeImageView: UIImageView!
    
    
    var model: WeatherForecastModel? {
        didSet{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let currentDateStr = dateFormatter.string(from: Date())
            //截取最后两位
            let index = currentDateStr.index(currentDateStr.endIndex, offsetBy: -2)
            dateLb.text = currentDateStr.substring(from:index)
            weekLb.text = String.getWeekDay(currentDateStr)
            NLLb.text = String.getChineseCalendarWithDate(currentDateStr)
            sunriseLb.text = "日出 \(model!.sunrise!) AM"
            sunsetLb.text = "日落 \(model!.sunset!) PM"
            
            
            /// 设置现在的时间是白天还是晚上
            var contentDict : dayOrNight?
            
            var dayTime : Int?
            
            var nightTime : Int?
            
            if let day = model?.sunrise {
                let dayStr = (day as NSString).substring(to: 2)
                
                dayTime = Int(dayStr)
            }
            if let night = model?.sunset {
                nightTime = Int((night as NSString).substring(to: 2))
            }
            
            let currentDate :Date = Date()
            
            dateFormatter.dateFormat = "HH"
            
            let hour = Int(dateFormatter.string(from: currentDate))
            
            var isDay : Bool?
            
            if hour! >= dayTime! && hour! <= nightTime! {//白天
                
                contentDict = model?.day!
                isDay = true
                
            }else{
                contentDict = model?.night!
                isDay = false
            }
            let wthr = contentDict!.wthr
            
            var codeimageName : String?
            
            if isDay == true {
                codeimageName = "114"
                
                if (wthr?.range(of: "晴")) != nil {
                    codeimageName = "114"
                }
                if (wthr?.range(of: "云")) != nil {
                    codeimageName = "116"
                }
                if (wthr?.range(of: "雨")) != nil {
                    codeimageName = "176"
                }
                if (wthr?.range(of: "阴")) != nil {
                    codeimageName = "120"
                }
                if (wthr?.range(of: "雷阵雨")) != nil {
                    codeimageName = "200"
                }
                
            }else{
                codeimageName = "113"
                if (wthr?.range(of: "晴")) != nil {
                    codeimageName = "113"
                }
                if (wthr?.range(of: "云")) != nil {
                    codeimageName = "117"
                }
                if (wthr?.range(of: "雨")) != nil {
                    codeimageName = "293"
                }
                if (wthr?.range(of: "阴")) != nil {
                    codeimageName = "122"
                }
                if (wthr?.range(of: "雷阵雨")) != nil {
                    codeimageName = "201"
                }
            }

            codeImageView.image = UIImage(named: codeimageName!)

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
