//
//  ForecastCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/18.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    var scrolleViewClick:((_ sender :UIButton) -> ())?
    
    var dailyArray : [WeatherForecastModel]? {
        didSet {
            
            let mintempArray = NSMutableArray()
            let maxtempArray = NSMutableArray()
            
            for i in 0..<(dailyArray?.count)! {
                let model = dailyArray?[i]
                
                let dayLb = scrollView.viewWithTag(i + 1000) as! UILabel
                
                var dateString :String?
                if let dates = model?.date {
                    dateString = "\(dates)"
                }
                
                let dateStr = String.getWeekFormDateStr(dateString!)
                
                dayLb.text = dateStr
                
                let dateLb = scrollView.viewWithTag(i + 2000) as! UILabel
                
                let monthDay = String.getMonthAndDay(dateString!)
                
                dateLb.text = monthDay
                
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
                
                let dateFormatter : DateFormatter = DateFormatter()
                
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
                
                //天气
                let wthr = contentDict!.wthr
                let weatherLb = scrollView.viewWithTag(i + 3000) as! UILabel
                weatherLb.text = wthr!
                
                //最低温
                let mintemp =  model?.low
                let mintempLb = scrollView.viewWithTag(i + 4000) as! UILabel
                mintempLb.text = "\(mintemp!)°C"
                mintempArray.add(mintemp!)
                //最高温
                let maxtemp = model?.high
                let maxtempLb = scrollView.viewWithTag(i + 5000) as! UILabel
                maxtempLb.text = "\(maxtemp!)°C"
                maxtempArray.add(maxtemp!)
                
                //风
                let wind = contentDict!.wd
                let windLb = scrollView.viewWithTag(i + 6000) as! UILabel
                windLb.text = wind!
                
                //风等级
                let level = contentDict!.wp
                let levelLb = scrollView.viewWithTag(i + 7000) as! UILabel
                levelLb.text = level!
                
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
                //天气图片
                let imageView = scrollView.viewWithTag(i + 8000) as! UIImageView
                
                imageView.image = UIImage(named: codeimageName!)
                
                
            }
            let lineView = scrollView.viewWithTag(9000)!

            let maxInt = getArrayMaxValue(maxtempArray)
            
            var num :Int = 0
            
            if maxInt > -30 && maxInt <= -20 {
                num = -20
            }else if maxInt > -20 && maxInt <= -10 {
                num = -10
            }else if maxInt > -10 && maxInt <= 0 {
                num = -5
            }else if maxInt > 0  && maxInt <= 5 {
                num = 10
            }else if maxInt > 5 && maxInt <= 10 {
                num = 25
            }else if maxInt > 10 && maxInt <= 20 {
                num = 40
            }else if maxInt > 20  && maxInt <= 30 {
                num = 60
            }else if maxInt > 30  && maxInt <= 35 {
                num = 70
            }else if maxInt > 35  && maxInt <= 45 {
                num = 80
            }
            
            creatLineViewLine(lineView, maxtempArray, lineView.frame, CGFloat(num))
            creatLineViewLine(lineView, mintempArray, lineView.frame, CGFloat(num))
        }
    }
    
    fileprivate func getArrayMaxValue(_ arr :NSArray) -> Int {
        var max : Int = arr[0] as! Int
        
        for i in 0..<arr.count{
            let index : Int = arr[i] as! Int
            
            if index > max{
                
                max = index
            }
        }
        return max
    }
    //创建天气温度的线
    fileprivate func creatLineViewLine(_ lineView: UIView , _ tempArray : NSMutableArray ,_ layerFrame: CGRect , _ num: CGFloat){
        if tempArray.count == 0 {
            return
        }
        
        let strokepath = UIBezierPath()
        
        let startY = tempArray.firstObject as! Int
        
        strokepath .move(to: CGPoint(x: 0.0, y: CGFloat(-startY) * 2.0 + num))
        
        for i in 0..<tempArray.count {
            
            let temp = tempArray[i] as! Int
            
            strokepath.addLine(to: CGPoint(x: CGFloat(60 * i), y: CGFloat(-temp) * 2 + num))
            let pointView = UIView()
            pointView.backgroundColor = ZZColor(248, g: 144, b: 34, a: 1)
            pointView.layer.masksToBounds = true
            pointView.layer.cornerRadius = 2.5
            pointView.frame = CGRect(x: 60 * i - 1, y: Int(CGFloat(-temp) * 2 - 2 + num), width: 5, height: 5  )
            lineView.addSubview(pointView)
        }
        let layer1 = CAShapeLayer()
        layer1.frame = layerFrame
        layer1.path = strokepath.cgPath
        layer1.strokeColor = ZZColor(248, g: 144, b: 34, a: 1).cgColor
        layer1.lineWidth = 1.0
        layer1.fillColor = nil
        layer1.lineJoin = kCALineCapRound
        lineView.layer.addSublayer(layer1)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 3.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        animation.fromValue = NSNumber(value: 0.0)
        animation.toValue = NSNumber(value: 1.0)
        layer1.add(animation, forKey: "path")
        
        
    }
    //点击每一条天气情况
    func clickScrollViewBtn(_ sender : UIButton) {
        
        scrolleViewClick!(sender)
    }
    func didSelectScrollViewClosure(_ closure:@escaping (_ sender: UIButton)->())  {
        
        scrolleViewClick = closure
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = ZZWeatherBGColor()
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(240)
        }
        
        createDayWeatherLabel()
    }
    
    //滚动scrollView
    fileprivate lazy var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    func createDayWeatherLabel() {
        scrollView.contentSize = CGSize(width: 16 * 60.0, height: 240.0)
        
        for i in 0..<16 {
            let view = UIView(frame: CGRect(x: CGFloat(i * 60), y: 0.0, width: 60.0, height: 240))
            
            view.backgroundColor = UIColor.clear
            scrollView.addSubview(view)
            
            let btn = UIButton(type: .custom)
            btn.frame = view.bounds
            btn.backgroundColor = UIColor.clear
            btn.tag = i
            btn .addTarget(self, action: #selector(clickScrollViewBtn(_ :)), for: .touchUpInside)
            view.addSubview(btn)
            
            
            let dayLb = UILabel.creatLabel(textString:"", Color: UIColor.white, Alignment: .center, font: UIFont.systemFont(ofSize: 12))
            dayLb.tag = i + 1000
            view.addSubview(dayLb)
            
            let dateLb = UILabel.creatLabel(textString: "", Color: UIColor.white, Alignment: .center, font: UIFont.systemFont(ofSize: 12))
            dateLb.tag = i + 2000
            view.addSubview(dateLb)
            
            
            
            let weatherLb = UILabel.creatLabel(textString: "", Color: UIColor.white, Alignment: .center, font: UIFont.systemFont(ofSize: 12))
            weatherLb.tag = i + 3000
            view.addSubview(weatherLb)
            
            let mintempLb = UILabel.creatLabel(textString: "", Color: UIColor.white, Alignment: .center, font: UIFont.systemFont(ofSize: 12))
            mintempLb.tag = i + 4000
            view.addSubview(mintempLb)
            
            let maxtempLb = UILabel.creatLabel(textString: "", Color: UIColor.white, Alignment: .center, font: UIFont.systemFont(ofSize: 12))
            maxtempLb.tag = i + 5000
            view.addSubview(maxtempLb)
            
            let windLb = UILabel.creatLabel(textString: "", Color: UIColor.white, Alignment: .center, font: UIFont.systemFont(ofSize: 12))
            windLb.tag = i + 6000
            view.addSubview(windLb)
            
            
            let levelLb = UILabel.creatLabel(textString: "", Color: UIColor.white, Alignment: .center, font: UIFont.systemFont(ofSize: 12))
            levelLb.tag = i + 7000
            view.addSubview(levelLb)
            
            
            //天气图片
            let imageView = UIImageView(image: UIImage(named: ""))
            imageView.tag = i + 8000
            view.addSubview(imageView)
            
            dayLb.snp.makeConstraints({ (make) in
                make.top.equalTo(5)
                make.centerX.equalTo(view.snp.centerX).offset(0)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(15)
            })
            dateLb.snp.makeConstraints({ (make) in
                make.top.equalTo(dayLb.snp.bottom).offset(5)
                make.centerX.equalTo(view.snp.centerX).offset(0)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(15)
            })
            weatherLb.snp.makeConstraints({ (make) in
                make.top.equalTo(dateLb.snp.bottom).offset(5)
                make.centerX.equalTo(view.snp.centerX).offset(0)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(15)
            })
            imageView.snp.makeConstraints({ (make) in
                make.top.equalTo(weatherLb.snp.bottom).offset(5)
                make.centerX.equalTo(view.snp.centerX).offset(0)
                make.width.equalTo(30)
                make.height.equalTo(30)
            })
            maxtempLb.snp.makeConstraints({ (make) in
                make.top.equalTo(imageView.snp.bottom).offset(5)
                make.centerX.equalTo(view.snp.centerX).offset(0)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(15)
            })
            mintempLb.snp.makeConstraints({ (make) in
                make.top.equalTo(maxtempLb.snp.bottom).offset(55)
                make.centerX.equalTo(view.snp.centerX).offset(0)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(15)
            })
            
            windLb.snp.makeConstraints({ (make) in
                make.top.equalTo(mintempLb.snp.bottom).offset(5)
                make.centerX.equalTo(view.snp.centerX).offset(0)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(15)
            })
            levelLb.snp.makeConstraints({ (make) in
                make.top.equalTo(windLb.snp.bottom).offset(5)
                make.centerX.equalTo(view.snp.centerX).offset(0)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(15)
            })
        }
        let lineView = UIView()
        lineView.tag = 9000;
        lineView.backgroundColor = UIColor.clear
        scrollView.addSubview(lineView)
        scrollView.bringSubview(toFront: lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(130)
            make.height.equalTo(45)
            make.width.equalTo(420)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
