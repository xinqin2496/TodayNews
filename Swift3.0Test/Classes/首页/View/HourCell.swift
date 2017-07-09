//
//  HourCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/19.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class HourCell: UITableViewCell {

    var hourArray:[WeatherHourfcModel]?{
        didSet {
            
            for i in 0..<(hourArray?.count)! {
                let model = hourArray![i]
                
                let hourLb = hourScrollerView.viewWithTag(i + 100) as! UILabel
                
                
                let wdLb = hourScrollerView.viewWithTag(i + 200) as! UILabel
                
                let wpLb = hourScrollerView.viewWithTag(i + 300) as! UILabel

                let timeStr = model.time! as NSString
                
                let hourStr = timeStr.substring(with: NSMakeRange(8, 2))
                
                var hour :String!
                
                if i == 0 {
                    hour = "现在"
                }else{
                    hour = "\(hourStr)时"
                }
                hourLb.text = hour!

                
                wdLb.text = model.wd
                
                wpLb.text = model.wp
                
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = ZZWeatherBGColor()
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(hourScrollerView)
        hourScrollerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(70)
        }
        createLabel()
    }
    
    //滚动scrollView
    fileprivate lazy var hourScrollerView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    func createLabel() {
        hourScrollerView.contentSize = CGSize(width:24 * 60.0, height: 70)
        
        for i in 0..<24 {
           
            let view = UIView(frame: CGRect(x: CGFloat(i * 60), y: 0.0, width: 60.0, height: 70))
            
            view.backgroundColor = UIColor.clear
            hourScrollerView.addSubview(view)
            

            
            let huorLb = UILabel.creatLabel(textString:"", Color: UIColor.white, Alignment: .center, font: UIFont.systemFont(ofSize: 12))
            huorLb.tag = i + 100;
            view.addSubview(huorLb)
            
            
            let wdLb = UILabel.creatLabel(textString: "", Color: UIColor.white, Alignment: .center, font: UIFont.systemFont(ofSize: 12))
            wdLb.tag = i + 200;
            view.addSubview(wdLb)
            
            let wpLb = UILabel.creatLabel(textString: "", Color: UIColor.white, Alignment: .center, font: UIFont.systemFont(ofSize: 12))
            wpLb.tag = i + 300;
            view.addSubview(wpLb)
            
            huorLb.snp.makeConstraints({ (make) in
                make.top.equalTo(5)
                make.centerX.equalTo(view.snp.centerX).offset(0)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(15)
            })
            
            wdLb.snp.makeConstraints({ (make) in
                make.top.equalTo(huorLb.snp.bottom).offset(5)
                make.centerX.equalTo(view.snp.centerX).offset(0)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(15)
            })
            wpLb.snp.makeConstraints({ (make) in
                make.top.equalTo(wdLb.snp.bottom).offset(5)
                make.centerX.equalTo(view.snp.centerX).offset(0)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(15)
            })
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
