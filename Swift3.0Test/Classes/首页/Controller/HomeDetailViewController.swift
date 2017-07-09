//
//  HomeDetailViewController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/10.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import WebKit

class HomeDetailViewController: UIViewController ,UINavigationControllerDelegate,UIScrollViewDelegate{

    var newTopics : NewsTopic?
    
    var headlines : HeadlinesModel?
    
    var isTost : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    
        ///注册键盘通知
        registerKeyboardNotification()
        
        isTost = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.view.backgroundColor = ZZGlobalColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:  UIImage(named: "new_more_titlebar_28x28_"), style: .plain, target: self, action: #selector(homeDetailShareItemClick))
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.barStyle = .default
        navigationItem.titleView = toptitleView
        toptitleView.isHidden = true
        toptitleView.alpha = 0
        
        view.addSubview(webView)
        view.addSubview(progressView)
        
        view.addSubview(bottomView)
        toptitleView.addSubview(lineLabel)
        toptitleView.addSubview(titleLabel)
        toptitleView.addSubview(avatarImageView)
        
        lineLabel.snp.makeConstraints { (make) in
            make.center.equalTo(toptitleView.snp.center)
            make.width.equalTo(1)
            make.height.equalTo(toptitleView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lineLabel.snp.right).offset(-5)
            make.centerY.equalTo(avatarImageView.snp.centerY).offset(0)
        }
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(lineLabel.snp.centerY)
            make.width.height.equalTo(30)
            make.right.equalTo(lineLabel.snp.left).offset(-10)
        }
        
        webView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(45)
        }
        
        var urlStr : String?
        if newTopics != nil {
            
            if let url = newTopics?.url {
                urlStr = url
            }
        }else{
            if let url = headlines?.url {
                urlStr = url
            }
        }
        
        
        let url = URL(string: urlStr!)
        let request = URLRequest(url: url!)
       
        webView.load(request as URLRequest)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        // MARK: 底部评论区
        var count : Int?
        if newTopics != nil {
            count = newTopics!.comment_count!
            if let sourceAvatar = newTopics?.source_avatar {
                avatarImageView.kf.setImage(with: URL(string: sourceAvatar))
                titleLabel.text = newTopics?.source
            }
            
            if let mediaInfo = newTopics!.media_info {
                avatarImageView.kf.setImage(with: URL(string: mediaInfo.avatar_url!))
                titleLabel.text = mediaInfo.name
            }
        }else{
            if let comment_count = headlines?.comment_count {
                count = comment_count
            }
            if let avater = headlines?.avatar_url {
                avatarImageView.kf.setImage(with: URL(string: (avater)))
            }
            if let name = headlines?.screen_name {
               titleLabel.text = name
            }
            
        }
        
        bottomView.commentCount = count
        
        view.addSubview(commentBGView)
        
        view.addSubview(commentView)
        
        commentView.placeholderText = "优质评论将会优先展示"
        
        //底部按钮的分享
        bottomView.didSelectedShareItemClickClosure { [weak self](sender) in
            self!.homeDetailShareItemClick()
        }
        //点击评论
        bottomView.didSelectedCommViewTapClosure {[weak self]() in
            self!.commentView.isHidden = false
            self!.commentView.showResponder = true
        }
        //点击弹出框的发送
        commentView.clikSendButtonClourse {[weak self] (text) in
            
            self!.view.makeToast(text)
        }
        
    }
    ///注册键盘通知
    func registerKeyboardNotification() {
        
        // 监听键盘 frame变化的 通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_ :)), name:.UIKeyboardWillChangeFrame , object: nil)
    }
    func keyboardWillChangeFrame(_ notification :Notification)  {
        let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
      
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        let keyboardDuration = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        
        if y == Screen_Height {//收回
            
            UIView.animate(withDuration: TimeInterval(keyboardDuration), animations: {
                self.commentBGView.isHidden = true
                self.commentView.isHidden = true
                self.commentView.frame = CGRect(x: 0, y: Screen_Height - 50 - 50, width: Screen_Width, height: 50)
            }) { (_) in
                self.commentBGView.isHidden = true
            }
            
            hidekeyboard()
            
        }else{
            UIView.animate(withDuration: TimeInterval(keyboardDuration)) {
                self.commentBGView.isHidden = false
                
                self.commentView.frame = CGRect(x: 0, y: Screen_Height - 50 - 64 - keyboardHeight, width: Screen_Width, height: 50)
                
            }
        }
       
    }

    ///点击背景隐藏键盘
    func hidekeyboard() {
        commentView.showResponder = false
        commentView.isHidden = true
    }

    ///弹出的评论区

    fileprivate lazy var commentView : CommentView = {
        
        let commentView = CommentView(frame: CGRect(x: 0, y: Screen_Height - 100, width: Screen_Width, height: 50))
        commentView.isHidden = true
        return commentView
    }()
    //创建弹出评论时背景
    fileprivate lazy var commentBGView : UIButton = {
        
        let commentBGView = UIButton(type: UIButtonType.custom)
        commentBGView.isHidden = true
        commentBGView.backgroundColor = UIColor.clear
        commentBGView.frame = self.view.bounds
        commentBGView.addTarget(self, action: #selector(hidekeyboard), for: .touchUpInside)
        return commentBGView
    }()
    
    ///创建加载时背景view
    
    fileprivate lazy var gradientView : GradientView = {
      
        let titleStr : NSString = "你关心的\n 才是头条"
        
        let attributeDict = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20),NSKernAttributeName:1] as [String : Any]
        let size = titleStr.boundingRect(with: CGSize(width:Screen_Width,height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attributeDict, context: nil).size
        
        let gradientView = GradientView(frame: CGRect(x: 0, y:0, width: Screen_Width, height: Screen_Height - 64 - 45))
        
        gradientView.titleStr = titleStr as String
        
        return gradientView
    }()
    // 进度条
    lazy var progressView:UIProgressView = {
        let progress = UIProgressView(frame: CGRect(x:0,y:0,width:self.view.frame.size.width,height:2))
        progress.progressTintColor = ZZColor(0, g: 122, b: 255, a: 1.0)
        progress.trackTintColor = .white
        return progress
    }()
    
    
    ///点击分享
    func homeDetailShareItemClick() {
        
        if newTopics != nil {
            let shareView = HomeShareView.getView(newTopics!)
            shareView.showShareView()
        }else{
            let shareView = HomeShareView.getView(nil)
            shareView.showShareView()
        }
    
        
    }
    //titleView
    fileprivate lazy var toptitleView : UIView = {
        
        let toptitleView = UIView(frame: CGRect(x: 0, y: 0, width: Screen_Width - 120, height: 40))
        
        return toptitleView
    }()
    //titleView 上的 作者头像
    fileprivate lazy var avatarImageView : UIImageView = {
        
        let avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 15.0;
        avatarImageView.layer.masksToBounds = true;
        return avatarImageView
    }()
    //提示文字
    fileprivate lazy var titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        return titleLabel
    }()
    //中心线
    fileprivate lazy var lineLabel : UILabel = {
        
        let lineLabel = UILabel()
        
        return lineLabel
    }()
   
    
    //详情网页
    fileprivate lazy var webView: WKWebView = {
        let webView = WKWebView()
         webView.scrollView.delegate = self
         webView.navigationDelegate = self
        return webView
    }()
    //底部评论
    lazy var bottomView : DetailBottomView = {
        
        let bottomView = Bundle.main.loadNibNamed("DetailBottomView", owner: nil, options: nil)!.last as! DetailBottomView
        
        return bottomView
    }()
    
    //滚动时显示
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsety = scrollView.contentOffset.y
        if offsety <= 150 {
            UIView.animate(withDuration: 1.5, animations: {
                 self.toptitleView.isHidden = true
                self.toptitleView.alpha = 0
            })
           
        }else{
            UIView.animate(withDuration: 1.5, animations: {
                self.toptitleView.isHidden = false
                self.toptitleView.alpha = 1
            })
        }
    }
    
    deinit {
        
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.reloadInputViews()
        
        // 移除键盘通知
        NotificationCenter.default.removeObserver(target, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(target, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
 // MARK: WKNavigationDelegate WKUIDelegate
extension HomeDetailViewController:WKNavigationDelegate,WKUIDelegate{
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
           
        }
    }
   
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
        if !isTost! {
            view.addSubview(gradientView)
        }
        

       
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        gradientView.removeFromSuperview()
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        
         progressView.setProgress(0.0, animated: false)
        webView.evaluateJavaScript("document.body.offsetHeight") { (result, error) in
            
            let documentHeight = result as! CGFloat
            
            print("documentHeight---",documentHeight)
            
        }
        isTost = true
       
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
        
        /// 弹出提示框点击确定返回
        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
//            _=self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        
//        let request = navigationAction.request.url?.absoluteString.utf8
//        print("_______",request ?? "没有url")
//        decisionHandler(.allow)
//    }
   
}

