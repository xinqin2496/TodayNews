//
//  Const.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/3.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

enum ZZOtherLoginButtonType: Int {
    /// 微博
    case weiboLogin = 100
    /// 微信
    case weChatLogin = 101
    /// QQ
    case qqLogin = 102
}

struct MyClassConstants {
    
    static let  contentLabelFontSize : CGFloat = 16.0
    static let  maxContentLabelHeight : CGFloat = 70.0 //根据具体font而定
    static let  kMarginContentLeft : CGFloat = 10.0   //动态内容左边边距
    static let  kMarginContentRight : CGFloat = 10.0  //动态内容右边边边距
}
//友盟分享的key

let USHARE_DEMO_APPKEY :String = "5920162cf5ade43600000da4"//"5861e5daf5ade41326001eab"

/// iid 未登录用户 id，只要安装了今日头条就会生成一个 iid
/// 可以在自己的手机上安装一个今日头条，然后通过 charles 抓取一下这个 iid，
/// 替换成自己的，再进行测试
let IID: String = "9899530711"
let device_id: String = "34733837782"
let version_code = "6.1.0"
/// tabBar 被点击的通知
let ZZTabBarDidSelectedNotification = "ZZTabBarDidSelectedNotification"
//刷新搜索文字
let ZZRefreshSearchTitleNotification = "ZZRefreshSearchTitleNotification"
/// 服务器地址
let BASE_URL = "http://lf.snssdk.com/"

/// 第一次启动
let isFirstLaunch = "firstLaunch"
/// 是否登录
let isLogin = "isLogin"

//切换皮肤通知
let postChangedModelNotification = "postChangedModelNoti"
//本地保存的皮肤状态
let userChangedModel = "changedModel"

/// code 码 200 操作成功
let RETURN_OK = 200
/// 间距
let kMargin: CGFloat = 10.0
/// 首页新闻间距
let kHomeMargin: CGFloat = 15.0
/// 圆角
let kCornerRadius: CGFloat = 5.0
/// 线宽
let klineWidth: CGFloat = 1.0
/// 首页顶部标签指示条的高度
let kIndicatorViewH: CGFloat = 2.0
/// 新特性界面图片数量
let kNewFeatureCount = 4
/// 顶部标题的高度
let kTitlesViewH: CGFloat = 35
/// 顶部标题的y
let kTitlesViewY: CGFloat = 64
/// 动画时长
let kAnimationDuration = 0.25
///分享界面的高度
let kShareViewH :CGFloat = 290
/// 屏幕的宽
let Screen_Width = UIScreen.main.bounds.size.width
/// 屏幕的高
let Screen_Height = UIScreen.main.bounds.size.height
/// 我的界面头部图像的高度
let kZZMineHeaderImageHeight: CGFloat = 210
//  个人界面 cell 高度
let kMineCellH: CGFloat = 44
//评论文本框文字输入的高度
let MaxTextViewHeight :CGFloat = 80

//我的频道
let kTopTitlePath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).first!)/top_titles.archive"
//推荐频道
let kRecommendTopicsPath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).first!)/recommendTopics.archive"
/// RGBA的颜色设置
func ZZColor(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}
///天气背景
func ZZWeatherBGColor() -> UIColor {
    return ZZColor(1, g: 1, b: 1, a: 0.2)
}
/// 背景灰色
func ZZGlobalColor() -> UIColor {
    return ZZColor(245, g: 245, b: 245, a: 1)
}

/// 红色
func ZZGlobalRedColor() -> UIColor {
    return ZZColor(248, g: 89, b: 89, a: 1.0)
}

/// iPhone 5
let isIPhone5 = Screen_Height == 568 ? true : false
/// iPhone 6
let isIPhone6 = Screen_Height == 667 ? true : false
/// iPhone 6P
let isIPhone6P = Screen_Height == 736 ? true : false
