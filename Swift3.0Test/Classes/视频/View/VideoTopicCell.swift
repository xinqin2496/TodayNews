//
//  VideoTopicCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/4.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit


protocol VideoTopicCellDelegate: NSObjectProtocol {
    /// 昵称按钮点击
    func videoTopicCell(_ videoTopicCell: VideoTopicCell, nameButtonClick nameButton: UIButton)
    /// 背景点击
    func videoTopicCellbgImageViewClick(_ videoTopicCell: VideoTopicCell)
    /// 播放按钮点击
    func videoTopicCell(_ videoTopicCell: VideoTopicCell, playButtonClick playButton: UIButton)
}

/// ![](http://obna9emby.bkt.clouddn.com/news/video-cell-1_spec.png)
/// ![](http://obna9emby.bkt.clouddn.com/news/video-cell.png)
class VideoTopicCell: UITableViewCell {
    
    weak var delegate: VideoTopicCellDelegate?
    /// 更多按钮点击回调
    var moreButtonClosure: (() -> ())?
    
    var videoTopic: NewsTopic? {
        didSet {
            let reachability = UserDefaults.standard.object(forKey: "reachability") as! String
            let networkMode = UserDefaults.standard.object(forKey: "networkMode") as! String
            
            titleLabel.text = String(videoTopic!.title!)
            let mediaInfo = videoTopic!.media_info
            nameLabel.setTitle(mediaInfo?.name, for: UIControlState())
            let placeholder =  UIImage(named: "home_head_default_29x29_")
            
            avatarImageView.kf.setImage(with: URL(string: mediaInfo!.avatar_url!), placeholder:placeholder, options: nil, progressBlock: nil) { (image, error, cacheType, iamgeURL) in
                self.avatarImageView.image = (image == nil) ? placeholder : image?.circleImage()
            }
            if videoTopic!.comment_count! == 0 {
                commentButton.setTitle("评论", for: UIControlState())
            } else if videoTopic!.comment_count! >= 10000 {
                let comment_count = videoTopic!.comment_count! / 10000
                commentButton.setTitle("\(comment_count)万", for: UIControlState())
            } else {
                commentButton.setTitle("\(videoTopic!.comment_count!)", for: UIControlState())
            }
            if let videoDetailInfo = videoTopic?.video_detail_info  {
               
                if let watchCount = videoDetailInfo.video_watch_count {
                    watchCount >= 10000 ? (countLabel.text = "\(watchCount / 10000)万次播放") : (countLabel.text = "\(watchCount)次播放")
                } else {
                    countLabel.text = "0次播放"
                }
                let largeImageList = videoTopic?.large_image_list.first
                
                
                if !(reachability.compare("WWAN").rawValue  == 0  && networkMode.compare("极省流量（不下载图）").rawValue == 0){
                    bgImageView.kf.setImage(with: URL(string: largeImageList!.url!)!)
                    titleLabel.textColor = UIColor.white
                    countLabel.textColor = UIColor.white
                }else{
                    bgImageView.image = UIImage(named: "")
                    titleLabel.textColor = UIColor.black
                    countLabel.textColor = UIColor.black
                }
            }
            
            /// 格式化时间
            let minute = Int(videoTopic!.video_duration! / 60)
            let second = videoTopic!.video_duration! % 60
            timeLabel.text = String(format: "%02d:%02d", minute, second)
        }
    }
    ///背景图片
    @IBOutlet weak var bgImageView: UIImageView!
    /// 标题 label
    @IBOutlet weak var titleLabel: UILabel!
    /// 播放按钮
    @IBOutlet weak var playButton: UIButton!
    /// 时间 label
    @IBOutlet weak var timeLabel: UILabel!
    /// 用户头像
    @IBOutlet weak var avatarImageView: UIImageView!
    /// 用户昵称
    @IBOutlet weak var nameLabel: UIButton!
    /// 评论按钮
    @IBOutlet weak var commentButton: UIButton!
    ///播放量
    @IBOutlet weak var countLabel: UILabel!
    /// 加载图片，转圈圈
    @IBOutlet weak var loadingImageView: UIImageView!
    ///底部view
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //如果发现控件的位置和尺寸不是自己设置的，那么有可能是自动伸缩属性导致
        autoresizingMask = UIViewAutoresizing()
        playButton.setImage(UIImage(named: "new_play_video_60x60_"), for: UIControlState())
        playButton.setImage(UIImage(named: "new_pause_video_60x60_"), for: .selected)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.addTarget(target: self, action: #selector(bgImageButtonClick))
        bgImageView.backgroundColor = ZZGlobalColor()
    }
    ///播放按钮
    @IBAction func playButtonClick(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        delegate?.videoTopicCell(self, playButtonClick: sender)
    }
    
    /// 背景按钮添加点击方法
    func bgImageButtonClick() {
//        playButton.isSelected = !playButton.isSelected
        delegate?.videoTopicCellbgImageViewClick(self)
    }
    /// 更多按钮点击
    @IBAction func moreButtonClick(_ sender: UIButton) {
        moreButtonClosure?()
    }
    
    /// 用户名称点击
    @IBAction func nameButtonClick(_ sender: UIButton) {
        delegate?.videoTopicCell(self, nameButtonClick: sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
