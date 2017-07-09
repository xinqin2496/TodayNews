//
//  UIImage+Extendion.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/3.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

extension UIImage {
    
    
    /// 把图片切成圆
    ///
    /// - Returns: 切好过的图片
    func circleImage() -> UIImage {
        // false 代表透明
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // 获得上下文
        let ctx = UIGraphicsGetCurrentContext()
        // 添加一个圆
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        ctx!.addEllipse(in: rect)
        
        // 裁剪
        ctx!.clip()
        // 将图片画上去
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
    }
}
