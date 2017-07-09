//
//  AddTopicViewController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

private let TopicCellIdentifier = "TopicCellIdentifier"
private let TopicReusableIdentifier = "TopicReusableIdentifier"


//点击加号弹出的频道页面
class AddTopicViewController: UIViewController,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {

    var switchoverCallback: ((_ selectedArr: [String], _ recommendArr: [String], _ index: Int) -> ())?
    
    var line = UIView()
    
    var collectionView :UICollectionView?
    
    // 我的频道
    var myTopics = [HomeTopTitles]()
    // 推荐频道
    var recommendTopics = [HomeTopTitles]()
    
    var isHiddenDelete  = Bool()
    
    var indexPath: IndexPath?
    
    var targetIndexPath: IndexPath?
    
    // 点击 我的频道 的回调
    var didSelectMineItem :((_ itemLabel : TitleLabels , _ topics : HomeTopTitles) -> ())?
    
    private lazy var dragingItem: TopicCell = {
        
        let cell = TopicCell(frame: CGRect(x: 0, y: 0, width: (self.view.width - 70) / 4, height: 35))
        
        cell.isHidden = true
        
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ZZGlobalColor()
        
        isHiddenDelete = true
        
        myTopics = NSKeyedUnarchiver.unarchiveObject(withFile:kTopTitlePath) as! [HomeTopTitles]
   
        recommendTopics = NSKeyedUnarchiver.unarchiveObject(withFile:kRecommendTopicsPath) as! [HomeTopTitles]
        
        setupUI()
        
        setupCollectionView()
        
    
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        if let model1 = model {
            let isNight = model1 as! Bool
            view.backgroundColor = isNight ? UIColor.darkGray : ZZGlobalColor()
            collectionView?.backgroundColor = isNight ? UIColor.darkGray : ZZGlobalColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func setupUI() {
        
        let model = UserDefaults.standard.object(forKey: userChangedModel)
       
        
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 64))
        
        if let model1 = model {
            let isNight = model1 as! Bool
            topView.backgroundColor = isNight ? UIColor.darkGray : ZZGlobalColor()
        }
        
        
        self.view .addSubview(topView)
        
        let backBtn = UIButton(type: .custom)
        
        backBtn.setImage(UIImage(named: "add_channels_close_20x20_"), for: .normal)
        
        backBtn.addTarget(self, action: #selector(closeBBItemClick), for: .touchUpInside)
        
        topView.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            
            make.right.equalTo(0)
            
            make.top.equalTo(27)
            
            make.width.height.equalTo(30)
        }
        
        let lineView = UIView()
        
        lineView.backgroundColor = UIColor.lightGray
        
        lineView.alpha = 0
        
        topView.addSubview(lineView)
        
        self.line = lineView
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(1)
        }
    }
    ///将要消失的时候保存数据
    override func viewWillDisappear(_ animated: Bool) {
        
        ///归档 我的
        self.archiveTitles(kTopTitlePath,myTopics)
        
        ///归档 推荐
        self.archiveTitles(kRecommendTopicsPath,recommendTopics)

    }
    /// 归档标题数据
    fileprivate func archiveTitles(_ archiveName: String , _ titles: [HomeTopTitles]) {
        
        // 归档
        NSKeyedArchiver.archiveRootObject(titles, toFile: archiveName)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    ///返回
    func closeBBItemClick() {
        dismiss(animated: false, completion: nil)
    }
    
    ///添加 CollectionView
    func setupCollectionView()  {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: (view.width - 70) / 4 , height: 35)
        
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 5
        
        layout.minimumLineSpacing = 5
        
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        
        collectionView = UICollectionView.init(frame:  CGRect(x: 20, y: 64, width: view.width - 40, height: view.height - 84), collectionViewLayout: layout)
        
//        collectionView?.backgroundColor = ZZGlobalColor()
        
        collectionView?.delegate = self
        
        collectionView?.dataSource = self;
        
        collectionView?.showsVerticalScrollIndicator = false
        
        collectionView?.showsHorizontalScrollIndicator = false
        
        //注册一个cell
        collectionView!.register(TopicCell.self, forCellWithReuseIdentifier:TopicCellIdentifier)
        
        collectionView?.register(TopicReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TopicReusableIdentifier)
        
        self.view.addSubview(collectionView!)
        //添加一个可以移动的 item
        collectionView?.addSubview(dragingItem)
        
        //添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        
        collectionView!.addGestureRecognizer(longPress)
        
    }
    //UICollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return myTopics.count
        }
        
        return recommendTopics.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCellIdentifier, for: indexPath) as! TopicCell

        let model = UserDefaults.standard.object(forKey: userChangedModel)
        if let model1 = model {
            let isNight = model1 as! Bool
            cell.contentView.backgroundColor = isNight ? UIColor.lightGray : UIColor.white
            cell.backgroundColor = isNight ? UIColor.lightGray : UIColor.white
            cell.titleLb.textColor  = isNight ? UIColor.gray :  UIColor.black
        }
        
        if indexPath.section == 0 {
            
            let topic = myTopics[(indexPath as NSIndexPath).item]
           
            cell.titleLb.text = topic.name
            
            cell.titleLb.tag = indexPath.item
            
            cell.deleteButton.isHidden = isHiddenDelete
            
            //cell上删除 按钮的 block
            cell.deleteButtonClickClosure({ [weak self](sender) in
                let btn = sender
                //获取 cell
                let cell = self?.superCollectionViewCell(of: btn)
                
                //获取 cell 的下标
                let indexPath = collectionView.indexPath(for: cell!)
                
                //操作数组数据
                let recommend = self?.myTopics[(indexPath! as NSIndexPath).item]
                
                self?.myTopics.remove(at: (indexPath?.row)!)
                
                self?.recommendTopics.insert(recommend!, at: 0)
                
                collectionView.reloadData()
            })
            
        }else{
            let recommend = recommendTopics[(indexPath as NSIndexPath).item]
           
            cell.titleLb.text = recommend.name
            
            cell.deleteButton.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
       
        
        if indexPath.section == 0 {
            
            if !isHiddenDelete {
             
                if indexPath.item == 0 {return}
                // 更新数据
                let obj = myTopics[indexPath.item]
                myTopics.remove(at: indexPath.item)
                recommendTopics.insert(obj, at: 0)
                collectionView.moveItem(at: indexPath, to: NSIndexPath(item: 0, section: 1) as IndexPath)
                
            }else{
                
                let cell = collectionView.cellForItem(at: indexPath) as! TopicCell
                let obj = myTopics[indexPath.item]
            
                if cell.titleLb.tag <= 15 {
                  
                   didSelectMineItem!(cell.titleLb ,obj)
                }
                //没有编辑点击返回
                self.dismiss(animated: true, completion: nil)
            }
            
        }else {
            
            let recommend = recommendTopics[(indexPath as NSIndexPath).item]
            
            recommendTopics.remove(at: indexPath.row)
            
            myTopics.append(recommend)
            
            collectionView.reloadData()
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    //section 的header 复用
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        let reusableView = collectionView .dequeueReusableSupplementaryView(ofKind:UICollectionElementKindSectionHeader, withReuseIdentifier: TopicReusableIdentifier, for: indexPath) as! TopicReusableView
        
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        if let model1 = model {
            let isNight = model1 as! Bool
            reusableView.titleLabel.textColor = isNight ? UIColor.gray : UIColor.black
        }
        if indexPath.section == 0 {
            
            reusableView.titleLabel.text = "我的频道"
            
            reusableView.rightButton.isHidden = false
            
            reusableView.rightButton.isSelected = !isHiddenDelete
        
            //点击编辑按钮
            reusableView.didSelectEditButtonClosure({ [weak self](button) in
                
                self?.isHiddenDelete = !button.isSelected
                
                collectionView.reloadData()
            })
            return reusableView
        }
        else{
            
            reusableView.titleLabel.text = "频道推荐"
            
            reusableView.rightButton.isHidden = true
            
            return reusableView
        }
        
        
    }
    //sectionheader 的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.width, height: 40)
    }
    
    //返回button所在的 CollectionViewCell
    func superCollectionViewCell(of: UIButton) -> UICollectionViewCell? {
        
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            
            if let cell = view as? UICollectionViewCell {
                
                return cell
            }
        }
        return nil
    }
    //给CollectionViewCell添加一个长按手势.
    //MARK: - 长按动作
    func longPressGesture(_ tap: UILongPressGestureRecognizer) {
        
        if !isHiddenDelete {
            
            isHiddenDelete = !isHiddenDelete
            collectionView?.reloadData()
            return
        }
        let point = tap.location(in: collectionView)
        
        switch tap.state {
        case UIGestureRecognizerState.began:
            dragBegan(point: point)
        case UIGestureRecognizerState.changed:
            drageChanged(point: point)
        case UIGestureRecognizerState.ended:
            drageEnded(point: point)
        case UIGestureRecognizerState.cancelled:
            drageEnded(point: point)
        default: break
            
        }
        
    }
    //MARK: - 长按开始
    private func dragBegan(point: CGPoint) {
        indexPath = collectionView?.indexPathForItem(at: point)
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0
        {return}
        let item = collectionView?.cellForItem(at: indexPath!) as? TopicCell
        item?.isHidden = true
        dragingItem.isHidden = false
        dragingItem.frame = (item?.frame)!
        dragingItem.titleLb.text = item!.titleLb.text
        
        //放大效果(此处可以根据需求随意修改)
        dragingItem.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    
    //MARK: - 移动过程
    private func drageChanged(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {return}
        dragingItem.center = point
        targetIndexPath = collectionView?.indexPathForItem(at: point)
        if targetIndexPath == nil || (targetIndexPath?.section)! > 0 || indexPath == targetIndexPath || targetIndexPath?.item == 0 {return}
        // 更新数据
        let obj = myTopics[indexPath!.item]
        myTopics.remove(at: indexPath!.row)
        myTopics.insert(obj, at: targetIndexPath!.item)
        //交换位置
        collectionView?.moveItem(at: indexPath!, to: targetIndexPath!)
        //进行记录
        indexPath = targetIndexPath
    }
    
    //MARK: - 长按结束或取消
    private func drageEnded(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {return}
        let endCell = collectionView?.cellForItem(at: indexPath!)
        UIView.animate(withDuration: 0.25, animations: {
            self.dragingItem.transform = CGAffineTransform.identity
            self.dragingItem.center = (endCell?.center)!
        }, completion: {
            (finish) -> () in
            endCell?.isHidden = false
            self.dragingItem.isHidden = true
            self.indexPath = nil
        })
    }
    //滚动时显示line
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsety = scrollView.contentOffset.y
        
        if offsety <= 0 {
            self.line.alpha = 0
        }else{
            self.line.alpha = 1
        }
    }
    
    //
    func didSelectedMyTipicClosure(_ closure: @escaping (_ itemLabel : TitleLabels ,_ topics : HomeTopTitles) -> () ) {
        
        didSelectMineItem = closure
    }

  
}
