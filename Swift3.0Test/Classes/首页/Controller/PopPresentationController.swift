//
//  PopPresentationController.swift
//
//  Created by 郑文青 on 2017/5/6.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//
//  iOS 8 以后推出的专门负责转场动画的控制器
//

import UIKit

class PopPresentationController: UIPresentationController {
    /// 定义弹出视图的大小
    var presentFrame = CGRect.zero
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

    }
    
    /// 即将布局转场子视图时调用
    override func containerViewWillLayoutSubviews() {
//        containerView // 容器视图
//        presentedView() // 被展现的视图
        containerView?.insertSubview(coverView, at: 0)
        // 修改弹出视图的尺寸
        presentedView?.frame = presentFrame
    }
    
    fileprivate lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        coverView.frame = UIScreen.main.bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissCoverView))
        coverView.addGestureRecognizer(tap)
        return coverView
    }()
    
    func dismissCoverView() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
