//
//  PopViewController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/6.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//
//  弹出新闻屏蔽内容
//

import UIKit

class PopViewController: UIViewController {

    // MARK: 删除
    var closeButtonClosure : ((_ sender : UIButton) -> ())?
    //记录 关闭按钮的坐标
    var closeButtonPoint = CGPoint()
    
    var filterWords = [FilterWord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.addSubview(popView)
        popView.filterWords = filterWords
        popView.closeBtnPoint = closeButtonPoint
  
        popView.addInterestButtonClickClosure { [weak self](button) in
            
            self?.closeButtonClosure!(button)
        }
        switch filterWords.count {
        case 0:
            popView.frame = CGRect.zero
        case 1, 2:
            popView.frame = CGRect(x: kMargin, y: 8, width: Screen_Width - 2 * kMargin, height: 98)
        case 3, 4:
            popView.frame = CGRect(x: kMargin, y: 8, width: Screen_Width - 2 * kMargin , height: 140)
        case 5, 6:
            popView.frame = CGRect(x: kMargin, y: 8, width: Screen_Width - 2 * kMargin , height: 182)
        default:
            popView.frame = CGRect.zero
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate lazy var popView: PopView = {
        let popView = PopView()
        
        return popView
    }()

    //添加闭包按钮
    func addButtonClickClosure(_ closure: @escaping (_ sender :UIButton) -> ()) {
        
        closeButtonClosure = closure
    }
}
