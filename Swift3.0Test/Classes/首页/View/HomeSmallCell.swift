//
//  HomeSmallCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/7.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import Kingfisher

//中间是三张小图的
class HomeSmallCell: HomeTopicCell {
    
    var newsTopic : NewsTopic? {
        didSet{
            //标题
            titleLabel.text = newsTopic!.title! as String
           
            //时间
            
            if let time = newsTopic?.publish_time {
                timeLabel.text = NSString.changeDateTime(time)
            }else{
                timeLabel.isHidden = true
            }
            //作者
            if (newsTopic?.source_avatar) != nil {
                nameLabel.text = newsTopic!.source
                
            }
            if let mediaInfo = newsTopic?.media_info {
                nameLabel.text = mediaInfo.name
            }
            //评论
            if let commentCount = newsTopic?.comment_count {
                commentCount >= 10000 ? (commentLabel.text = "\(commentCount / 10000)万评论") : (commentLabel.text = "\(commentCount)评论")
            }else{
                commentLabel.isHidden = true
            }
            //关闭按钮 的内容数组
            filterWords = newsTopic?.filter_words
            
            let reachability = UserDefaults.standard.object(forKey: "reachability") as! String
            let networkMode = UserDefaults.standard.object(forKey: "networkMode") as! String
            let model = UserDefaults.standard.object(forKey: userChangedModel)
            
                if newsTopic!.image_list.count > 0  {
                    
                    for _ in middleView.subviews {
                        middleView.removeAllSubviews()
                    }
                    
                    
                    for index in 0..<newsTopic!.image_list.count {
                        
                        let imageView = UIImageView()
                        imageView.tag = index + 120
                        
                        imageView.backgroundColor = ZZGlobalColor()
                    
                        if let model1 =  model {
                            let isNight = model1 as! Bool
                            
                            imageView.backgroundColor = isNight ? UIColor.gray :ZZGlobalColor()
                        }
                        let imageList = newsTopic!.image_list[index]
                        let urlList = imageList.url_list![index]
                        let urlString = urlList["url"] as! String
                        if urlString.hasSuffix(".webp") {
                            let range = urlString.range(of: ".webp")
                            let url =  urlString.substring(to: range!.lowerBound)
                            
                            if !(reachability.compare("WWAN").rawValue  == 0 && networkMode.compare("极省流量（不下载图）").rawValue == 0) {
                                
                                imageView.kf.setImage(with: URL(string:url)!)
                            }
                        }else{
                            if !(reachability.compare("WWAN").rawValue  == 0 && networkMode.compare("极省流量（不下载图）").rawValue == 0)  {
                              
                                imageView.kf.setImage(with: URL(string: urlString)!)
                            }
                        }
                        let x : CGFloat = CGFloat(index) * (newsTopic!.imageW + 6)
                        
                        imageView.frame = CGRect(x: x, y: 0, width: (newsTopic?.imageW)!, height: (newsTopic?.imageH)!)
                        
                        middleView.addSubview(imageView)
                    }
            
            }
            
            
         
            //顶置 热
            if let label = newsTopic?.stick_label {
                stickLabel.setTitle(label, for: .normal)
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
        
        addSubview(middleView)
        
        middleView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(kMargin)
            make.left.equalTo(self).offset(kHomeMargin)
            make.right.equalTo(self).offset(-kHomeMargin)
            make.bottom.equalTo(nameLabel.snp.top).offset(-kMargin)
        }
    }
    
    /// 中间 3 张图的容器
    fileprivate lazy var middleView: UIView = {
        let middleView = UIView()
        return middleView
    }()
    
    /// 举报按钮点击 实现父类的按钮方法
    override func closeBtnClick(_ sender: UIButton) {
        closeButtonClosure?(sender ,filterWords!)
    }

    /// 举报按钮点击回调 父类申明 子类实现
    func closeSmallCellButtonClickClosure(_ closure:@escaping (_ button: UIButton , _ filterWord :[FilterWord] )->() ) {
    
        closeButtonClosure = closure
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    
    
    
    
    
}
