//
//  HomeShare.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/10.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class HomeShare: NSObject {

    var icon : String?
    
    var icon_night : String?
    
    var title : String?
    
    init(dict: [String : AnyObject]) {
        super.init()

        icon = dict["icon"] as? String
        icon_night = dict["icon_night"] as? String
        title = dict["title"] as? String
    }
  
}
