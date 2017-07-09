//
//  MainNavigationController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let navBar = UINavigationBar.appearance()
        
        navBar.tintColor = UIColor.black
        
        navBar.isTranslucent = false
        
//        navBar.barTintColor = ZZGlobalRedColor()
        
        navBar.backgroundColor = UIColor.white
        
        navBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        
//        navBar.barStyle = .black
        
        fd_interactivePopDisabled = false
       
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        
        if let changedModel = model {
            
            self.switchTheSkin(changedModel as! Bool)
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
        
        
        switchTheSkin(node.compare("true").rawValue == 0)
    }

    ///切换主题
    func switchTheSkin(_ night : Bool) {
        
        let navBar = UINavigationBar.appearance()
    
        navBar.barTintColor = night ?  UIColor.darkGray : UIColor.white
            
    }
    ///返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"lefterbackicon_titlebar_28x28_"), style: .plain, target: self, action: #selector(navigationBack))
      }
        
        super .pushViewController(viewController, animated: true)
    }
    func navigationBack() {
        popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
  

}
