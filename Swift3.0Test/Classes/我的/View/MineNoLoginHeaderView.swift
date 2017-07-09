//
//  MineNoLoginHeaderView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import SnapKit

protocol MineNoLoginHeaderViewDelegate: NSObjectProtocol {
    /// 手机号登录按钮点击
    func noLoginHeaderView(_ headerView: MineNoLoginHeaderView, mobileLoginButtonClick: UIButton)
    /// 微信登录按钮点击
    func noLoginHeaderView(_ headerView: MineNoLoginHeaderView, wechatLoginButtonClick: UIButton)
    /// QQ 登录按钮点击
    func noLoginHeaderView(_ headerView: MineNoLoginHeaderView, qqLoginButtonClick: UIButton)
    /// 微博登录按钮点击
    func noLoginHeaderView(_ headerView: MineNoLoginHeaderView, weiboLoginButtonClick: UIButton)
    /// 更多登录方式按钮点击
    func noLoginHeaderView(_ headerView: MineNoLoginHeaderView, moreLoginButtonClick: UIButton)
}

class MineNoLoginHeaderView: UIView {

    weak var delegate: MineNoLoginHeaderViewDelegate?
    
    class func noLoginHeaderView() -> MineNoLoginHeaderView {
        let frame = CGRect(x: 0.0, y: 0.0, width: Screen_Width, height: 260.0)
        return MineNoLoginHeaderView(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        // 添加背景图片
        addSubview(bgImageView)
        // 添加四个按钮
        addSubview(mobileLoginButton)
        addSubview(wechatLoginButton)
        addSubview(qqLoginButton)
        addSubview(weiboLoginButton)
        // 添加更多登录按钮
        addSubview(moreLoginButton)
        // 添加底部 view
        addSubview(bottomView)
        
        // 设置约束
        bgImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(-2 * kMargin)
            make.height.equalTo(kZZMineHeaderImageHeight)
        }
        
        mobileLoginButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.top.equalTo(wechatLoginButton.snp.top)
        }
        
        wechatLoginButton.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.top).offset(70)
            make.size.equalTo(mobileLoginButton.snp.size)
            make.left.equalTo(mobileLoginButton.snp.right).offset(2 * kMargin)
            make.right.equalTo(self.snp.centerX).offset(-kMargin)
        }
        
        qqLoginButton.snp.makeConstraints { (make) in
            make.size.equalTo(wechatLoginButton.snp.size)
            make.top.equalTo(wechatLoginButton.snp.top)
            make.left.equalTo(self.snp.centerX).offset(kMargin)
        }
        
        weiboLoginButton.snp.makeConstraints { (make) in
            make.size.equalTo(qqLoginButton.snp.size)
            make.left.equalTo(qqLoginButton.snp.right).offset(2 * kMargin)
            make.top.equalTo(qqLoginButton.snp.top)
        }
        
        moreLoginButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(CGSize(width: 110, height: 27))
            make.top.equalTo(weiboLoginButton.snp.bottom).offset(2 * kMargin)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(bgImageView.snp.bottom)
        }
    }
    
    /// 手机号登录按钮
    fileprivate lazy var mobileLoginButton: UIButton = {
        let mobileButton = UIButton()
        mobileButton.setImage(UIImage(named: "cellphoneicon_login_profile_78x78_"), for: UIControlState())
        mobileButton.addTarget(self, action: #selector(mobileLoginButtonClick(_:)), for: .touchUpInside)
        return mobileButton
    }()
    
    /// 微信登录按钮
    fileprivate lazy var wechatLoginButton: UIButton = {
        let wechatLoginButton = UIButton()
        wechatLoginButton.setImage(UIImage(named: "weixinicon_login_profile_78x78_"), for: UIControlState())
        wechatLoginButton.addTarget(self, action: #selector(wechatLoginButtonClick(_:)), for: .touchUpInside)
        return wechatLoginButton
    }()
    
    /// QQ 登录按钮
    fileprivate lazy var qqLoginButton: UIButton = {
        let qqLoginButton = UIButton()
        qqLoginButton.setImage(UIImage(named: "qqicon_login_profile_78x78_"), for: UIControlState())
        qqLoginButton.addTarget(self, action: #selector(qqLoginButtonClick(_:)), for: .touchUpInside)
        return qqLoginButton
    }()
    
    /// 微博登录按钮
    fileprivate lazy var weiboLoginButton: UIButton = {
        let weiboLoginButton = UIButton()
        weiboLoginButton.setImage(UIImage(named: "sinaicon_login_profile_78x78_"), for: UIControlState())
        weiboLoginButton.addTarget(self, action: #selector(weiboLoginButtonClick(_:)), for: .touchUpInside)
        return weiboLoginButton
    }()
    
    /// 懒加载，创建背景图片
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "wallpaper_profile")
        return bgImageView
    }()
    
    /// 创建 更多登录方式按钮
    fileprivate lazy var moreLoginButton: UIButton = {
        let moreLoginButton = UIButton()
        moreLoginButton.setTitle(" 更多登录方式 >", for: UIControlState())
        moreLoginButton.setTitleColor(UIColor.white, for: UIControlState())
        moreLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        moreLoginButton.backgroundColor = ZZColor(170, g: 170, b: 170, a: 0.6)
        moreLoginButton.layer.cornerRadius = 15
        moreLoginButton.layer.masksToBounds = true
        moreLoginButton.addTarget(self, action: #selector(moreLoginButtonClick(_:)), for: .touchUpInside)
        return moreLoginButton
    }()
    
    /// 懒加载，创建底部白色 view
    lazy var bottomView: MineHeaderBottomView = {
        let bottomView = MineHeaderBottomView()
        return bottomView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 手机号登录按钮点击
    func mobileLoginButtonClick(_ button: UIButton) {
        delegate?.noLoginHeaderView(self, mobileLoginButtonClick: button)
    }
    
    /// 微信登录按钮点击
    func wechatLoginButtonClick(_ button: UIButton) {
        delegate?.noLoginHeaderView(self, wechatLoginButtonClick: button)
    }
    
    /// QQ 登录按钮点击
    func qqLoginButtonClick(_ button: UIButton) {
        delegate?.noLoginHeaderView(self, qqLoginButtonClick: button)
    }
    
    /// 微博登录按钮点击
    func weiboLoginButtonClick(_ button: UIButton) {
        delegate?.noLoginHeaderView(self, weiboLoginButtonClick: button)
    }
    
    /// 更多登录方式按钮点击
    func moreLoginButtonClick(_ button: UIButton) {
        delegate?.noLoginHeaderView(self, moreLoginButtonClick: button)
    }
}
