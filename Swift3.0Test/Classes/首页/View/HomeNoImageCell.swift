//
//  HomeNoImageCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/7.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

//  没有图片的情况
//

import UIKit

class HomeNoImageCell: HomeTopicCell {
    
    var newsTopic: NewsTopic? {
        didSet{
           
            guard newsTopic?.cell_type != 25 else {
                
                return
            }
           
            if let titleStr = newsTopic?.title {
                titleLabel.text = titleStr as String
            }
        
            if let contentStr = newsTopic?.content {
                titleLabel.text = contentStr as String
            }
            if let publishTime = newsTopic?.publish_time {
                timeLabel.text = NSString.changeDateTime(publishTime)
            }
            
            if (newsTopic?.source_avatar) != nil {
                nameLabel.text = newsTopic!.source
                
            }
            
            if let mediaInfo = newsTopic!.media_info {
                nameLabel.text = mediaInfo.name
                
            }
            
            if let commentCount = newsTopic!.comment_count {
                commentCount >= 10000 ? (commentLabel.text = "\(commentCount / 10000)万评论") : (commentLabel.text = "\(commentCount)评论")
            } else {
                commentLabel.isHidden = true
            }
            
            filterWords = newsTopic?.filter_words

            if let label = newsTopic?.label {
                stickLabel.setTitle(" \(label) ", for: UIControlState())
                stickLabel.isHidden = false
                closeButton.isHidden = (label == "置顶") ?  true : false
            }
            else{
                stickLabel.isHidden = true
                closeButton.isHidden = true
                nameLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(self).offset(kHomeMargin)
                    make.bottom.equalTo(self.snp.bottom).offset(-kMargin)
                    make.height.equalTo(15)
                })
            }
            if newsTopic?.cell_type == 32 {
                stickLabel.isHidden = true
                closeButton.isHidden = true
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
        
    }
    
    /// 举报按钮点击
    override func closeBtnClick(_ sender :UIButton) {
        closeButtonClosure?(sender,filterWords!)
    }
    
    /// 举报按钮点击回调
    func closeNoImageCellButtonClickClosure(_ closure:@escaping (_ button: UIButton ,_ filterWord: [FilterWord])->()) {
        closeButtonClosure = closure
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
