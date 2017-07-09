//
//  TopicReusableView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class TopicReusableView: UICollectionReusableView {
    
    var titleLabel = UILabel()
    
    var rightButton = UIButton()
    
    //点击右边的按钮 回调
    var didSelectRightButton : ((_ sender : UIButton) -> ())?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = UIColor.clear
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        titleLabel = UILabel()
        
        titleLabel.textAlignment = .left
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        titleLabel.textColor = UIColor.black
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.left.top.bottom.equalTo(0)
            
        }
        
        rightButton = UIButton(type: .custom)
        
        rightButton.setTitle("编辑", for: .normal)
        
        rightButton.setTitle("完成", for: .selected)
        
        rightButton .setTitleColor(ZZGlobalRedColor(), for: .normal)
        
        rightButton.clipsToBounds = true
        
        rightButton.layer.masksToBounds = true
        
        rightButton.layer.cornerRadius = 15
        
        rightButton.layer.borderColor = ZZGlobalRedColor().cgColor
        
        rightButton.layer.borderWidth = 1
        
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        rightButton.backgroundColor = UIColor.clear
        
        rightButton.addTarget(self, action: #selector(buttonClick (_ :)), for: .touchUpInside)
        
        self.addSubview(rightButton)
        
        rightButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(5)
            
            make.right.equalTo(-15)
            
            make.width.equalTo(50)
            
            make.height.equalTo(30)
        }
        
        
    }
    
    //点击右边的编辑按钮
    func buttonClick(_ sender : UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        didSelectRightButton?(sender)
        
    }
    /// 暴露给外界，告知外界点击了哪一个
    func didSelectEditButtonClosure(_ closure:@escaping (_ button: UIButton)->()) {
        didSelectRightButton = closure
    }
   
}
