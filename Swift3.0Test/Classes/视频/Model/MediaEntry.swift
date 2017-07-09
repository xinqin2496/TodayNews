//
//  MediaEntry.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/4.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class MediaEntry: NSObject {
    
    var describe: String?

    var id: Int = 0

    var subscribe_count: Int = 0

    var is_subscribed: Bool = false

    var auth_info: String?

    var type: Int = 0

    var icon: String?

    var vip_level: Int = 0

    var entry_id: Int = 0

    var share_url: String?

    var media_id: Int = 0

    var name: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        describe = dict["description"] as? String
        media_id = dict["media_id"] as! Int
        subscribe_count = dict["subscribe_count"] as! Int
        is_subscribed = dict["is_subscribed"] as! Bool
        entry_id = dict["entry_id"] as! Int
        id = dict["id"] as! Int
        icon = dict["icon"] as? String
        name = dict["name"] as? String
        share_url = dict["share_url"] as? String
        auth_info = dict["auth_info"] as? String
        vip_level = dict["vip_level"] as! Int
        type = dict["type"] as! Int
    }
    
}
