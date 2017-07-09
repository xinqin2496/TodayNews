//
//  CellPhotoContainer.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/23.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class CellPhotoContainer: UIView {

    /// 缩略图URL
    var picUrlArray = [String]()
    
    //原图url
    var picOriArray = [String]()
    
    //宽度
    var frameWidth: CGFloat?{
        didSet{
            
        }
    }
    var imageViewClick : ((_ imageView : UIImageView ,_ picOriArray : [String] ) -> ())?
    
    //图片的个数
    var imageViewsArray = [UIImageView]()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
  
    //绘制 9个 imageView
    func setupUI()  {
        
        let tempArr = NSMutableArray()
        
        for i in 0..<9 {
            let imageView = UIImageView()
            imageView.backgroundColor = ZZGlobalColor()
            addSubview(imageView)
            imageView.isUserInteractionEnabled = true
            imageView.tag = i;
            //添加点击手势
            let tap  = UITapGestureRecognizer(target: self, action: #selector(tapImageView(_ :)))
            imageView.addGestureRecognizer(tap)
            tempArr .add(imageView)
        }
        imageViewsArray = tempArr as! [UIImageView]
        
    }

    
    func setupPicUrlArray(_ picUrlArray : Array<String>) -> CGFloat {
        
        let reachability = UserDefaults.standard.object(forKey: "reachability") as! String
        let networkMode = UserDefaults.standard.object(forKey: "networkMode") as! String
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        
        for i in (picUrlArray.count)..<imageViewsArray.count {
            let imageView = imageViewsArray[i]
            imageView.isHidden = true
        }
        if picUrlArray.count == 0 {
            return 0
        }
        
        let itemW = itemWidthForPicPathArray(picUrlArray)
        let itemH = itemHeightForPicPathArray(picUrlArray)

        let perRowItemCount = perRowItemCountForPicPathArray(picUrlArray)
        let margin :CGFloat = 5.0
        
        for i in 0..<picUrlArray.count {
            
            let columnIndex = i % perRowItemCount
            let rowIndex = i / perRowItemCount
            let imageView = imageViewsArray[i]
            imageView.backgroundColor = ZZGlobalColor()
//            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.isHidden = false
            if let model1 =  model {
                let isNight = model1 as! Bool
                
                imageView.backgroundColor = isNight ? UIColor.gray :ZZGlobalColor()
            }
            if !(reachability.compare("WWAN").rawValue  == 0 && networkMode.compare("极省流量（不下载图）").rawValue == 0) {
                
                imageView.kf.setImage(with: URL(string: picUrlArray[i]), placeholder: UIImage(named:""), options:nil, progressBlock: nil, completionHandler: { (image, error, CacheType, imageUrl) in
                    if (image != nil) {
                        if (image?.size.width)! < itemW || (image?.size.height)! < itemH {
                            imageView.contentMode = .scaleAspectFill
                        }
                    }
                })
            }
            
           
            
          imageView.frame = CGRect(x:CGFloat(columnIndex) * (CGFloat(itemW) + CGFloat(margin)), y:CGFloat(rowIndex) * (CGFloat(itemH) + CGFloat(margin)),  width:itemW,  height: itemH)
            
        }
        
        
        let columnCount = Int(ceilf(Float(picUrlArray.count * 1 / perRowItemCount)))
        let h = CGFloat(CGFloat(columnCount) * itemH + CGFloat((columnCount - 1)) * margin)
        
        return h;
    }
    func itemWidthForPicPathArray(_ array : Array<String>) -> CGFloat {
        if array.count == 1 {
            return self.frameWidth!
        }
        else{
            return (self.frameWidth! - 10) / 3
        }
    }
    func itemHeightForPicPathArray(_ array : Array<String>) -> CGFloat {
        if array.count == 1 {
            return 205
        }else{
            return (self.frameWidth! - 10) / 3
        }
    }
   
    func perRowItemCountForPicPathArray(_ array : Array<String>) -> Int {
        if array.count < 3 {
            return array.count
        } else if array.count == 4 {
            return 2
        } else {
            return 3
        }

    }
    
    
    /// MARK: 点击方法
   @objc  fileprivate func tapImageView(_ tap: UITapGestureRecognizer )  {
        
        let imageView = tap.view as! UIImageView;
        
        imageViewClick!(imageView,picOriArray)
    
    }
    
    //点击图片
    func picImageViewClosure(_ closure:@escaping (_ picImageVeiw : UIImageView , _ picOriArray : [String] ) -> ()) {
        
        imageViewClick = closure
    }
    
}
