//
//  UIImageView+RotateImgV.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/3.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import SVProgressHUD

var oldframe:CGRect?


extension UIImageView :UIScrollViewDelegate{
    
    //给分类添加属性
    var originImageRect: CGRect? {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "key".hashValue)
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "key".hashValue)
            let obj: CGRect? = objc_getAssociatedObject(self, key) as? CGRect
            return obj
        }
    }
    
    
    var container_ScrollView: UIScrollView? {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "key1".hashValue)
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "key1".hashValue)
            let obj: UIScrollView? = objc_getAssociatedObject(self, key) as? UIScrollView
            return obj
        }
    }
    
    
    var container_View: UIView? {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "key2".hashValue)
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "key2".hashValue)
            let obj: UIView? = objc_getAssociatedObject(self, key) as? UIView
            return obj
        }
    }
    
    var snapShotView: UIView? {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "key3".hashValue)
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "key3".hashValue)
            let obj: UIView? = objc_getAssociatedObject(self, key) as? UIView
            return obj
        }
    }
    /// imageView 旋转
    ///
    /// - Parameters:
    ///   - duration: 周期 (控制速度:2--10)
    ///   - repeatCount: 次数
    func rotate360DegreeWithImageView(duration:CFTimeInterval , repeatCount :Float ) {
        
        //让其在z轴旋转
        let rotationAnimation  = CABasicAnimation(keyPath: "transform.rotation.z")
        
        //旋转角度
        rotationAnimation.toValue = NSNumber(value:  Double.pi * 2.0 )
        
         //旋转周期
        rotationAnimation.duration = duration;
        
        //旋转累加角度
        rotationAnimation.isCumulative = true;
        
        //旋转次数
        rotationAnimation.repeatCount = repeatCount;
        
        self.layer .add(rotationAnimation, forKey: "rotationAnimation")
        
    }
    //停止旋转
    func stopRotate() {
        
        self.layer.removeAllAnimations()
    }
    //点击缩放手势
    func scaleImageView() {
        let window = UIApplication.shared.keyWindow
        
        let image = self.image
        
        originImageRect = self.convert(self.bounds, to: window)
        
        container_ScrollView = UIScrollView(frame: CGRect( x: 0, y :0,width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        container_ScrollView?.delegate = self;
        
        container_ScrollView?.isMultipleTouchEnabled = true
        
        container_ScrollView?.maximumZoomScale = 3.0
        
        
        container_View = UIView()
        container_View?.frame = (container_ScrollView?.frame)!
        container_View?.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        
        snapShotView = self.snapshotView(afterScreenUpdates: true)
        snapShotView?.frame = originImageRect!
        
        container_View?.addSubview(snapShotView!)
        container_ScrollView?.addSubview(container_View!)
        window?.addSubview(container_ScrollView!)
        
        container_ScrollView?.addTarget(target: self, action: #selector(self.hideImage))
        
        container_ScrollView?.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        
        let rate =  UIScreen.main.bounds.size.width / (image?.size.width)!
        
        let finalRect = CGRect(x:0, y:( UIScreen.main.bounds.size.height - (image?.size.height)! * rate ) / 2, width:UIScreen.main.bounds.size.width,height:(image?.size.height)! * rate)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: { 
            self.snapShotView?.frame = finalRect
            self.container_ScrollView?.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1.0)
        }) { (finished) in
            
        }
        
        let saveBtn = UIButton(type: .custom)
        saveBtn.tag = 131
        saveBtn.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        saveBtn.setTitle("保存", for: UIControlState())
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        saveBtn.layer.masksToBounds = true
        saveBtn.layer.cornerRadius = 5
        saveBtn.setTitleColor(UIColor.white, for: UIControlState())
        saveBtn.frame = CGRect(x: Screen_Width - 70, y: Screen_Height - 40 , width: 60, height: 30)
        saveBtn.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        window?.addSubview(saveBtn)
        
    }
   
    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(self.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil{
            print("error!")
            return
        }
//        UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("图片保存成功")
        SVProgressHUD.showSuccess(withStatus: "图片保存成功")
    }
    //缩放隐藏
    func hideImage() {
        
        let saveBtn = UIApplication.shared.keyWindow?.viewWithTag(131)
        saveBtn?.removeFromSuperview()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.container_ScrollView?.zoomScale = 1.0
            self.snapShotView?.frame = self.originImageRect!
            self.container_ScrollView?.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
            self.container_ScrollView?.removeFromSuperview()
        }) { (finished) in
            
            
        }
        
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return container_View
    }
    
    //展示长图片
    func showLongImage() {
        
        let window = UIApplication.shared.keyWindow
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height))
        oldframe = self.convert(self.bounds, to: window)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.0
        self.isUserInteractionEnabled = true
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height))
        
        scrollView.contentSize = CGSize(width: Screen_Width, height: self.height)
        scrollView.showsHorizontalScrollIndicator = false
        backgroundView.addSubview(scrollView)
        
        let imageView = UIImageView(frame: oldframe!)
        imageView.image = self.image
        imageView.tag = 121
        scrollView.addSubview(imageView)
        
        window?.addSubview(backgroundView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideLongImage(_ :)))
        backgroundView.addGestureRecognizer(tap)
        
        UIView.animate(withDuration: 0.5, animations: { 
            imageView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: self.frame.size.height)
            backgroundView.alpha = 1
        }) { (_) in
            
        }
        let saveBtn = UIButton(type: .custom)
        saveBtn.tag = 131
        saveBtn.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        saveBtn.setTitle("保存", for: UIControlState())
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        saveBtn.layer.masksToBounds = true
        saveBtn.layer.cornerRadius = 5
        saveBtn.setTitleColor(UIColor.white, for: UIControlState())
        saveBtn.frame = CGRect(x: Screen_Width - 70, y: Screen_Height - 40 , width: 60, height: 30)
        saveBtn.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        window?.addSubview(saveBtn)
    }
    
    func hideLongImage(_ tap : UITapGestureRecognizer)  {
        let saveBtn = UIApplication.shared.keyWindow?.viewWithTag(131)
        let backgroundView = tap.view
        let imageView = backgroundView?.viewWithTag(121) as! UIImageView
        
        UIView.animate(withDuration: 0.5, animations: {
            imageView.frame = oldframe!
            backgroundView?.alpha = 0
            saveBtn?.alpha = 0
        }) { (_) in
            backgroundView?.removeFromSuperview()
            saveBtn?.removeFromSuperview()
        }
        
    }
    
    
    
}
