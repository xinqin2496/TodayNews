//
//  PopViewAnimator.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/7.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class PopViewAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    /// 定义弹出视图的 Y
    
    var popViewY = CGFloat()
    
    /// 记录当前是否展开视图
    var isPresent: Bool = false
    
    var filterWordCount  = Int()
    
    // MARK: - UIViewControllerTransitioningDelegate
    /**
     告诉系统由哪个控制器来实现代理
     - parameter presented:  被展现的视图
     - parameter presenting: 展现的视图
     - returns: YMPopPresentationController iOS 8 以后推出的专门负责转场动画的控制器
     */
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let popPC = PopPresentationController(presentedViewController: presented, presenting: presenting)
        
        if (popViewY - (Screen_Height ) / 2 ) > 100  {//在上面弹出
            
            switch filterWordCount {
            case 0:
                popPC.presentFrame = CGRect.zero
            case 1, 2:
                popPC.presentFrame = CGRect(x: 0, y:popViewY - 109 - 20, width: Screen_Width , height: 109)
                
            case 3, 4:
                popPC.presentFrame = CGRect(x: 0, y: popViewY - 151 - 20, width: Screen_Width , height: 151)
                
            case 5, 6:
                popPC.presentFrame = CGRect(x: 0, y: popViewY - 193 - 20 , width: Screen_Width , height: 193)
            default:
                popPC.presentFrame = CGRect.zero
            }
        }else{//在下面弹出
            
            switch filterWordCount {
            case 0:
                popPC.presentFrame = CGRect.zero
            case 1, 2:
                popPC.presentFrame = CGRect(x: 0, y: popViewY , width: Screen_Width , height: 109)
                
            case 3, 4:
                popPC.presentFrame = CGRect(x: 0, y: popViewY , width: Screen_Width , height: 151)
                
            case 5, 6:
                popPC.presentFrame = CGRect(x: 0, y: popViewY , width: Screen_Width , height: 193)
            default:
                popPC.presentFrame = CGRect.zero
            }
        }

        return popPC
    }
    
    /**
     告诉系统谁来负责 modal 的展现动画
     - parameter presented:  被展现的视图
     - parameter presenting: 展现的视图
     - returns: 由谁管理
     */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    /**
     告诉系统谁来负责 modal 的消失动画
     - parameter dismissed: 消失的控制器
     - returns: 由谁管理
     */
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    // MARK: - 只要实现了下面两个方法，那么系统默认就没有了，所有东西都需要自己实现
    /** 动画时长*/
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    /** 负责转场动画的效果*/
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            // 展开
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            // 一定要将视图添加到容器上
            transitionContext.containerView.addSubview(toView!)
            // 锚点 (x: 1.0, y: 0.0)右上角弹出  (x: 0.0, y: 1.0)左下角弹出 (x: 1.0, y: 1.0)右下角弹出
            // (x: 0.0, y: 0.0) 左上角弹出
            if (popViewY - (Screen_Height ) / 2 ) > 100 {
            
                 toView?.layer.anchorPoint = CGPoint(x: 1.0, y: 1.0)
            }else{
                toView?.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
            }
           
            toView?.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                toView?.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
        } else {
            // 关闭
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            // CGFloat 是不准确的，如果写 0.0 会没有动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView?.transform = CGAffineTransform(scaleX: 0.000001, y: 0.000001)
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
        }
    }
}
