//
//  HomeViewController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import SnapKit


class HomeViewController: UIViewController {

    // 当前选中的 titleLabel 的 上一个 titleLabel
    var oldIndex: Int = 0
    /// 首页顶部标题
    var homeTitles = [HomeTopTitles]()
    ///下面推荐的
    var recommendTopics = [HomeTopTitles]()
    
    var headerView = HeaderSearchView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        //添加头部搜索
        addHeaderSearchView()
        
        setupUI()
        
        // 有多少条文章更新
        showRefreshHeaderSearchViewTitle()
        
        //处理滚动标题的回调
        homeTitleViewCallback()
        
        /// 获取推荐标题内容
        if NSKeyedUnarchiver.unarchiveObject(withFile:kRecommendTopicsPath) == nil {
           
            NetworkRequest.shareNetworkRequest.loadRecommendTopic { [weak self] (topics) in
                
                self!.recommendTopics = topics
                //归档频道推荐
                self?.archiveTitles(kRecommendTopicsPath,topics)
            }
        }
        
      //隐藏导航栏
       fd_prefersNavigationBarHidden = true
        
        let mode = UserDefaults.standard.object(forKey: "networkMode")
        
        if mode == nil {
            UserDefaults.standard.set("最佳效果（下载大图）", forKey: "networkMode")
            UserDefaults.standard.synchronize()
        }
        
        let fontSize = UserDefaults.standard.object(forKey: "fontSize")
        
        if fontSize == nil {
            UserDefaults.standard.set("18", forKey: "fontSize")
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        if let model1 = model {
            
            let isNight = model1 as! Bool
            titleView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            titleView.rightButton.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            titleView.rightLine.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
            titleView.bottomLine.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
            titleView.rightButton.setImage(UIImage(named:isNight ? "add_channel_titlbar_night_20x20_" : "add_channel_titlbar_16x16_"), for: .normal)
            contentScrollView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            view.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
        }else{
            
            UserDefaults.standard.set(false, forKey: userChangedModel)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    fileprivate func setupUI() {
        
        view.addSubview(titleView)
        
        titleView.snp.makeConstraints({ (make) in
            make.top.equalTo(64)
            make.left.right.equalTo(0)
            make.height.equalTo(40)
        })
        
        view.addSubview(contentScrollView)
        
        // 添加监听 刷新搜索的文字
        NotificationCenter.default.addObserver(self, selector: #selector(showRefreshHeaderSearchViewTitle), name: NSNotification.Name(rawValue: ZZRefreshSearchTitleNotification), object: nil)
    }
    //添加头部搜索
    func addHeaderSearchView() {
        
        headerView = HeaderSearchView(frame: CGRect(x: 0, y: 0, width: view.width, height: 64))
        
        self.view.addSubview(headerView)
        
        headerView.headerSearchViewClickClosure { [weak self] in

            let searchViewController = SearchContentViewController()
            
            let nav = MainNavigationController(rootViewController: searchViewController)
            
            self?.present(nav, animated: false, completion: nil)
        }
    }
    
    //处理滚动标题的回调
    fileprivate func homeTitleViewCallback() {
     
        if NSKeyedUnarchiver.unarchiveObject(withFile:kTopTitlePath) != nil {
            ///解档标题
           let  topTitles = NSKeyedUnarchiver.unarchiveObject(withFile:kTopTitlePath) as? [HomeTopTitles]
           
            self.homeTitles = topTitles!
            //添加内容控制器
            for topTitle in topTitles! {
                
                let topicVC = HomeTopicViewController()
                
                topicVC.topTitle = topTitle
                
                self.addChildViewController(topicVC)
                
            }
            self.scrollViewDidEndScrollingAnimation(self.contentScrollView)
            
            self.contentScrollView.contentSize = CGSize(width: Screen_Width * CGFloat((topTitles?.count)!), height: Screen_Height - 104 - 49)
        }else{
            //返回标题的数量
            titleView.titleArrayClosure { [weak self](titleArray) in
                
                self?.homeTitles = titleArray
                
                //归档标题数
                self?.archiveTitles(kTopTitlePath,titleArray)
                //添加内容控制器
                for topTitle in titleArray {
                    
                    let topicVC = HomeTopicViewController()
                    
                    topicVC.topTitle = topTitle
                    
                    self!.addChildViewController(topicVC)
                    
                }
                self!.scrollViewDidEndScrollingAnimation(self!.contentScrollView)
                
                self?.contentScrollView.contentSize = CGSize(width: Screen_Width * CGFloat(titleArray.count), height: Screen_Height - 104 - 49)
            }

        }
        
        
        //点击添加按钮
        titleView.addButtonClickClosure { [weak self] in
            let addTopic = AddTopicViewController()
            addTopic.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            //点击 我的频道 回调
            addTopic.didSelectedMyTipicClosure({ [weak self](itemLabel , topics) in
               
                self!.titleView.adjustTitleOffSetToCurrentIndex(itemLabel.tag, oldIndex:(self?.oldIndex)!)
                self?.oldIndex = itemLabel.tag
                var offset = self!.contentScrollView.contentOffset
                offset.x = CGFloat(itemLabel.tag) * self!.contentScrollView.width
                self!.contentScrollView.setContentOffset(offset, animated: true)
            })
            
            self!.present(addTopic, animated: false, completion: nil)
        }
        
        // 点击了哪一个 titleLabel，然后 scrolleView 进行相应的偏移
        titleView.didSelectTitleLableClosure { [weak self] (titleLabel) in
            
            self!.titleView.adjustTitleOffSetToCurrentIndex(titleLabel.tag, oldIndex: self!.oldIndex)
            self!.oldIndex = titleLabel.tag
            var offset = self!.contentScrollView.contentOffset
            offset.x = CGFloat(titleLabel.tag) * self!.contentScrollView.width
            self!.contentScrollView.setContentOffset(offset, animated: true)
        }
    }
    
    //每次刷新上面显示的标题
    fileprivate lazy var tipView :TipView = {
       
        let tipView = TipView()
        
        tipView.frame = CGRect(x: 0, y: 104, width: Screen_Width, height: 35)
        
        return tipView
    }()
    
    // 顶部标题
    fileprivate lazy var titleView: TitleScrollView = {
        let titleView = TitleScrollView()
        
        return titleView
    }()
    
    /// 滚动视图
    fileprivate lazy var contentScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.frame = CGRect(x: 0, y: 104, width: Screen_Width , height: Screen_Height - 104 - 49)
      
        scrollView.isPagingEnabled = true
        
        scrollView.delegate = self
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    // 刷新有多少条文章更新
    @objc fileprivate func showRefreshHeaderSearchViewTitle() {
        
        NetworkRequest.shareNetworkRequest.loadSearchBarTitle { (searchtitle) in
            
            self.headerView.searchLabel.text = searchtitle
        }
        
    }
    
    
    /// 归档标题数据
    fileprivate func archiveTitles(_ archiveName: String , _ titles: [HomeTopTitles]) {

        // 归档
        NSKeyedArchiver.archiveRootObject(titles, toFile: archiveName)
    }
 
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 当前索引
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        // 取出子控制器
        let vc = childViewControllers[index]
        vc.view.x = scrollView.contentOffset.x
        vc.view.y = 0
        vc.view.height = scrollView.height
        scrollView.addSubview(vc.view)
    }
    
    // scrollView 刚开始滑动时
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 当前索引
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        // 记录刚开始拖拽是的 index
        self.oldIndex = index
    }
    
    // scrollView 结束滑动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
        // 当前索引
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        // 与刚开始拖拽时的 index 进行比较
        // 检查是否需要改变 label 的位置
        titleView.adjustTitleOffSetToCurrentIndex(index, oldIndex: self.oldIndex)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}
