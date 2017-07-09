//
//  VideoTopTitle.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/4.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import Foundation

class VideoTopTitle: NSObject {

    var category: String?

    var tip_new: Int?

    var web_url: String?

    var icon_url: String?

    var flags: Int?

    var type: Int?

    var name: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        category = dict["category"] as? String
        tip_new = dict["tip_new"] as? Int
        web_url = dict["web_url"] as? String
        icon_url = dict["icon_url"] as? String
        flags = dict["flags"] as? Int
        type = dict["type"] as? Int
        name = dict["name"] as? String
    }
}
