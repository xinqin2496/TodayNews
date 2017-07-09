//
//  TipView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/6.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

// ![](http://obna9emby.bkt.clouddn.com/news/home-tip.png)
// 每次刷新上面的提示文字 有多少条更新
class TipView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tipLabel)
        
        tipLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    //懒加载初始化 label
    
    lazy var tipLabel : UILabel = {
        
        let tipLabel = UILabel()
        
        tipLabel.textColor = ZZColor(91, g: 162, b: 207, a: 1.0)
        
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        
        tipLabel.textAlignment = .center
        
        tipLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return tipLabel
        
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
