//
//  UIButton+Extension.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/11.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

//创建图片在上 文字在下的按钮
class ShareVerticalButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 调整图片
        imageView?.centerX = self.width * 0.5
        imageView?.y = 0
        imageView?.width = 60
        imageView?.height = 60
        // 调整文字
        titleLabel?.frame = CGRect(x: 0, y: 67, width: self.width, height: self.height - 67)
    }
    
}

extension ShareVerticalButton {
    
    func shakeBtn(delay: TimeInterval) {
        let top1 = CGAffineTransform.init(translationX: 0, y: 150)
        let bottom1 = CGAffineTransform.init(translationX: 0, y: 3)
        let top2 = CGAffineTransform.init(translationX: 0, y: -8)
        let reset = CGAffineTransform.identity
        //0 初始状态 下
        self.transform = top1
        self.alpha = 0.3
        
        /// 系统自带的弹簧效果
        /// usingSpringWithDamping 0~1 数值越小「弹簧」的振动效果越明显
        /// initialSpringVelocity 初始的速度，数值越大一开始移动越快
        UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options:.curveEaseOut , animations: {
            self.transform = reset
            self.alpha = 1
        }, completion: nil)
        return
            
            //1 上
            UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseOut, animations: {
                
                self.transform = top2
                self.alpha = 1
                
            }, completion: { _ in
                
                //2 下
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    
                    self.transform = bottom1
                    
                }, completion: { (_) in
                    
                    //3 还原
                    UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
                        
                        self.transform = reset
                        
                    }, completion: { (_) in
                        
                    })  
                })
            })
    }
}
