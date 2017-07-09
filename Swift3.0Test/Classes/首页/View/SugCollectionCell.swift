//
//  SugCollectionCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/17.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class SugCollectionCell: UICollectionViewCell {
    
    var model : WeatherIndexesModel? {
     
        didSet {
            
            label?.text = model?.valueV2
            
            imageVeiw?.image = UIImage(named: (model?.name)!)
        }
        
    }
    
    var imageVeiw :UIImageView?
    
    var label : UILabel?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   fileprivate func setupUI() {
    
    imageVeiw = UIImageView()
    contentView.addSubview(imageVeiw!)
    imageVeiw?.snp.makeConstraints({ (make) in
        make.center.equalTo(contentView.snp.center).offset(0)

        make.width.height.equalTo(25)
    })
    
    label = UILabel()
    label?.textColor = UIColor.white
    label?.textAlignment = .center
    label?.font = UIFont.systemFont(ofSize: 14)
    label?.adjustsFontSizeToFitWidth = true
    contentView.addSubview(label!)
    label?.snp.makeConstraints({ (make) in
        make.centerX.equalTo(contentView.snp.centerX).offset(0)
//        make.top.equalTo(imageVeiw!.snp.bottom).offset(10)
        make.left.right.equalTo(0)
        make.bottom.equalTo(0)
    })

    
    }
    
}
