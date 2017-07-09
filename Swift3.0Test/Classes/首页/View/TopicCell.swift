//
//  TopicCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class TopicCell: UICollectionViewCell {
    
    var titleLb = TitleLabels()
    
    var deleteButton = UIButton()
    
    //点击删除的按钮 回调
    var didSelectDeleteButton : ((_ sender : UIButton) -> ())?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        backgroundColor = UIColor.white
        
        titleLb = TitleLabels()
        
        titleLb.textColor = UIColor.black

        titleLb.textAlignment = .center
        
        titleLb.adjustsFontSizeToFitWidth = true
        
        titleLb.font = UIFont.systemFont(ofSize: 16)
        
        
        self.contentView.addSubview(titleLb)
        
        titleLb.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        deleteButton = UIButton(type: .custom)
        
        deleteButton.setImage(UIImage(named:"add_channels_close_small_14x14_"), for: .normal)
        
        deleteButton .setTitleColor(ZZGlobalRedColor(), for: .normal)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonClick(_ :)), for: .touchUpInside)
        
        self.contentView.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { (make) in
            
            make.top.right.equalTo(0)
            
            make.width.height.equalTo(15)
            
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func deleteButtonClick(_ sender :UIButton) {
        
        didSelectDeleteButton?(sender)
    }
    //暴露给外面调用 相当于临时的block
    func deleteButtonClickClosure(_ closure : @escaping (_ sender :UIButton) -> () ) {
     
        didSelectDeleteButton = closure
    }
    
}
