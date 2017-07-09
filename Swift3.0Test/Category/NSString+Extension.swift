//
//  StringMd5.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/3.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import Foundation

extension NSString {
    
    //32位 小写 md5 加密
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8.rawValue)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8.rawValue))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result =  UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        
        return String(format: hash as String)
    }
    
    /// 返回文字的高度
    class func boundingRectWithString(_ string: NSString, size: CGSize, fontSize: CGFloat) -> CGFloat {
        return string.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)], context: nil).size.height
    }
    
    // 处理日期的格式
    class func changeDateTime(_ publish_time: Int) -> String {
        // 把秒转化成时间
        let publishTime = Date(timeIntervalSince1970: TimeInterval(publish_time))
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
        let delta = Date().timeIntervalSince(publishTime)
    
        if (publish_time == 0) {
            return ""
        }
        if (delta <= 0) {
            return "刚刚"
        }
        else if (delta < 60) {
            return "\(Int(delta))秒前"
        }
        else if (delta < 3600) {
            return "\(Int(delta / 60))分钟前"
        }
        else {
            let calendar = Calendar.current
            // 现在
            let comp = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: Date())
            // 发布时间
            let comp2 = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: publishTime)
            
            if comp.year == comp2.year {
                if comp.day == comp2.day {
                    return "\(comp.hour! - comp2.hour!)小时前"
                } else {
                    return "\(comp2.month!)-\(comp2.day!) \(comp2.hour!):\(comp2.minute!)"
                }
            } else {
                
                return "\(comp2.year!)-\(comp2.month!)-\(comp2.day!) \(comp2.hour!):\(comp2.minute!)"
                
            }
        }
    }

    
   
}
