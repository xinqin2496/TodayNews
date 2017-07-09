//
//  MineHeaderView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import SnapKit

class MineHeaderView: UIView {
    
    /// 头像按钮点击的回调
    var headerViewClosure: ((_ iconButton: UIButton) -> ())?
    
    class func headerView() -> MineHeaderView {
        let frame = CGRect(x: 0, y: 0, width: Screen_Width, height: 260)
        return MineHeaderView(frame: frame)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置 UI
        setupUI()
    
    }
    
    /// 设置 UI
    fileprivate func setupUI() {
        // 添加背景图片
        addSubview(bgImageView)
        // 添加头像按钮
        addSubview(headPhotoButton)
        // 添加底部 view
        addSubview(bottomView)
        
        // 设置约束
        bgImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(-2 * kMargin)
            make.height.equalTo(kZZMineHeaderImageHeight)
        }
        
        headPhotoButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(0)
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.top.equalTo(bgImageView.snp.top).offset(64)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(bgImageView.snp.bottom)
        }
    }
    
    /// 懒加载，创建背景图片
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "hrscy")
        return bgImageView
    }()
    
    /// 懒加载，创建头像按钮
    lazy var headPhotoButton: ShareVerticalButton = {
        let headPhotoButton = ShareVerticalButton()
        headPhotoButton.addTarget(self, action: #selector(headPhotoBtnClick(_:)), for: .touchUpInside)
        headPhotoButton.setTitle("hrscy", for: UIControlState())
        headPhotoButton.setImage(UIImage(named: "hrscy"), for: UIControlState())
        return headPhotoButton
    }()
    
    /// 懒加载，创建底部白色 view
    lazy var bottomView: MineHeaderBottomView = {
        let bottomView = MineHeaderBottomView()
        return bottomView
    }()
    
    /// 头像按钮点击
    func headPhotoBtnClick(_ button: ShareVerticalButton) {
        headerViewClosure?(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
