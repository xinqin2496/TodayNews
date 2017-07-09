//
//  WeatherPopView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/17.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class WeatherPopView: UIView {

    @IBOutlet weak var dateLb: UILabel!
    
    @IBOutlet weak var nightCode: UILabel!
    @IBOutlet weak var sunsetView: UIView!
    @IBOutlet weak var sunsetLb: UILabel!
    @IBOutlet weak var nightDirLb: UILabel!
    @IBOutlet weak var dayCodeLb: UILabel!
    @IBOutlet weak var dayDirLb: UILabel!
    @IBOutlet weak var sunriseView: UIView!
    @IBOutlet weak var sunriseLb: UILabel!
    
    var forcastModel:WeatherForecastModel? {
        didSet {
            
            let dayDict = forcastModel?.day!
            let nightDict = forcastModel?.night!
            let dateStr = "\(forcastModel!.date!)" as NSString
            let monthStr = dateStr.substring(with: NSMakeRange(4, 2))
            let dayStr = dateStr.substring(with: NSMakeRange(6, 2))
            dateLb.text = "\(monthStr)月\(dayStr)日"
            dayCodeLb.text = "\(dayDict!.wthr!) \(forcastModel!.high!)°C"
            dayDirLb.text = "\(dayDict!.wd!)"
            sunriseLb.text = "日出 \(forcastModel!.sunrise!)"
            
            nightCode.text = "\(nightDict!.wthr!) \(forcastModel!.low!)°C"
            nightDirLb.text = "\(nightDict!.wd!)"
            sunsetLb.text = "日落 \(forcastModel!.sunset!)"
        }
    }
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipRectCorner(direction: .allCorners, cornerRadius: 8)
        sunsetView.clipRectCorner(direction: .allCorners, cornerRadius: 15)
        sunriseView.clipRectCorner(direction: .allCorners, cornerRadius: 15)
    }
}
