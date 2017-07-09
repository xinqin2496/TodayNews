//
//  GradientView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/11.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

//给view上的文字 添加颜色渐变效果
class GradientView: UIView {

    var titleStr : String? {
        didSet {
            
            titleLabel.text = titleStr
            gradientLayer.mask = titleLabel.layer
            addAnimationToGradientLayer()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        self.layer.addSublayer(gradientLayer)
        
       
    }
  
    override func layoutSubviews() {
        gradientLayer.frame = self.bounds
        titleLabel.frame = gradientLayer.frame
        didMoveToWindow()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //为gradientLayer添加动画效果
    
    func addAnimationToGradientLayer() {
        gradientLayer.removeAllAnimations()
        
      let gradientAnimation = CABasicAnimation(keyPath: "locations")
        
        gradientAnimation.fromValue = [0.0,0.0,0.25]
        gradientAnimation.toValue = [0.75,1.0,1.0]
        gradientAnimation.duration = 3.0
        gradientAnimation.repeatCount = MAXFLOAT
        
        gradientLayer.add(gradientAnimation, forKey: nil)
        

    }
    //在layer上添加渐变
    fileprivate lazy var gradientLayer : CAGradientLayer = {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // RGB 随机颜色
        let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
        let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        //        let alpha = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        
        let randomColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
        let colors = [UIColor.lightGray.cgColor,randomColor,UIColor.lightGray.cgColor]
        
        //颜色的位置
        gradientLayer.colors = colors
        
        gradientLayer.locations = [0.25,0.5,0.75]
        
        return gradientLayer
    }()
    
    //添加 文字 label
    fileprivate lazy var titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.lightGray
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.font =  UIFont.boldSystemFont(ofSize: 20)
       
        return titleLabel
    }()
}
