//
//  TitleScrollView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class TitleScrollView: UIView {

    //存放标题模型的数组
    var titles = [HomeTopTitles]()
    
    //存放标题 label 数组
    var labels = [TitleLabels]()

    //存放 label 的宽度
   fileprivate var labelWidths = [CGFloat]()
    
    //点击右边的 加号 按钮 回调
    var addBtnClickClosure : (() -> ())?
    
    // 点击 label 的回调
    var didSelectTitleLabel :((_ titleLabel : TitleLabels) -> ())?
    
    //向外界传递 titles 数组
    var titlesClosure :((_ titleArray: [HomeTopTitles]) -> ())?
    
    //记录当前选中的下标
    fileprivate var currentIndex = 0
    
    //记录上一个下标
    fileprivate var oldIndex = 0
  
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        if NSKeyedUnarchiver.unarchiveObject(withFile:kTopTitlePath) != nil {
            ///解档标题
            let  topTitles = NSKeyedUnarchiver.unarchiveObject(withFile:kTopTitlePath) as? [HomeTopTitles]
            
            self.titles = topTitles!
            
            setupUI()

        }else{
            //获取首页顶部标题数据 [weak self] 解决循环强应用
            NetworkRequest.shareNetworkRequest.loadHomeTitlesData { [weak self] (topTitles) in
                
                //创建第一条 推荐
                let dict = ["category":"__all__","name":"推荐"]
                
                let recommend = HomeTopTitles(dict: dict as [String : AnyObject])
                
                self?.titles.append(recommend)
                
                //把获取到的 title 数组 添加进去
                
                self?.titles += topTitles
                
                //绘制界面
                self?.setupUI()
            }
        }
        
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置 UI
   fileprivate  func setupUI() {
    
    //添加滚动视图
    addSubview(scrollView)
    
    //添加按钮
    addSubview(rightButton)
    
    addSubview(rightLine)
    addSubview(bottomLine)
    
    scrollView.snp.makeConstraints({ (make) in
        make.left.top.bottom.equalTo(0)
        make.right.equalTo(-45)
    })
    
    rightButton.snp.makeConstraints({ (make) in
        make.right.top.bottom.equalTo(0)
        make.width.equalTo(45)
    })
    
    
    bottomLine.snp.makeConstraints { (make) in
        make.left.bottom.right.equalTo(0)
        make.height.equalTo(1)
    }
    
    
    
    rightLine.snp.makeConstraints { (make) in
        make.right.equalTo(rightButton.snp.left)
        make.top.equalTo(5)
        make.width.equalTo(1)
        make.height.equalTo(30)
    }
    
    //添加label
    setupTitlesLable()
    
    // 设置 label 的位置
    setupLabelsPosition()
    
    // 保存 titles 数组
    titlesClosure?(titles)
    
    
    }
    
    /// 暴露给外界，告知外界点击了哪一个 titleLabel
    func didSelectTitleLableClosure(_ closure:@escaping (_ titleLabel: TitleLabels)->()) {
        didSelectTitleLabel = closure
    }
    
    /// 暴露给外界，向外界传递 topic 数组
    func titleArrayClosure(_ closure: @escaping (_ titleArray: [HomeTopTitles])->()) {
        titlesClosure = closure
    }

    ///线
     lazy var rightLine : UIView = {
        
        let line = UIView()
        
        line.backgroundColor = ZZGlobalColor()
        
        return line
    }()
    lazy var bottomLine : UIView = {
        
        let line = UIView()
        
        line.backgroundColor = ZZGlobalColor()
        
        return line
    }()
    
    //lazy  方法
    //滚动视图
    fileprivate lazy var scrollView :UIScrollView = {
        
        let scrollView = UIScrollView()
       
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    //右边按钮
    lazy var rightButton :UIButton = {
        
        let button = UIButton()
        
        button.backgroundColor = UIColor.white
        
        button.setImage(UIImage(named: "add_channel_titlbar_16x16_"), for:UIControlState())
        
        button.setTitleColor(UIColor.white, for: UIControlState())
        
        button.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        
        return button
        
    }()
    
    //按钮点击方法
    func addBtnClick() {
        
        addBtnClickClosure?()
    }
    
    //添加闭包按钮
    func addButtonClickClosure(_ closure: @escaping () -> ()) {
        
        addBtnClickClosure = closure
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension TitleScrollView {
    
    /// 添加 label
    fileprivate func setupTitlesLable() {
        
        for (index, topic) in titles.enumerated() {
            let label = TitleLabels()
            label.text = topic.name
            label.tag = index
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabelOnClick(_:)))
            label.addGestureRecognizer(tap)
            label.font = UIFont.systemFont(ofSize: 17)
            label.sizeToFit()
            label.width += kMargin
            labels.append(label)
            labelWidths.append(label.width)
            scrollView.addSubview(label)
        }
        let currentLabel = labels[currentIndex]
        currentLabel.textColor = ZZGlobalRedColor()
        currentLabel.currentScale = 1.1
    }

    /// 设置 label 的位置
    fileprivate func setupLabelsPosition() {
        var titleX: CGFloat = 0.0
        let titleY: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleH = self.height
        
        for (index, label) in labels.enumerated() {
            titleW = labelWidths[index]
            titleX = kMargin
            if index != 0 {
                let lastLabel = labels[index - 1]
                titleX = lastLabel.frame.maxX + kMargin
            }
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        }
        /// 设置 contentSize
        if let lastLabel = labels.last {
            scrollView.contentSize = CGSize(width: lastLabel.frame.maxX, height: 0)
        }
    }
    
    /// 标题点击的方法
    func titleLabelOnClick(_ tap: UITapGestureRecognizer) {
        guard let  currentLabel = tap.view as? TitleLabels else {
            return
        }
        oldIndex = currentIndex
        currentIndex = currentLabel.tag
        let oldLabel = labels[oldIndex]
        oldLabel.textColor = UIColor.black
        oldLabel.currentScale = 1.0
        currentLabel.textColor = ZZGlobalRedColor()
        currentLabel.currentScale = 1.1
        // 改变 label 的位置
        adjustTitleOffSetToCurrentIndex(currentIndex, oldIndex: oldIndex)
        didSelectTitleLabel?(currentLabel)
    }
    
    /// 当点击标题的时候，检查是否需要改变 label 的位置
    func adjustTitleOffSetToCurrentIndex(_ currentIndex: Int, oldIndex: Int) {
        guard oldIndex != currentIndex else {
            return
        }
        // 重新设置 label 的状态
        let oldLabel = labels[oldIndex]
        oldLabel.textColor =  UIColor.black
        oldLabel.currentScale = 1.0
        
        let currentLabel = labels[currentIndex]
        currentLabel.currentScale = 1.1
        currentLabel.textColor = ZZGlobalRedColor()
        
        // 当前偏移量
        var offsetX = currentLabel.centerX - Screen_Width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        // 最大偏移量
        var maxOffsetX = scrollView.contentSize.width - (Screen_Width - rightButton.width)
        
        if maxOffsetX < 0 {
            maxOffsetX = 0
        }
        
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
   
    /// 重写 frame
    override var frame: CGRect {
        didSet {
            let newFrame = CGRect(x: 0, y: 0, width: Screen_Width, height: 40)
            super.frame = newFrame
        }
    }

}

class TitleLabels: UILabel {
    //记录当前 label 的缩放比例
    var currentScale : CGFloat = 1.0 {
        
        didSet {
            transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
        }
    }
    
}
