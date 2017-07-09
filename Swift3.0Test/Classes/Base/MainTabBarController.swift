//
//  MainTabBarController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/4.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBar = UITabBar.appearance()
        
        tabBar.tintColor = UIColor.white
        tabBar.isTranslucent = false
        
        addChildViewControllers()
        
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        if let model1 = model {
            let isNight = model1 as! Bool
            tabBar.barTintColor = isNight ? UIColor.darkGray : UIColor.white
        }
        NotificationCenter.default.addObserver(self, selector: #selector(saveChangedModelNoti(_ :)), name: NSNotification.Name(rawValue: postChangedModelNotification), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveChangedModelNoti(_ noti: Notification) {
        let info = noti.userInfo! as NSDictionary
        
        let node = info.object(forKey: "isNight") as! String
        
       switchTheSkin( node.compare("true").rawValue == 0)
       
      
    }
    func switchTheSkin(_ isNight : Bool) {
        
        let view1 = tabBar.viewWithTag(156)
        if view1 != nil {
            UIView.animate(withDuration: 0.5, animations: { 
                view1?.alpha = 0
            }, completion: { (_) in
                view1?.removeFromSuperview()
            })
        }
        
        let bgview = UIView(frame: tabBar.bounds)
        bgview.tag = 156
        bgview.alpha = 0
        bgview.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
        tabBar.insertSubview(bgview, at: 0)
        
        UIView.animate(withDuration: 0.5) {
            bgview.alpha = 1
        }
          
    }
    
    //私有方法
   fileprivate func addChildViewControllers(){
    
    addChildViewController(HomeViewController(), title: "首页", imageName: "tab_stream", selectedImageName: "tab_stream_pressed")
    
    addChildViewController(VideoViewController(), title: "视频", imageName: "tab_video", selectedImageName:"tab_video_pressed")
    
    addChildViewController(HeadlinesViewController(), title: "微头条", imageName: "tab_weitoutiao", selectedImageName: "tab_weitoutiao_pressed")
    
    addChildViewController(MineViewController(), title: "未登录", imageName: "tab_no_login", selectedImageName: "tab_no_login_pressed")
    }

     func addChildViewController(_ childController: UIViewController , title: String , imageName: String , selectedImageName:String) {
        
        childController.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName:ZZGlobalRedColor()], for:UIControlState.selected)
        
        childController.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 12)], for:UIControlState.normal)
        
        childController.tabBarItem.title = title
        childController.tabBarItem.selectedImage = UIImage(named:selectedImageName)
        childController.tabBarItem.image = UIImage(named: imageName)
        let navi = MainNavigationController(rootViewController: childController)
        addChildViewController(navi)
        
    }

}
