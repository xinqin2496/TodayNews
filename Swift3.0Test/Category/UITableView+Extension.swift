
//
//  UITableView+Extension.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/9.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

extension UITableView {
    
    
    /// 当数据为 0 或加载数据失败的时候显示
    func tableViewNoDataOrNewworkFail(_ rowCount: Int) {
        if rowCount == 0 {
            let bgView = UIView()
            bgView.frame = self.bounds
            let imgView = UIImageView()
            imgView.image = UIImage(named: "not_network_loading_226x119_")
            imgView.contentMode = .center
            bgView.addSubview(imgView)
            backgroundView = imgView
            separatorStyle = .none
        } else {
            backgroundView = nil
            separatorStyle = .singleLine
        }
    }
    
    //显示今日头条渐变色文字
    func tableViewNoDataOrNewworkFailGradient(_ rowCount : Int) {
        
        if rowCount == 0 {


            let titleStr : NSString = "你关心的\n 才是头条"
            
            let attributeDict = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20),NSKernAttributeName:1] as [String : Any]
            let size = titleStr.boundingRect(with: CGSize(width:Screen_Width,height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attributeDict, context: nil).size
            
            let gradientView = GradientView(frame: CGRect(x: 0, y: (Screen_Height - size.height) * 0.5 , width: Screen_Width, height: size.height))

            gradientView.titleStr = titleStr as String
            
            backgroundView = gradientView
            
            separatorStyle = .none
            
        }else{
            backgroundView = nil
            separatorStyle = .singleLine
        }
        
        
    }
    func randomColor() -> UIColor {
        
        let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        
        let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
        
        let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        
        return UIColor.init(red:red, green:green, blue:blue , alpha: 1)
        
    }

}
