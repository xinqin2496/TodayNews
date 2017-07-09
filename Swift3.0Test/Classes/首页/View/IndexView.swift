//
//  IndexView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/17.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class IndexView: UIView {

    var indexModel: WeatherIndexesModel?{
        didSet {
            titleLabel.text = indexModel?.name!
            contentView.text = indexModel?.desc!
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   fileprivate  func setupUI() {
    
    let bgView = UIView(frame: self.bounds)
    bgView.backgroundColor = UIColor.white
    bgView.alpha = 0.85
    self.clipRectCorner(direction: .allCorners, cornerRadius: 8)
    
    addSubview(bgView)

    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { (make) in
        make.centerX.equalTo(self.snp.centerX).offset(0)
        make.top.equalTo(10)
        make.height.equalTo(25)
    }
    
    addSubview(contentView)
    
    contentView.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(3)
        make.left.equalTo(15)
        make.right.equalTo(-15)
        make.bottom.equalTo(-10)
    }
    
    }

    //标题
    lazy var titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    //内容
    lazy var contentView : UITextView = {
        
        let contentView = UITextView()
        contentView.backgroundColor = UIColor.clear
        contentView.font = UIFont.systemFont(ofSize: 14)
        contentView.textColor = UIColor.black
        contentView.isEditable = false
        return contentView
    }()
}
