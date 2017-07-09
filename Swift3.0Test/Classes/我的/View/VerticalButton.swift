//
//  VerticalButton.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class VerticalButton: UIButton {
    
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
        imageView?.x = (self.width - 30 ) * 0.5
        imageView?.y = (self.height - 30 - 15) * 0.5
        imageView?.width = 30
        imageView?.height = 30
        // 调整文字
        
        titleLabel?.frame = CGRect(x: 0, y: self.height - 30, width: self.width, height:30)
    }
    
}
