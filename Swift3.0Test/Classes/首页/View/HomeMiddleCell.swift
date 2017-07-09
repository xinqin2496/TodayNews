//
//  HomeMiddleCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/7.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


//右边显示一张图的情况
class HomeMiddleCell: HomeTopicCell {

    var newsTopic : NewsTopic? {
        didSet{
            let reachability = UserDefaults.standard.object(forKey: "reachability") as! String
            let networkMode = UserDefaults.standard.object(forKey: "networkMode") as! String
            let model = UserDefaults.standard.object(forKey: userChangedModel)
           
            if let model1 =  model {
                let isNight = model1 as! Bool
                rightImageView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
                
            }
            //标题
            titleLabel.text = newsTopic!.title! as String
          
            //时间
            
            if let time = newsTopic?.publish_time {
                timeLabel.text = NSString.changeDateTime(time)
            }else{
                timeLabel.isHidden = true
            }
            //作者
            if let sourceAvatar = newsTopic?.source_avatar {
                nameLabel.text = newsTopic!.source
                if !(reachability.compare("WWAN").rawValue  == 0 && networkMode.compare("极省流量（不下载图）").rawValue == 0) {
                    rightImageView.kf.setImage(with: URL(string: sourceAvatar)!)
                }else{
                    rightImageView.image = UIImage(named: "")
                }
                
            }
            
            if let mediaInfo = newsTopic!.media_info {
                nameLabel.text = mediaInfo.name
                if !(reachability.compare("WWAN").rawValue  == 0 && networkMode.compare("极省流量（不下载图）").rawValue == 0) {
                    rightImageView.kf.setImage(with: URL(string: mediaInfo.avatar_url!)!)
                }else{
                    rightImageView.image = UIImage(named: "")
                }
                
            }
            
            if let commentCount = newsTopic!.comment_count {
                commentCount >= 10000 ? (commentLabel.text = "\(commentCount / 10000)万评论") : (commentLabel.text = "\(commentCount)评论")
            } else {
                commentLabel.isHidden = true
            }
            
            if (newsTopic!.titleH + nameLabel.height + kMargin) < newsTopic?.imageH {
                closeButton.snp.remakeConstraints({ (make) in
                    make.right.equalTo(rightImageView.snp.left).offset(-kHomeMargin)
                    make.centerY.equalTo(nameLabel)
                    make.size.equalTo(CGSize(width: 17, height: 12))
                })
            }
            filterWords = newsTopic?.filter_words
            
            let url = newsTopic!.middle_image?.url
            if !(reachability.compare("WWAN").rawValue  == 0 && networkMode.compare("极省流量（不下载图）").rawValue == 0) {
                 rightImageView.kf.setImage(with: URL(string: url!)!)
            }else{
                rightImageView.image = UIImage(named: "")
            }
            if let label = newsTopic?.label {
                stickLabel.setTitle(" \(label) ", for: UIControlState())
                stickLabel.isHidden = false
            }else{
                stickLabel.isHidden = true
                nameLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(self).offset(kHomeMargin)
                    make.bottom.equalTo(self.snp.bottom).offset(-kMargin)
                    make.height.equalTo(15)
                })
            }

        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(rightImageView)
        //视频显示的时间
        addSubview(timeButton)
        
        timeButton.snp.makeConstraints { (make) in
            make.right.equalTo(rightImageView.snp.right).offset(-5)
            make.bottom.equalTo(rightImageView.snp.bottom).offset(-5)
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(kHomeMargin)
            make.size.equalTo(CGSize(width: 108, height: 70))
            make.right.equalTo(self).offset(-kHomeMargin)
        }
        
        //只有一张小图 更新 titileLabel 的约束
        titleLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(rightImageView.snp.left).offset(-kHomeMargin)
            make.left.top.equalTo(self).offset(kHomeMargin)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 右下角的视频时长
    fileprivate lazy var timeButton: UIButton = {
        let timeButton = UIButton()
        timeButton.isHidden = true
        timeButton.isUserInteractionEnabled = false
        timeButton.layer.cornerRadius = 8
        timeButton.layer.masksToBounds = true
        timeButton.setTitleColor(UIColor.white, for: UIControlState())
        timeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        timeButton.setImage(UIImage(named: "palyicon_video_textpage_7x10_"), for: UIControlState())
        return timeButton
    }()
    
    /// 右边图片
    fileprivate lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.backgroundColor = ZZGlobalColor()
        return rightImageView
    }()
    
    /// 举报按钮点击
    override func closeBtnClick(_ sender: UIButton) {
        closeButtonClosure?(sender ,filterWords!)
    }
    
    /// 举报按钮点击回调
    func closeMiddleCellButtonClickClosure(_ closure:@escaping (_ button: UIButton ,_ filterWord: [FilterWord])->()) {
        closeButtonClosure = closure
    }

}
