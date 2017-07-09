//
//  SuggestionCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/17.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

let SugCollectionCellID = "SugCollectionCell"


class SuggestionCell: UITableViewCell ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var collectionView : UICollectionView?
    
    var maxColsPerRow :Int?
    
    var margin :CGFloat?
    
    var selectSuggestionItem : ((_ itemModel : WeatherIndexesModel) -> ())?
    
    /// 存放生活指数的数组
    fileprivate var indexs :[WeatherIndexesModel]?

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = ZZWeatherBGColor()
        
        maxColsPerRow = 4
        
        margin = 1.0
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    func reloadData(_ indexsArray: [WeatherIndexesModel]) {
        indexs = indexsArray
        collectionView?.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    fileprivate func setupUI() {
        let layout = UICollectionViewFlowLayout()
      
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: 220), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView? .register(SugCollectionCell.self, forCellWithReuseIdentifier: SugCollectionCellID)
        addSubview(collectionView!)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.size.width - CGFloat((maxColsPerRow! - 1)) * margin!) / CGFloat(maxColsPerRow!)
        
        return CGSize(width: width, height: width * 0.8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 0.0, bottom: 1.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return indexs!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  sugCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: SugCollectionCellID, for: indexPath) as! SugCollectionCell
        
        let indexModel = indexs?[(indexPath as NSIndexPath).row]
        
        sugCollectionCell.model = indexModel!
        
        
        return sugCollectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        clickSuggestionCellItem((indexs?[(indexPath as NSIndexPath).row])!)
    }
    
    func clickSuggestionCellItem(_ model : WeatherIndexesModel) {
        
        selectSuggestionItem!(model)
    }
    /// 举报按钮点击回调
    func didSelectedSuggItemClosure(_ closure:@escaping (_ model: WeatherIndexesModel)->())  {
        
        selectSuggestionItem = closure
    }
    


}

