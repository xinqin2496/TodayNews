//
//  WebViewController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/7.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var urlStr :String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ZZGlobalColor()
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.barStyle = .default
        
        view.addSubview(self.webView)
        view.addSubview(self.progressView)
        
        let url = NSURL(string: urlStr!)
      
        let requst = NSURLRequest(url: url! as URL)
        
        webView.load(requst as URLRequest)
        
        /// .webView.estimatedProgress加载进度
 
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // webView
    lazy var webView : WKWebView = {
        let web = WKWebView( frame: CGRect(x:0, y:0,width:Screen_Width, height:Screen_Height - 64))
        
        /// 设置代理
        web.navigationDelegate = self
        
        return web
    }()

    // 进度条
    lazy var progressView:UIProgressView = {
        let progress = UIProgressView(frame: CGRect(x:0,y:0,width:self.view.frame.size.width,height:2))
        progress.progressTintColor = ZZColor(0, g: 122, b: 255, a: 1.0)
        progress.trackTintColor = .white
        return progress
    }()
    
    deinit {
        
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.reloadInputViews()
    }
}



extension WebViewController:WKNavigationDelegate,WKUIDelegate{
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            print(webView.estimatedProgress)
        }
    }
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        self.navigationItem.title = "加载中..."

    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        /// 获取网页title
        self.navigationItem.title = webView.title
        progressView.setProgress(0.0, animated: false)
        
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
            _=self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
}
