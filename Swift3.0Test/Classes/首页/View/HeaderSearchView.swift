//
//  HeaderSearchView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class HeaderSearchView: UIView {

    var searchLabel = UILabel()
    
    //点击搜索按钮
    var headerSearchViewClick : (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ZZGlobalRedColor()
        
        setupNaviView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupNaviView() {
        
        let titleLb = UILabel()
        
        titleLb.text = "今日头条"
        
        titleLb.textColor = UIColor.white
        
        titleLb.textAlignment = .center
        
        titleLb.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.addSubview(titleLb)
        
        titleLb.snp.makeConstraints { (make) in
            
            make.top.equalTo(27)
            
            make.left.equalTo(10)
            
            make.height.equalTo(30)
            
            make.width.equalTo(100)
        }
        
        let searchView = UIView()
        
        searchView.backgroundColor = UIColor.white
        
        self.addSubview(searchView)
        
        searchView.snp.makeConstraints { (make) in
            
            make.left.equalTo(titleLb.snp.right).offset(10)
            
            make.top.equalTo(27)
            
            make.right.equalTo(-10)
            
            make.bottom.equalTo(-7)
        }
        searchView.clipsToBounds = true
        
        searchView.layer.masksToBounds = true
        
        searchView.layer.cornerRadius = 5
        
        let imageView = UIImageView(image: UIImage(named: "search_24x24_"))
        
        searchView .addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.width.height.equalTo(20)
            make.top.equalTo(5)
        }
        
        let label = UILabel()
        
        searchLabel = label
//        label.text = "奔跑吧 | 陈翔六点半 | 我们结婚啦 | 人民的名义"
        
        label.textColor = UIColor.gray
        
        label.textAlignment = .left
        
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        searchView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(5)
            make.height.equalTo(20)
            make.top.equalTo(5)
            make.right.equalTo(-10)
        }
        
        let button = UIButton(type: .custom)
        
        searchView .addSubview(button)
        
        button.addTarget(self, action: #selector(searchButtonClick), for: .touchUpInside)
        
        button.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
    }
    
    func searchButtonClick() {
        
        headerSearchViewClick!()
    }

    func headerSearchViewClickClosure(_ closure: @escaping () -> ()) {
    
         headerSearchViewClick = closure
    }

}
