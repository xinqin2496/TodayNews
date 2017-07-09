//
//  HWShareView.swift
//  ShareAnimat
//
//  Created by 韩威 on 2016/11/24.
//  Copyright © 2016年 Wei Han. All rights reserved.
//

import UIKit
import MessageUI
import SVProgressHUD

let selfHeight: CGFloat = 320

class HomeShareView: UIView ,MFMailComposeViewControllerDelegate{
    @IBOutlet weak var advertImageView: UIImageView!
    
    @IBOutlet weak var topScrollView: UIScrollView!
    @IBOutlet weak var bottomScrollView: UIScrollView!
    
    fileprivate var newTopic : NewsTopic?
    
    
    // MARK: - Propertites
    fileprivate lazy var bgView: UIView = {
        let view = UIView.init(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: Screen_Width, height: Screen_Height - selfHeight)
        btn.addTarget(self, action: #selector(HomeShareView.bgTap), for: .touchUpInside)
        view.addSubview(btn)
        view.addSubview(self)
        return view
    }()
    fileprivate lazy var bgAlphaView: UIView = {
        let view = UIView.init(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: Screen_Width, height: Screen_Height - selfHeight)
        btn.addTarget(self, action: #selector(HomeShareView.bgTap), for: .touchUpInside)
        view.addSubview(btn)
        view.addSubview(self)
        return view
    }()
    //点击屏幕取消
    @objc func bgTap() {
        cancle()
    }
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    
    private func setup() {

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = ZZColor(240, g: 240, b: 240, a: 1.0)
        self.frame = CGRect(x: 0, y: Screen_Height, width: Screen_Width, height: selfHeight)
        
        advertImageView.kf.setImage(with:URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494480098312&di=2cfccfd118a86eecacfb31768ccc82da&imgtype=0&src=http%3A%2F%2Fpic109.nipic.com%2Ffile%2F20160912%2F23350042_173725560000_2.jpg")!)
        
        let path = Bundle.main.path(forResource: "SharePlist", ofType: ".plist")
        
        let sharetopArray = NSArray(contentsOfFile: path!)?.firstObject as! Array<Any>
        
        var topImageArr  = [String]()
        var topTitleArr  = [String]()
        for item in sharetopArray {
            let  share = HomeShare(dict: item as! [String : AnyObject])
            topImageArr.append(share.icon!)
            topTitleArr.append(share.title!)
        }
        
        let sharebottomArray = NSArray(contentsOfFile: path!)?.lastObject as! Array<Any>
        var bottomImageArr  = [String]()
        var bottomTitleArr  = [String]()
        
        for item in sharebottomArray {
            let  share = HomeShare(dict: item as! [String : AnyObject])
            bottomImageArr.append(share.icon!)
            bottomTitleArr.append(share.title!)
        }
        
        setScrollViewContent(withScrollView: topScrollView, imgArray: topImageArr, titleArray: topTitleArr)
        
        setScrollViewContent(withScrollView: bottomScrollView, imgArray: bottomImageArr, titleArray: bottomTitleArr)
        
    }
    
    fileprivate func setScrollViewContent(withScrollView scrollView: UIScrollView, imgArray: [String], titleArray: [String]) {
        
        let btnW: CGFloat = 80
        let btnH: CGFloat = 80
        let btnY: CGFloat = 15
        var btnX: CGFloat = 0
        
        for (index, value) in imgArray.enumerated() {
            
            btnX = btnW * CGFloat(index) + kMargin
            
            let btn = ShareVerticalButton(type: .custom)
            btn.frame = CGRect.init(x: btnX, y: btnY, width: btnW, height: btnH)
            btn.setImage(UIImage.init(named: value), for: .normal)
            btn.setTitle(titleArray[index], for: .normal)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            scrollView.addSubview(btn)
            
            btn.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
            
            if index == imgArray.count - 1 {
                scrollView.contentSize = CGSize.init(width: btn.frame.maxX + kMargin, height: btnH)
            }
        }
        
        
    }
    
    @IBAction func cancle() {
        
        UIView.animate(withDuration: 0.1, animations: {
            
            self.frame.origin.y = Screen_Height
            
        }, completion: { _ in
            
            self.bgView.removeFromSuperview()
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func showShareView(){
        
        let topWindow = UIApplication.shared.windows.last!
        topWindow.addSubview(bgView)
        UIView.animate(withDuration: 0.3, animations: {
            
        }, completion: { _ in
            
        })
        var delay: TimeInterval = 0
        var i: TimeInterval = 0
        for subview in self.allSubviews() {
            if subview is ShareVerticalButton {
                if i == 5 {
                    delay = 0
                }
                delay += 0.05
                i += 1
                
                let btn = subview as! ShareVerticalButton
                btn.shakeBtn(delay: delay)
            }
        }
        
        self.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
            self.frame.origin.y = Screen_Height - selfHeight
            
        }, completion: { _ in
            
        })
    }
    
    class func getView(_ newtopic:NewsTopic?) -> HomeShareView {
        let view = HomeShareView.loadViewFromXib() as! HomeShareView
        if let topic = newtopic {
           view.newTopic = topic
        }
        return view 
    }
}

//创建按钮放在分类上
extension HomeShareView {
    
    
    //按钮点击
    func shareButtonClick(_ button : ShareVerticalButton) {
        print("点击了---- \(button.titleLabel!.text!) ")
        
         cancle()
        if (newTopic == nil) {
            SVProgressHUD.showSuccess(withStatus: "点击了---- \(button.titleLabel!.text!) ")
            return
        }
        
        let text = button.titleLabel!.text!
        
        if (text.compare("系统分享").rawValue == 0 ){
            //把 url 分享出去
            let url = URL(string: "http://www.jianshu.com/u/9e5f2143c765")!
            
            let objectsToShare = [url]
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            let excludedActivities = [UIActivityType.postToWeibo,UIActivityType.postToTwitter,UIActivityType.postToVimeo,UIActivityType.postToFacebook,UIActivityType.postToTencentWeibo,UIActivityType.message,UIActivityType.mail,UIActivityType.copyToPasteboard,UIActivityType.assignToContact,UIActivityType.print,UIActivityType.airDrop,UIActivityType.addToReadingList,UIActivityType.postToFlickr]
            activityVC.excludedActivityTypes = excludedActivities
            
            UIApplication.shared.keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
            
            return
        }
        else if (text.compare("收藏").rawValue == 0 ){
            
            return
        }
        else if (text.compare("举报").rawValue == 0 ){
            
            return
        }else if (text.compare("评论").rawValue == 0 ){
            
            return
        }
        else if (text.compare("复制链接").rawValue == 0 ){
            
            return
        }else if (text.compare("邮件").rawValue == 0 ){
            if MFMailComposeViewController.canSendMail() {
                //注意这个实例要写在if block里，否则无法发送邮件时会出现两次提示弹窗（一次是系统的）
                let mailComposeViewController = configuredMailComposeViewController()
                UIApplication.shared.keyWindow?.rootViewController?.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            return
        }
        
        var shareType : UMSocialPlatformType?
        
        
        if text.compare("微信朋友圈").rawValue == 0  {
            
            shareType = UMSocialPlatformType.wechatTimeLine
            
        }else if (text.compare("微信好友").rawValue == 0 ){
            
            shareType = UMSocialPlatformType.wechatSession
        }else if (text.compare("手机QQ").rawValue == 0 ){
            shareType = UMSocialPlatformType.QQ
        }
        else if (text.compare("QQ空间").rawValue == 0 ){
            shareType = UMSocialPlatformType.qzone
        }
        else if (text.compare("新浪微博").rawValue == 0 ){
            shareType = UMSocialPlatformType.sina
        }
        else if (text.compare("腾讯微博").rawValue == 0 ){
            shareType = UMSocialPlatformType.tencentWb
        }
        else if (text.compare("支付宝好友").rawValue == 0 ){
            shareType = UMSocialPlatformType.alipaySession
        }
        else if (text.compare("支付宝生活圈").rawValue == 0 ){
            shareType = UMSocialPlatformType.alipaySession
        }
        else if (text.compare("人人网").rawValue == 0 ){
            shareType = UMSocialPlatformType.renren
        }
        
        
        let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
        //        messageObject.text = "社会化组件UShare将各大社交平台接入您的应用，快速武装App"//分享的文本
        
        var titleStr : String?
        var imageUrl : String?
        
        if let sourceAvatar = newTopic?.source_avatar {
            imageUrl =  sourceAvatar
            titleStr = newTopic?.source
        }
        
        if let mediaInfo = newTopic?.media_info {
            imageUrl =  mediaInfo.avatar_url!
            titleStr = mediaInfo.name
        }
        
        //1.分享图片
        //        let shareObject:UMShareImageObject = UMShareImageObject.init()
        //        shareObject.title = shareTitle
        //        shareObject.descr = shareContent
        ////        shareObject.thumbImage = UIImage.init(named: "renren_allshare_60x60_")
        //        shareObject.shareImage = shareImageUrl
        //        messageObject.shareObject = shareObject;
        
        //2.分享分享网页
        let shareObject:UMShareWebpageObject = UMShareWebpageObject.init()
        shareObject.title = titleStr
        shareObject.descr = newTopic!.title! as String
        shareObject.thumbImage = imageUrl
        shareObject.webpageUrl = newTopic!.url!
        
        messageObject.shareObject = shareObject;
        
        
        if UMSocialManager.default().isInstall(shareType!){
            UMSocialManager.default().share(to: shareType!, messageObject: messageObject, currentViewController: nil, completion: { (shareResponse, error) -> Void in
                if error != nil {
                    print("Share Fail with error ：%@", error ?? "没有错")
                    SVProgressHUD.showError(withStatus: "取消分享")
                }else{
                    SVProgressHUD.showSuccess(withStatus: "分享成功")
                }
            })
        }else{
            SVProgressHUD.showError(withStatus: "程序未安装,无法分享!")
        }
        
    }
    
    //发送邮箱分享
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        //设置邮件地址、主题及正文
        mailComposeVC.setToRecipients(["249606659@qq.com"])
        mailComposeVC.setSubject("测试一下")
        mailComposeVC.setMessageBody("<邮件正文>", isHTML: false)
        
        return mailComposeVC
        
    }
    //没有设置过邮件的提示
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert = UIAlertController(title: "无法发送邮件", message: "您的设备尚未设置邮箱，请在“邮件”应用中设置后再尝试发送。", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "确定", style: .default) { _ in })
        UIApplication.shared.keyWindow?.rootViewController?.present(sendMailErrorAlert, animated: true){}
        
    }
    //代理的回调
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("取消发送")
        case MFMailComposeResult.sent.rawValue:
            print("发送成功")
        default:
            break
        }
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    //通过 airdrop 分享一张 图片(转url)
    func fileToURL(fileName : String) -> URL {
        
        let fileComponents = fileName.components(separatedBy: ".")
        
        let filePath = Bundle.main.path(forResource: fileComponents.first, ofType: fileComponents[1])
        
        return URL(fileURLWithPath: filePath!)
        
    }
    
}


