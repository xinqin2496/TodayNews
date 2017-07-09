//
//  MineCellModel.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class MineCellModel: NSObject {
    
    var title: String?
    var subtitle: String?
    var isHiddenLine: Bool?
    var isHiddenSubtitle: Bool?
    
    init(dict: [String: AnyObject]) {
        super.init()
        title = dict["title"] as? String
        subtitle = dict["subtitle"] as? String
        isHiddenSubtitle = dict["isHiddenSubtitle"] as? Bool
    }
}
