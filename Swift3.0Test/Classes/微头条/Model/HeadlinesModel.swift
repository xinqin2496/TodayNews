//
//  HeadlinesModel.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/22.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit


class HeadlinesModel: NSObject {

    ///标识
    var cursor : Int?
    ///详情页
    var url : String?
    ///评论
    var comment_count : Int?
    ///内容
    var content : NSString?
    var title  : String?
    
    ///点赞
    var digg_count : Int?
    ///是否点赞
    var isLike : Bool?
    ///转发
    var forward_count : Int?
    ///大图
    var large_image_list = [LargeImageList]()
    ///缩略图
    var thumb_image_list = [LargeImageList]()
    ///时间
    var create_time : Int?
    var behot_time : Int?
    
    // 点击 删除按钮, 弹出框内容
    var filter_words = [FilterWord]()
    
    ///阅读量
    var read_count : Int?
    
    //用户信息
    var avatar_url : String?
    
    var screen_name : String?
    
    var verified_content : String?
    
    ///视频图
    
    var video_duration : Int?
    
    var isTitleColor : Bool?
    
    var isOpening : Bool? {
        
        didSet{
            if(!shouldShowMoreButton!){
                isOpening = false
            }
        }
    }
    
    var shouldShowMoreButton :Bool?
    
    fileprivate var _lastContentWidth : CGFloat = 0
    
    
    init(dict: [String : AnyObject]) {
        super.init()
     
        isLike = false
        
        cursor = dict["cursor"] as? Int
        
        comment_count =  dict["comment_count"] as? Int
        
        verified_content = dict["verified_content"] as? String
        
        var contentStr : NSString = ""
        
        if let str = dict["content"] {
            contentStr = str as! NSString
        }
        if contentStr.length == 0 {
            if let str = dict["title"] {
                contentStr = str as! NSString
            }
        }
        
        content = contentStr
        
        title = dict["title"] as? String
        
        digg_count = dict["digg_count"] as? Int
        
        if let forward = dict["forward_info"] {
            forward_count = forward["forward_count"] as? Int
        }
        
        read_count = dict["read_count"] as? Int
        
        behot_time = dict["behot_time"] as? Int
        
        create_time = dict["create_time"] as? Int
        
        if let duration = dict["video_duration"] {
            video_duration = duration as? Int
        }
        
        if let urlStr = dict["tiny_toutiao_url"] {
            url = urlStr as? String
        }
        if let urlStr = dict["url"] {
            url = urlStr as? String
        }
        //遍历举报的内容
        if let filterWords = dict["filter_words"] as? [AnyObject] {
            for item in filterWords {
                let filterWord = FilterWord(dict: item as! [String : AnyObject])
                filter_words.append(filterWord)
            }
        }
        
        let largeImageLists = dict["large_image_list"] as? [AnyObject]
        
        if (largeImageLists?.count)! > 0 {
            for index in largeImageLists! {
                let largeImage = LargeImageList(dict: index as! [String : AnyObject])
                large_image_list.append(largeImage)
            }
        }
        
        let thumbImageList = dict["thumb_image_list"] as? [AnyObject]
        
        if thumbImageList != nil  {
            for index in thumbImageList! {
                let thumbImage = LargeImageList(dict: index as! [String : AnyObject])
                thumb_image_list.append(thumbImage)
            }
        }
        
        if let userInfo = dict["user_info"] {
            
            avatar_url = userInfo["avatar_url"] as? String
            
            screen_name = userInfo["name"] as? String
        }
        if let user = dict["user"] {
            
            avatar_url = user["avatar_url"] as? String
            
            screen_name = user["screen_name"] as? String
        }
        
        ///计算label高度
        let contentW = Screen_Width - MyClassConstants.kMarginContentLeft - MyClassConstants.kMarginContentRight
        
        
        if contentW != _lastContentWidth {
            _lastContentWidth = contentW;
            
            if let contentStr = content {
                let textHeight = NSString.boundingRectWithString(contentStr, size: CGSize(width: contentW, height: CGFloat(MAXFLOAT)), fontSize: 16)
               
                ///设置显示内容的最大高度
                
                if  textHeight > MyClassConstants.maxContentLabelHeight + MyClassConstants.contentLabelFontSize {
                    shouldShowMoreButton = true;
                    isOpening = false
                } else {
                    shouldShowMoreButton = false;
                    isOpening = true
                }
            }
            
        }
        
        
        
        
    }
}


