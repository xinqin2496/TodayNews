//
//  CellBottomView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/23.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class CellBottomView: UIView {

   
 
    
    var btnComment = NormalButton()
    var btnLike = NormalButton()
    var btnShare = NormalButton()

    var clickBottomButton:((_ sender : UIButton) -> ())?
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
     
        
        let viewTopLine = UIView()
        viewTopLine.backgroundColor = ZZColor(222, g: 222, b: 222, a: 1.0)
        addSubview(viewTopLine)
        
        viewTopLine.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        btnLike = NormalButton()
        btnLike.tag = 110
        btnLike .setTitle("0", for: .normal)
        btnLike .setImage(UIImage(named:"good_jokebar_textpage_24x24_"), for: .normal)
        btnLike .setImage(UIImage(named:"good_jokebar_textpage_selected_press_24x24_"), for: .highlighted)
        btnLike .setImage(UIImage(named:"good_jokebar_textpage_selected_24x24_"), for: .selected)
        btnLike .addTarget(self, action: #selector(clickButton(_ :)), for: .touchUpInside)
        addSubview(btnLike)
        
        let Line1 = UIView()
        Line1.backgroundColor = ZZColor(222, g: 222, b: 222, a: 1.0)
        addSubview(Line1)
        
        btnComment = NormalButton()
        btnComment.tag = 111
        btnComment .setTitle("0", for: .normal)
        btnComment .setImage(UIImage(named:"comment_icon_old_night_15x15_"), for: .normal)
        btnComment .addTarget(self, action: #selector(clickButton(_ :)), for: .touchUpInside)
        addSubview(btnComment)
        
        let Line2 = UIView()
        Line2.backgroundColor = ZZColor(222, g: 222, b: 222, a: 1.0)
        addSubview(Line2)
        
        btnShare = NormalButton()
        btnShare.tag = 112
        btnShare .setTitle("转发", for: .normal)
        btnShare .setImage(UIImage(named:"workgroup_img_share"), for: .normal)
        btnShare .addTarget(self, action: #selector(clickButton(_ :)), for: .touchUpInside)
        addSubview(btnShare)
        
        btnLike.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
            make.right.equalTo(btnComment.snp.left)
            make.width.equalTo(btnComment.snp.width)
        }
        btnComment.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(btnLike.snp.right)
            make.right.equalTo(btnShare.snp.left)
            make.width.equalTo(btnShare.snp.width)
        }
        btnShare.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(0)
            make.left.equalTo(btnComment.snp.right)
            make.width.equalTo(btnLike.snp.width)
        }
        Line1.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.left.equalTo(btnLike.snp.right)
            make.height.equalTo(24)
            make.centerY.equalTo(btnComment.snp.centerY)
        }
        Line2.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.left.equalTo(btnComment.snp.right)
            make.height.equalTo(24)
            make.centerY.equalTo(btnComment.snp.centerY)
        }
    }
    
    
    @objc fileprivate func clickButton(_ sender : NormalButton) {
    
        clickBottomButton!(sender)
    }
    ///暴露出来的点击方法
    func headlinesBottomButtonClosure(_ closure : @escaping (_ sender : UIButton) -> ()) {
        clickBottomButton = closure
    }
}
