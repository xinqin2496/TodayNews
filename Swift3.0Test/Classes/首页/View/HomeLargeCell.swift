//
//  HomeLargeCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/7.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

//  中间显示一张大图的情况

import UIKit

class HomeLargeCell: HomeTopicCell {
    
    var newsTopic: NewsTopic? {
        didSet{
            let reachability = UserDefaults.standard.object(forKey: "reachability") as! String
            let networkMode = UserDefaults.standard.object(forKey: "networkMode") as! String
            let model = UserDefaults.standard.object(forKey: userChangedModel)
           
            if let model1 =  model {
                let isNight = model1 as! Bool
                
                largeImageView.backgroundColor = isNight ? UIColor.gray :ZZGlobalColor()
            }
            titleLabel.text = String(newsTopic!.title!)
          
            timeLabel.text = NSString.changeDateTime(newsTopic!.publish_time!)
           
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
            
            var urlString = String()
            
            if let videoDetailInfo = newsTopic?.video_detail_info {
                // 说明是视频
                urlString = videoDetailInfo.detail_video_large_image!.url!
                /// 格式化时间
                let minute = Int(newsTopic!.video_duration! / 60)
                let second = newsTopic!.video_duration! % 60
                rightBottomLabel.text = String(format: "%02d:%02d", minute, second)
            } else { // 说明是大图
                playButton.isHidden = true
                urlString = newsTopic!.large_image_list.first!.url!
                rightBottomLabel.text = "\(newsTopic!.gallary_image_count!)图"
            }

            if !(reachability.compare("WWAN").rawValue  == 0  && networkMode.compare("极省流量（不下载图）").rawValue == 0){
                largeImageView.kf.setImage(with:URL(string: urlString)!)
            }else{
                largeImageView.image = UIImage(named: "")
                
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
        
        addSubview(largeImageView)
        
        largeImageView.addSubview(rightBottomLabel)
        
        largeImageView.addSubview(playButton)
        
        largeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(kMargin)
            make.left.equalTo(self).offset(kHomeMargin)
            make.right.equalTo(self).offset(-kHomeMargin)
            make.height.equalTo(170)
        }
        
        rightBottomLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 50, height: 20))
            make.right.equalTo(largeImageView.snp.right).offset(-7)
            make.bottom.equalTo(largeImageView.snp.bottom).offset(-7)
        }
        
        playButton.snp.makeConstraints { (make) in
            make.center.equalTo(largeImageView)
        }
    }
    
    /// 中间的播放按钮
    fileprivate lazy var playButton: UIButton = {
        let playButotn = UIButton()
        playButotn.setImage(UIImage(named: "playicon_video_60x60_"), for: UIControlState())
        playButotn.sizeToFit()
        playButotn.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)
        return playButotn
    }()
    
    /// 右下角显示图片数量或视频时长
    lazy var  rightBottomLabel: UILabel = {
        let rightBottomLabel = UILabel()
        rightBottomLabel.textAlignment = .center
        rightBottomLabel.layer.cornerRadius = 10
        rightBottomLabel.layer.masksToBounds = true
        rightBottomLabel.font = UIFont.systemFont(ofSize: 13)
        rightBottomLabel.textColor = UIColor.white
        rightBottomLabel.backgroundColor = ZZColor(0, g: 0, b: 0, a: 0.6)
        return rightBottomLabel
    }()
    
    /// 中间大图
    fileprivate lazy var largeImageView: UIImageView = {
        let largeImageView = UIImageView()
        largeImageView.backgroundColor = ZZGlobalColor()
        return largeImageView
    }()
    
    /// 举报按钮点击
    
    override func closeBtnClick(_ sender: UIButton){
        closeButtonClosure?(sender,filterWords!)
    }
    
    /// 播放按钮点击
    func playButtonClick() {
        
    }
    
    /// 举报按钮点击回调
    func closeLargeCellButtonClickClosure(_ closure:@escaping (_ button: UIButton ,_ filterWord: [FilterWord])->()) {
        closeButtonClosure = closure
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
