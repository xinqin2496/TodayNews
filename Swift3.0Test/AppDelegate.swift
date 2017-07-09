//
//  AppDelegate.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/3.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = UIColor.white
        
        if !UserDefaults.standard.bool(forKey: isFirstLaunch) {
        
            //第一次启动
            window?.rootViewController = FirstLaunchController()
            
        }else{
            
            let tabBarController = MainTabBarController()
            tabBarController.delegate = self
            window?.rootViewController = tabBarController
            //设置启动图 url
            let imgUrlString = "http://p3.pstatp.com/origin/206a0002bfc2ca8a5c4c"
            
            
            JWLaunchAd.initImage(withAttribute: Int(6.0), showSkip: .default, setLaunchAd: { launchAd in
 
                launchAd?.setWebImageWithURL(imgUrlString, options: .default, result: { (_ image,_ url) in
                    
                    launchAd?.launchAdViewFrame = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height - 100)
                    
                }, adClick: {
                    
                    UIApplication.shared.openURL(URL(string: "http://www.jianshu.com/u/9e5f2143c765")!)
                })
                
                
              })
            
            
        }
        
        
        confitUShareSettings()
        
        window?.makeKeyAndVisible()
        
        NetworkRequest.shareNetworkRequest.NetworkStatusListener()

        return true
    }

    //配置 友盟 分享
    func confitUShareSettings() {
        //打开日志
        UMSocialManager.default().openLog(true)
        //打开图片水印
        UMSocialGlobal.shareInstance().isUsingWaterMark = true
        //不清楚缓存
        UMSocialGlobal.shareInstance().isClearCacheWhenGetUserInfo = false
        //设置 HTTPS
        UMSocialGlobal.shareInstance().isUsingHttpsWhenShareContent = true
        //设置 key
        UMSocialManager.default().umSocialAppkey = USHARE_DEMO_APPKEY
        
        configUSharePlatforms()
        
    }
    // 配置要分享到的应用的key
    func configUSharePlatforms() {
        
        let manager = UMSocialManager.default()
        //微信
        manager?.setPlaform(.wechatSession, appKey: "wxdc1e388c3822c80b", appSecret: "3baf1193c85774b3fd9d18447d76cab0", redirectURL: "http://mobile.umeng.com/social")
        //QQ
        manager?.setPlaform(.QQ, appKey: "1105821097", appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
        //新浪
        manager?.setPlaform(.sina, appKey: "3921700954", appSecret: "04b48b094faeb16683c32669824ebdad", redirectURL: "https://sns.whalecloud.com/sina2/callback")
        //支付宝
        manager?.setPlaform(.alipaySession, appKey: "2015111700822536", appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 发出通知
        NotificationCenter.default.post(name: Notification.Name(rawValue: ZZTabBarDidSelectedNotification), object: nil, userInfo: nil)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

