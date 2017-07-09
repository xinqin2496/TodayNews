//
//  MineHeaderBottomView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import Kingfisher

class MineHeaderBottomView: UIView {
    

    var collectionButtonClosure: ((_ collectionButton: UIButton) -> ())?
   
    var historyButtonClosure: ((_ historyButton: UIButton) -> ())?
   
    var nightButtonClosure: ((_ nightButton: UIButton) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        // 设置三个按钮
        setupUI()
    }
    

    fileprivate func setupUI() {
        
        addSubview(collectionButton)
        
        
        addSubview(historyButton)
        
        addSubview(nightButton)
        
        collectionButton.snp.makeConstraints { (make) in
            
            make.left.top.bottom.equalTo(0)
            make.right.equalTo(historyButton.snp.left).offset(-kMargin)
            make.width.equalTo(historyButton.snp.width)
        }
       
        
        historyButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(nightButton.snp.left).offset(-kMargin)
            make.width.equalTo(nightButton.snp.width)
        }
        
        nightButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(0)
            make.width.equalTo(collectionButton.snp.width)
        }
        
        
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        
        if let changedModel = model {
            
           backgroundColor = changedModel as! Bool ? UIColor.darkGray : UIColor.white
        }
        
    }
    
    /// 懒加载，创建收藏按钮
     lazy var collectionButton: VerticalButton = {
        let collectionButton = VerticalButton()
        
        collectionButton.setTitle("收 藏", for: UIControlState())
        collectionButton.setTitleColor(UIColor.black, for: UIControlState())
        collectionButton.addTarget(self, action: #selector(collectionBtnClick(_:)), for: .touchUpInside)
        collectionButton.setImage(UIImage(named: "favoriteicon_profile_24x24_"), for: UIControlState())
        collectionButton.backgroundColor = UIColor.clear
        collectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return collectionButton
    }()
    
    /// 懒加载，创建夜间按钮
     lazy var historyButton: VerticalButton = {
        let historyButton = VerticalButton()
        historyButton.setTitle("历 史", for: UIControlState())
        historyButton.setTitleColor(UIColor.black, for: UIControlState())
        historyButton.addTarget(self, action: #selector(nightBtnClick(_:)), for: .touchUpInside)
        historyButton.setImage(UIImage(named: "history"), for: UIControlState())
        historyButton.backgroundColor = UIColor.clear
        historyButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return historyButton
    }()
    
    /// 懒加载，创建设置按钮
     lazy var nightButton: VerticalButton = {
        let nightButton = VerticalButton()
        nightButton.setTitle("夜 间", for: UIControlState())
        nightButton.setTitleColor(UIColor.black, for: UIControlState())
        nightButton.setImage(UIImage(named: "nighticon_profile_24x24_"), for: UIControlState())
        nightButton.backgroundColor = UIColor.clear
        nightButton.addTarget(self, action: #selector(settingBtnClick(_:)), for: .touchUpInside)
        nightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return nightButton
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionBtnClick(_ button: VerticalButton) {
        collectionButtonClosure?(button)
    }
    
    func nightBtnClick(_ button: VerticalButton) {
        historyButtonClosure?(button)
    }
    
    func settingBtnClick(_ button: VerticalButton) {
        nightButtonClosure?(button)
    }
}
