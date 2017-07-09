//
//  HeadlinesViewController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/22.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class HeadlinesViewController: UIViewController {

    /// 上一次选中 tabBar 的索引
    var lastSelectedIndex = Int()
    /// 记录点击的 x 按钮的indexPath
    var didIndexPath : IndexPath?
    
    /// 下拉刷新的时间
    fileprivate var pullRefreshTime: TimeInterval?
 
    /// 存放数组
    fileprivate var HeadlinesPics = [HeadlinesModel]()
    /// 缓存cell高度
    
    var heightDict = Dictionary<Int, Dictionary<String, CGFloat>>()
    
    var tableView : UITableView!
    
    var isLoading : Bool?
    
    fileprivate var browser: LLPhotoBrowserViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        isLoading = false
        
        setupUI()
        
        setupRefresh()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            
            if cell.isKind(of: HeadlinesCell.classForCoder()) {
                let topicCell = cell as! HeadlinesCell
                topicCell.labelContent.font = UIFont.systemFont(ofSize: size.StringToFloat())
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // MARK: Dispose of any resources that can be recreated.
    }
    fileprivate func setupUI() {
        
        self.navigationItem.title = "微头条"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"添加好友"), style: .done, target: self, action: #selector(clickAddFriendsItem))
        
        tableView = UITableView(frame:CGRect(x: 0, y: 0, width: Screen_Width , height: Screen_Height - 64 - 49), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        let footView = UIView()
        footView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footView
        
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.white
        
        /// 注册 cell
        tableView.register(HeadlinesCell.self, forCellReuseIdentifier: "HeadlinesCell")
       
        /// 添加监听，监听 tabbar 的点击
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarSelected), name: NSNotification.Name(rawValue: ZZTabBarDidSelectedNotification), object: nil)
        
        view.addSubview(tipView)
    }
    // MARK:每次刷新上面显示的标题
    fileprivate lazy var tipView :TipView = {
        
        let tipView = TipView()
        
        tipView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: 35)
        
        tipView.backgroundColor = UIColor.clear
        
        return tipView
    }()
    
    func tabBarSelected() {
       
        // MARK:如果是连点 2 次，并且 如果选中的是当前导航控制器，刷新
        if lastSelectedIndex == tabBarController?.selectedIndex {
            if HeadlinesPics.count == 0 {
                return
            }
            tableView.mj_header.beginRefreshing()
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        lastSelectedIndex = tabBarController!.selectedIndex
    }
    // MARK: 添加上拉刷新和下拉刷新
    fileprivate func setupRefresh(){
        
        pullRefreshTime = Date().timeIntervalSince1970
        
        
        // MARK:获取首页不同匪类的新闻内容
        
        NetworkRequest.shareNetworkRequest.loadHeadlinesNewsFeed(tableView: tableView) {[weak self] (nowTime, HeadlinesModel, totleNum) in
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: ZZRefreshSearchTitleNotification), object: nil, userInfo: nil)
            
            self!.showRefreshTipView(totleNum)
            self!.pullRefreshTime = nowTime
            self!.HeadlinesPics = HeadlinesModel
            self!.tableView.reloadData()
            
            self!.isLoading = false
            self!.tableView.reloadEmptyDataSet()
        }
        
        // MARK: 获取更多新闻内容
        
        NetworkRequest.shareNetworkRequest.loadHeadlinesMoreNewsFeed(lastRefreshTime: pullRefreshTime!, tableView: tableView) { [weak self] (moreLines) in
            self!.HeadlinesPics += moreLines
            self!.tableView.reloadData()
            self!.isLoading = false
            self!.tableView.reloadEmptyDataSet()
        }
        
    }
    func clickAddFriendsItem() {
        view.makeToast("添加好友")
    }
    // MARK: 展示提示条数
    fileprivate func showRefreshTipView (_ count : Int) {
        self.tipView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: 35)
        self.tableView.frame = CGRect(x: 0, y: 35, width: Screen_Width, height: Screen_Height - 64 - 49)
        
        self.tipView.tipLabel.text = (count == 0) ? "暂无更新，请休息一会儿" : "今日头条推荐引擎有\(count)条刷新"
        // MARK:改变皮肤
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        
        if let model1 =  model {
            let isNight = model1 as! Bool
            
            self.tipView.backgroundColor = isNight ? UIColor.gray : ZZColor(215, g: 233, b: 246, a: 1.0)
        }
        // MARK:提示的动画
        UIView.animate(withDuration: kAnimationDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions(rawValue:0), animations: {
            // MARK:文字的缩放
            self.tipView.tipLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }, completion: { (_) in
            
            self.tipView.tipLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            // MARK:2秒后隐藏
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                self.tipView.frame = CGRect(x: 0, y: -35, width: Screen_Width, height: 35)
                self.tableView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height - 64 - 49)
                
            })
        })

    }

    // Mark: 显示弹出屏蔽新闻内容
    fileprivate func showPopView(_ filterWords: [FilterWord], point: CGPoint) {
        let popVC = PopViewController()
        popVC.filterWords = filterWords
        popVC.closeButtonPoint = point
        //Mark: 不喜欢按钮
        popVC.addButtonClickClosure { [weak self](button) in
            
            self!.HeadlinesPics.remove(at: self!.didIndexPath!.row)
            self!.tableView.deleteRows(at: [self!.didIndexPath!], with: .none)
            self!.showRemoveDataTipViewAnimated()
            self!.tableView.reloadData()
            popVC.dismiss(animated: true, completion: {
                
            })
        }
        /// 设置转场动画的代理
        
        popVC.transitioningDelegate = popViewAnimator
        popViewAnimator.popViewY = point.y
        popViewAnimator.filterWordCount = filterWords.count
        /// 设置转场的样式
        popVC.modalPresentationStyle = .custom
        present(popVC, animated: true, completion: nil)
    }
    
    // MARK: - 转场动画， 一定要定义一个属性来保存自定义转场对象，否则会报错
    fileprivate lazy var popViewAnimator: PopViewAnimator = {
        let popViewAnimator = PopViewAnimator()
        return popViewAnimator
    }()


    fileprivate func showRemoveDataTipViewAnimated() {
        self.tipView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: 35)
        
        self.tipView.tipLabel.text = "我们将为您减少类似微头条的推送"
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
                
            })
        })
    }
    
    
    ///改变皮肤
    func switchTheSkin(_ isNight : Bool) {
        tableView.backgroundColor = isNight ? UIColor.darkGray :  UIColor.white
        view.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
        let cells = tableView.visibleCells
        
        for cell in cells {
            let linesCell = cell as! HeadlinesCell
            linesCell.labelName.textColor = isNight ? UIColor.gray : UIColor.black
            linesCell.contentView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            linesCell.backgroundColor = isNight ? UIColor.darkGray :  UIColor.white
            
            linesCell.bottomCommentView.backgroundColor = isNight ? UIColor.darkGray :  UIColor.white
            
            linesCell.viewSeparator.backgroundColor = isNight ? UIColor.lightGray : ZZColor(244, g: 244, b: 244, a: 1)
            
        }
        
    }
   

}
extension HeadlinesViewController : UITableViewDelegate,UITableViewDataSource{

    // MARK: UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.tableViewNoDataOrNewworkFailGradient(HeadlinesPics.count)
        
        return HeadlinesPics.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeadlinesCell",for:indexPath) as! HeadlinesCell
        
        tableView.separatorStyle = .none
        
        cell.indexPath = indexPath as NSIndexPath
        
        cell.selectionStyle = .none
        
        let headModel = HeadlinesPics[indexPath.row]
        
        cell.headlinesModel = headModel
        
        if headModel.isTitleColor  != nil  {
            cell.labelContent.textColor = UIColor.lightGray
        }

        
        /******************************************************************************************/
        ///点击查看全文
        cell.didSelectedMoreClosure { [weak self](onMoreCell) in
            if ((onMoreCell.indexPath?.row)!  < self!.HeadlinesPics.count) {
                let model = self!.HeadlinesPics[(cell.indexPath?.row)!]
                model.isOpening = !model.isOpening!
                self?.tableView.reloadRows(at: [onMoreCell.indexPath! as IndexPath], with: .none)
            }
        }
        
        ///评论框
        cell.headlinesCommentButtonClosure { [weak self](commentCell ,sender) in
            if sender.tag == 111  {//评论
                
                self!.view.makeToast("点击了评论")
            }else if sender.tag == 110 {//点赞
                if ((commentCell.indexPath?.row)!  < self!.HeadlinesPics.count) {
                    let model = self!.HeadlinesPics[(cell.indexPath?.row)!]
                    
                    let isLike = !model.isLike!
                    model.isLike = isLike;
                    
                    if (isLike) {
                        model.digg_count! += 1;
                    }else{
                        model.digg_count! -= 1;
                    }
                    
                    self?.tableView.reloadRows(at: [commentCell.indexPath! as IndexPath], with: .none)
                }
            }else {//转发
                let shareView = HomeShareView.getView(nil)
                shareView.showShareView()
            }
        }
        
        
        //关闭
        cell.closeHeadlinesCellButtonClickClosure({ [weak self] (sender,filterWords) in
            self?.didIndexPath = indexPath
            // closeButton 相对于 tableView 的坐标
            let point = self!.view.convert(cell.frame.origin, from: tableView)
            let convertPoint = CGPoint(x: cell.closeButton.x, y: point.y + cell.closeButton.y + 64 + 20)
            self!.showPopView(filterWords, point: convertPoint)
        })
        
        ///图片查看
        cell.picImageViewClickClosure { [weak self](picImageView , picOriArray) in
            if headModel.video_duration != nil && (headModel.large_image_list.count == 1 || headModel.thumb_image_list.count == 1){//视频图进详情
                
                if headModel.url?.characters.count != 0{
                    let detailVC =  HomeDetailViewController()
                    
                    detailVC.hidesBottomBarWhenPushed = true
                    
                    detailVC.headlines = headModel
                    
                    self!.navigationController?.pushViewController(detailVC, animated: true)
                }
                
                
            }else{
                
                var data : [LLBrowserModel] = []
                for index in 0..<picOriArray.count {
                    let model = LLBrowserModel.init()
                    model.data = picOriArray[index]
                    model.sourceImageView = picImageView
                    data.append(model)
                }
                self!.browser = LLPhotoBrowserViewController(photoArray: data, currentIndex: picImageView.tag, sheetTitileArray:  ["分享给朋友","保存到相册"], isOpenQRCodeCheck: true, didActionSheet: {[weak self](index, imageView, string) in
                    print("ActionSheet点击-->下标=\(index); ImageView:\(imageView); qrcodeString:\(String(describing: string))")
                    if index==0 {
                        let shareView = HomeShareView.getView(nil)
                        shareView.showShareView()
                    }else{//保存到相册
                        self!.saveLocationImage(imageView.image!)
                    }
                })
                self!.browser?.presentBrowserViewController()
                
            }
        }
        /******************************************************************************************/
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = HeadlinesPics[(indexPath as NSIndexPath).row]
        
        model.isTitleColor = true
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if (cell?.isKind(of: HeadlinesCell.classForCoder()))! {
            
            let topicCell = cell as! HeadlinesCell
            
            topicCell.labelContent.textColor = UIColor.lightGray
            
        }
        if model.url?.characters.count != 0{
            
            let detailVC =  HomeDetailViewController()
            
            detailVC.hidesBottomBarWhenPushed = true
            
            detailVC.headlines = model
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row < HeadlinesPics.count {
            
            var cellHeight :CGFloat = 0.0
            
            let model = HeadlinesPics[indexPath.row]
            ///复用先从缓存里面取高度
            let cellID = model.cursor!
            
            let dict = heightDict[cellID]
            
            if dict != nil {
                if !(model.isOpening!) {
                    if let open = dict?["open"]{
                        cellHeight = open
                        
                    }
                    
                }else{
                    
                    if let normal = dict?["normal"] {
                        cellHeight = normal
                        
                    }
                    
                }
                if cellHeight > 0{
                    return cellHeight
                }
            }
            ///设置高度
            cellHeight = HeadlinesCell.hyb_height(for: tableView, config: { (sourceCell) in
                let headCell = sourceCell as! HeadlinesCell
                headCell.headlinesModel = model
            })
            
            //缓存高度
            if (model.cursor != nil) {
                var aDict =  Dictionary<String, CGFloat>()
                if !(model.isOpening!) {
                    aDict["open"] = cellHeight
                    
                }else{
                    aDict["normal"] = cellHeight
                    
                }
                
                heightDict[model.cursor!] = aDict
            }
            
            return cellHeight
            
            
        }else{
            return 44.0
        }
    }
    
    
    func saveLocationImage(_ image : UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil{
            print("error!")
            return
        }
        //        UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("图片保存成功")
        SVProgressHUD.showSuccess(withStatus: "图片保存成功")
    }
}
