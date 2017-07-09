//
//  VideoTopicController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/4.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//


import UIKit
import SnapKit
import AVFoundation

let videoTopicCellID = "VideTopicCell"
/// ![](http://obna9emby.bkt.clouddn.com/news/topicVC.png)
class VideoTopicController: UIViewController,UITableViewDelegate,UITableViewDataSource,VideoTopicCellDelegate {
    
    var lastSelectCell: VideoTopicCell?
    
//    var playView: VideoPlayerView?
    /// 上一次选中 tabBar 的索引
    var lastSelectedIndex = Int()
    
    // 下拉刷新的时间
    fileprivate var pullRefreshTime: TimeInterval?
    // 记录点击的顶部标题
    var videoTitle: VideoTopTitle?
    // 存放新闻主题的数组
    fileprivate var newsTopics = [NewsTopic]()
    
    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupRefresh()
        // 添加监听，监听 tabbar 的点击
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarSelected), name: NSNotification.Name(rawValue: ZZTabBarDidSelectedNotification), object: nil)
        
         view.addSubview(tipView)
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontSize(_:)), name: NSNotification.Name(rawValue: "fontSize"), object: nil)
        ///改变皮肤
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        
        if let model1 =  model {
            self.switchTheSkin(model1 as! Bool)
        }
    }
  
    func changeFontSize(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo as! [String: AnyObject]
        
        let size = userInfo["fontSize"] as! String
        
        for cell in (tableView?.visibleCells)! {
            
            if cell.isKind(of: VideoTopicCell.classForCoder()) {
                let topicCell = cell as! VideoTopicCell
                topicCell.titleLabel.font = UIFont.systemFont(ofSize: size.StringToFloat())
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tabBarSelected() {
        
        //如果是连点 2 次，并且 如果选中的是当前导航控制器，刷新
        if lastSelectedIndex == tabBarController?.selectedIndex {
            if newsTopics.count == 0 {
                return
            }
            tableView.mj_header.beginRefreshing()
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        lastSelectedIndex = tabBarController!.selectedIndex
    }
    
    fileprivate func setupUI() {
        tableView = UITableView(frame:CGRect(x: 0, y: 0, width: Screen_Width , height: Screen_Height - 64 - 49), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        let footView = UIView()
        footView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footView
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.white
        let nib = UINib(nibName: String(describing: VideoTopicCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: videoTopicCellID)
        tableView.rowHeight = 270
        tableView.separatorStyle = .none
    }
    
    /// 添加上拉刷新和下拉刷新
    fileprivate func setupRefresh() {
        pullRefreshTime = Date().timeIntervalSince1970
        // 获取首页不同分类的新闻内容
        NetworkRequest.shareNetworkRequest.loadHomeCategoryNewsFeed(videoTitle!.category!, tableView: tableView) { [weak self] (nowTime, newsTopics,total_number) in
            self!.showRefreshTipView(total_number)
            self!.pullRefreshTime = nowTime
            self!.newsTopics = newsTopics
            self!.tableView.reloadData()
        }
        // 获取更多新闻内容
        
        NetworkRequest.shareNetworkRequest.loadHomeCategoryMoreNewsFeed(videoTitle!.category!, lastRefreshTime: pullRefreshTime!, tableView: tableView) { [weak self] (moreTopics) in
            self?.newsTopics += moreTopics
            self!.tableView.reloadData()
        }
    }
    // 刷新有多少条文章更新
    fileprivate func showRefreshTipView(_ count :Int) {
        self.tipView.isHidden = false
        self.tipView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: 35)
        self.tableView.frame = CGRect(x: 0, y: 35, width: Screen_Width, height: Screen_Height - 64 - 35 - 49)
        
        self.tipView.tipLabel.text = (count == 0) ? "暂无更新，请休息一会儿" : "今日头条推荐引擎有\(count)条刷新"
        ///改变皮肤
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        
        if let model1 =  model {
            let isNight = model1 as! Bool
            
            self.tipView.backgroundColor = isNight ? UIColor.gray : ZZColor(215, g: 233, b: 246, a: 1.0)
        }
        
        //提示的动画
        UIView.animate(withDuration: kAnimationDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions(rawValue:0), animations: {
            //文字的缩放
            self.tipView.tipLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }, completion: { (_) in
            
            self.tipView.tipLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            //2秒后隐藏
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                self.tipView.frame = CGRect(x: 0, y: -35, width: Screen_Width, height: 35)
                self.tipView.isHidden = true
                self.tableView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height - 64 - 49)
                
            })
        })
        
    }
    //每次刷新上面显示的标题
    fileprivate lazy var tipView :TipView = {
        
        let tipView = TipView()
        
        tipView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: 35)
        
        tipView.backgroundColor = UIColor.clear
        
        return tipView
    }()

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - YMVideoTopicCellDelegate

    /// 背景按钮点击
    func videoTopicCellbgImageViewClick(_ videoTopicCell: VideoTopicCell) {
        
        let indexPath = tableView.indexPath(for: videoTopicCell)
        
        let videoDetailVC = HomeDetailViewController()
        videoDetailVC.newTopics = newsTopics[(indexPath! as NSIndexPath).row]
        navigationController?.pushViewController(videoDetailVC, animated: true)
        
    }
    /// 昵称按钮点击
    func videoTopicCell(_ videoTopicCell: VideoTopicCell, nameButtonClick nameButton: UIButton) {
        let indexPath = tableView.indexPath(for: videoTopicCell)
        
        let videoDetailVC = HomeDetailViewController()
        videoDetailVC.newTopics = newsTopics[(indexPath! as NSIndexPath).row]
        navigationController?.pushViewController(videoDetailVC, animated: true)
    }
    ///播放按钮
    func videoTopicCell(_ videoTopicCell: VideoTopicCell, playButtonClick playButton: UIButton) {
        let indexPath = tableView.indexPath(for: videoTopicCell)
        
        let videoDetailVC = HomeDetailViewController()
        videoDetailVC.newTopics = newsTopics[(indexPath! as NSIndexPath).row]
        navigationController?.pushViewController(videoDetailVC, animated: true)
    }
    
    
   
    
    /// 添加动画
    func addAnimation(_ loading: UIImageView) {
        loading.isHidden = false
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 1
        // 绕 z 轴旋转 180°
        animation.toValue = Double.pi * 2.0
        //        animation.toValue = M_PI * 2.0
        animation.isCumulative = true
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        // 如果是在 OC 里，应这样写 animation.repeatCount = HUGE_VALF;
        animation.repeatCount = Float.infinity
        animation.fillMode = kCAFillModeForwards
        loading.layer.add(animation, forKey: animation.keyPath)
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            loading.layer.removeAllAnimations()
            loading.isHidden = true
            //                self.playView!.playButton.isSelected = true
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: videoTopicCellID) as! VideoTopicCell
      
        let videoTipic = newsTopics[(indexPath as NSIndexPath).row]
    
        cell.videoTopic = videoTipic
        cell.selectionStyle = .none
        cell.delegate = self
        let newsTopic = newsTopics[indexPath.row]
        
        /// 更多按钮点击回调
        cell.moreButtonClosure = {
            let shareView = HomeShareView.getView(newsTopic)
            shareView.showShareView()
        }
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        
        if let model1 =  model {
            let isNight = model1 as! Bool
            
            cell.lineView.backgroundColor = isNight ? UIColor.lightGray : ZZGlobalColor()
            cell.contentView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
            cell.backgroundColor = isNight ? UIColor.darkGray :  UIColor.white
            cell.titleLabel?.textColor = isNight ? UIColor.black :  UIColor.white
            cell.countLabel?.textColor = isNight ? UIColor.black :  UIColor.white
            cell.timeLabel?.textColor = isNight ? UIColor.gray :  UIColor.white
            cell.bottomView?.backgroundColor = isNight ? UIColor.gray :  UIColor.white
            
            cell.bgImageView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
            cell.avatarImageView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let videoDetailVC = HomeDetailViewController()
            videoDetailVC.newTopics = newsTopics[(indexPath as NSIndexPath).row]
            navigationController?.pushViewController(videoDetailVC, animated: true)
    }
    
    ///改变皮肤
    func switchTheSkin(_ isNight : Bool) {
        tableView.backgroundColor = isNight ? UIColor.darkGray :  UIColor.white
        view.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
        let cells = tableView.visibleCells
        
        for cell in cells {
            let videoCell = cell as! VideoTopicCell
             videoCell.lineView.backgroundColor = isNight ? UIColor.lightGray : ZZGlobalColor()
            videoCell.contentView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
            videoCell.backgroundColor = isNight ? UIColor.darkGray :  UIColor.white
            videoCell.titleLabel?.textColor = isNight ? UIColor.black :  UIColor.white
            videoCell.countLabel?.textColor = isNight ? UIColor.black :  UIColor.white
            videoCell.timeLabel?.textColor = isNight ? UIColor.gray :  UIColor.white
            videoCell.bottomView?.backgroundColor = isNight ? UIColor.gray :  UIColor.white
           
            videoCell.bgImageView.backgroundColor = isNight ? UIColor.lightGray : ZZGlobalColor()
            videoCell.avatarImageView.backgroundColor = isNight ? UIColor.lightGray : ZZGlobalColor()
        }
        
    }
}
