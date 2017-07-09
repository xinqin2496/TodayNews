//
//  NormalButton.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/23.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

struct myConstFloat {
    static let imgW : CGFloat = 13.0
    static let imgH : CGFloat = 13.0
    static let margin :CGFloat = 5.0
    static let labelH :CGFloat = 13.0
}

class NormalButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let font = 12.0
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.textAlignment = .left
        self.setTitleColor(ZZColor(151, g: 161, b: 173, a: 1.0), for: .normal)
        self.setTitleColor(ZZGlobalRedColor(), for: .selected)
        self.titleLabel?.tintColor = ZZColor(122, g: 122, b: 122, a: 1.0)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(font))
        self.titleLabel?.lineBreakMode = .byTruncatingTail
    }

    //1.重写方法,改变图片的位置,在titleRect..方法后执行
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let imageX = self.bounds.size.width * 0.4  - 10
        let imageY = self.center.y - CGFloat(myConstFloat.imgH / 2)
        let width = myConstFloat.imgW
        let height = myConstFloat.imgH
        
        return CGRect(x: imageX, y: imageY, width: width, height: height)
        
    }
    //2.改变title文字的位置,构造title的矩形即可
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let titleX = CGFloat((self.imageView?.frame)!.maxX) + CGFloat(myConstFloat.margin)
        let titleY = self.center.y - myConstFloat.labelH / 2
        let width =  self.frame.size.width - titleX
        let height = myConstFloat.labelH
        
        return CGRect(x: titleX, y: titleY, width: width, height: height)
       
    }
    
}
