//
//  UIView+Extension.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/3.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

extension UIView {
    
    /// 裁剪 view 的4个圆角
    /// 切圆时注意要正方形的 , 方向direction:.allCorners
    /// - Parameters:
    ///   - direction: 切4个角的方向
    ///   - cornerRadius: 半径
    func clipRectCorner(direction:UIRectCorner , cornerRadius: CGFloat) {
        let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    
    /// 给 view 添加点击手势
    ///
    /// - Parameters:
    ///   - target: self
    ///   - action: 点击方法
    func addTarget(target:Any , action:Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
 
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    var y : CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tempFrame :CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    var width : CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame :CGRect = frame
            tempFrame.size.width  = newValue
            frame                 = tempFrame
        }
    }
    
    var height : CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tempFrame :CGRect = frame
            tempFrame.size.width  = newValue
            frame                 = tempFrame
        }
    }
    
    var size : CGSize {
        get {
            return frame.size
        }
        set(newValue) {
            var tempFrame: CGRect   = frame
            tempFrame.size          = newValue
            frame                   = tempFrame
        }
       
    }
    
    var centerX: CGFloat {
        get {
            return center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x            = newValue
            center                  = tempCenter
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y            = newValue
            center                  = tempCenter;
        }
    }

    // 1-> 3,4   2-> 5,6
    func allSubviews() -> [UIView] {
        var res = self.subviews //1,2   3,4
        for subview in self.subviews {
            // subview = 1
            let riz = subview.allSubviews()
            // riz = 3,4
            res.append(contentsOf: riz)
        }
        return res
    }
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    //加载xib 创建的view
    class func loadViewFromXib() -> UIView {
        let className = String(describing: self)
        let view = Bundle.main.loadNibNamed(className, owner: nil, options: nil)?.last as! UIView
        return view
    }
    
}
