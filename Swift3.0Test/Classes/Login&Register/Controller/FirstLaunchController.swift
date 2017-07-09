//
//  FirstLaunchController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/4.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class FirstLaunchController: UIViewController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let model = UserDefaults.standard.object(forKey: userChangedModel)
        if let model1 = model {
            let isNight = model1 as! Bool
            view.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func mobileButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func wechatButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func QQButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func weiboButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func enterButtonClick(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: isFirstLaunch)
        
        UIApplication.shared.keyWindow?.rootViewController =  MainTabBarController()
       
    }

}
