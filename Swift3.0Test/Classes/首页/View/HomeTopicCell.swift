//
//  HomeTopicCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/7.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

//  新闻显示的 cell 的基类
//  主要定义了 标题、头像、昵称、评论、关闭按钮
class HomeTopicCell: UITableViewCell {

    var filterWords : [FilterWord]?
    
    //关闭 按钮的回调 父类定义 子类实现
    var closeButtonClosure : ((_ sender : UIButton , _ filterwords : [FilterWord]) -> ())?
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        addSubview(titleLabel)
        
        addSubview(stickLabel)
        
        addSubview(nameLabel)
        
        addSubview(commentLabel)
        
        addSubview(timeLabel)
        
        addSubview(closeButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(kHomeMargin)
            make.right.equalTo(self).offset(-kHomeMargin)
        }
        
        stickLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(kHomeMargin)
            make.bottom.equalTo(self.snp.bottom).offset(-kMargin)
            make.height.equalTo(15)
        }
    
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(stickLabel.snp.right).offset(5)
            make.bottom.equalTo(self.snp.bottom).offset(-kMargin)
            make.height.equalTo(15)
        }
        
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.centerY.equalTo(nameLabel)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(commentLabel.snp.right).offset(5)
            make.centerY.equalTo(commentLabel)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-kHomeMargin)
            make.centerY.equalTo(nameLabel)
            make.size.equalTo(CGSize(width: 30, height: 16))
        }
    }
  
    /// 置顶，热，广告，视频
    lazy var stickLabel: UIButton = {
        let stickLabel = UIButton()
        stickLabel.isHidden = true
        stickLabel.layer.cornerRadius = 3
        stickLabel.sizeToFit()
        stickLabel.isUserInteractionEnabled = false
        stickLabel.titleLabel!.font = UIFont.systemFont(ofSize: 13)
        stickLabel.setTitleColor(ZZColor(241, g: 91, b: 94, a: 1.0), for: UIControlState())
        stickLabel.layer.borderColor = ZZColor(241, g: 91, b: 94, a: 1.0).cgColor
        stickLabel.layer.borderWidth = 0.5
        return stickLabel
    }()
    
    //懒加载
    //新闻标题
    lazy var titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    
    //作者
    lazy var nameLabel : UILabel = {
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.textColor = UIColor.lightGray
        return nameLabel
    }()
    
    //评论
    lazy var commentLabel : UILabel = {
        
        let commentLabel = UILabel()
        commentLabel.font = UIFont.systemFont(ofSize: 13)
        commentLabel.textColor = UIColor.lightGray
        return commentLabel
    }()
    
    //时间
    lazy var timeLabel : UILabel = {
        
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = UIColor.lightGray
        
        return timeLabel
    }()
    
    /// 右下角的 x 按钮
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "add_textpage_17x12_"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(closeBtnClick(_ :)), for: .touchUpInside)
        return closeButton
    }()
    
    /// x 按钮点击 父类定义 子类实现
    func closeBtnClick(_ sender :UIButton) {
        
    }
   

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
