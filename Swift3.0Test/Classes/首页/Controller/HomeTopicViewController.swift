//
//  HomeTopicViewController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/6.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit



let topicSmallCellID = "HomeSmallCell"
let topicMiddleCellID = "HomeMiddleCell"
let topicLargeCellID = "HomeLargeCell"
let topicNoImageCellID = "HomeNoImageCell"
let topicJokesCellID = "HomeJokesCell"
let WeatherCellID = "WeatherCell"
let SuggestionCellID = "SuggestionCell"
let CalendarCellID = "CalendarCell"
let HourCellID = "HourCell"
let ForecastCellID = "ForecastCell"



//新闻内容 VC
class HomeTopicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    /// 上一次选中 tabBar 的索引
    var lastSelectedIndex = Int()
    // 下拉刷新的时间
    fileprivate var pullRefreshTime: TimeInterval?
    // 记录点击的顶部标题
    var topTitle: HomeTopTitles?
    /// 记录点击的 x 按钮的indexPath
    var didIndexPath : IndexPath?
    
    // 存放新闻主题的数组
    fileprivate var newsTopics = [NewsTopic]()
    
    //存放天气数组模型
    fileprivate var weatherModel = [WeatherModel]()
    
    var tableView : UITableView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        setupRefresh()
       
        let fontSizeStr = UserDefaults.standard.object(forKey: "fontSize")
        
        if let sizeStr = fontSizeStr {
            chanegdCellTextFont(sizeStr as! String)
        }
        ///改变皮肤
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        
        if let model1 =  model {
            self.switchTheSkin(model1 as! Bool)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontSize(_:)), name: NSNotification.Name(rawValue: "fontSize"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changedSkinNoti(_ :)), name: NSNotification.Name(rawValue: postChangedModelNotification), object: nil)
    }
    ///接收改变字体的通知
    func changeFontSize(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo as! [String: AnyObject]
        
        let size = userInfo["fontSize"] as! String
        
        chanegdCellTextFont(size)
      
    }
    
    func chanegdCellTextFont(_ size : String) {
        
        for cell in (tableView?.visibleCells)! {
            
            if cell.isKind(of: HomeTopicCell.classForCoder()) {
                let topicCell = cell as! HomeTopicCell
                topicCell.titleLabel.font = UIFont.systemFont(ofSize: size.StringToFloat())
            }
        }
    }

    //.改变皮肤
    func changedSkinNoti(_ noti : Notification) {
        let info = noti.userInfo! as NSDictionary
        
        let node = info.object(forKey: "isNight") as! String
        
        switchTheSkin(node.compare("true").rawValue == 0)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    fileprivate func setupUI() {
        
        tableView = UITableView(frame:CGRect(x: 0, y: 0, width: Screen_Width , height: Screen_Height - 104 - 49), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        let footView = UIView()
        footView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footView
        
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.white
        
        // 注册 cell
        //新闻cell
        tableView.register(HomeSmallCell.self, forCellReuseIdentifier: topicSmallCellID)
        tableView.register(HomeMiddleCell.self, forCellReuseIdentifier: topicMiddleCellID)
        tableView.register(HomeLargeCell.self, forCellReuseIdentifier: topicLargeCellID)
        tableView.register(HomeNoImageCell.self, forCellReuseIdentifier: topicNoImageCellID)
        tableView.register(UINib.init(nibName: "HomeJokesCell", bundle: nil), forCellReuseIdentifier: topicJokesCellID)
        //天气cell
        tableView.register(UINib.init(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: WeatherCellID)
        tableView.register(SuggestionCell.self, forCellReuseIdentifier: SuggestionCellID)
        tableView.register(ForecastCell.self, forCellReuseIdentifier: ForecastCellID)
        tableView.register(HourCell.self, forCellReuseIdentifier: HourCellID)
        tableView.register(UINib.init(nibName: "CalendarCell", bundle: nil), forCellReuseIdentifier: CalendarCellID)
        
        // 预设定 cell 的高度为 97
        tableView.estimatedRowHeight = 97
        
        // 添加监听，监听 tabbar 的点击
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarSelected), name: NSNotification.Name(rawValue: ZZTabBarDidSelectedNotification), object: nil)
        
        view.addSubview(tipView)
       
    }

    
    func tabBarSelected() {
        guard self.topTitle?.category!.compare("news_local").rawValue != 0 else {
            return
        }
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
    
    // 添加上拉刷新和下拉刷新
    fileprivate func setupRefresh(){
        
        //如果是上海就获取天气
        guard self.topTitle?.category!.compare("news_local").rawValue != 0 else {
            
            view.addSubview(bgImageView)
            view.insertSubview(bgImageView, belowSubview: tableView)
            tableView.backgroundColor = UIColor.clear
         //如果是上海就刷新 天气数据
            NetworkRequest.shareNetworkRequest.loadLocationWeatherData({[weak self](weather) in
                self!.weatherModel = weather
                self!.headerView.weatherModel = weather.first
                self!.tableView.tableHeaderView = self!.headerView
                /// 设置现在的时间是白天还是晚上
                
                let model =  weather.first?.forecast15[1]
                
                let imageUrl = self!.getNowDateReloadBgImage(model!)

                self!.bgImageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named:"bgImage"), options: nil, progressBlock: nil, completionHandler: nil)
                
                self!.tableView.reloadData()
                
            })
            return
        }
        let bgImgV = view.viewWithTag(19019)
        if bgImgV != nil {
            bgImgV?.removeFromSuperview()
        }
        self.tableView.tableHeaderView = UIView()
        self.tableView.backgroundColor = UIColor.white
        pullRefreshTime = Date().timeIntervalSince1970
        
        // 有多少条文章更新
       
        //获取首页不同匪类的新闻内容
        
        NetworkRequest.shareNetworkRequest.loadHomeCategoryNewsFeed(topTitle!.category!, tableView: tableView) { [weak self] (nowTime, newsTopics,total_number) in
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: ZZRefreshSearchTitleNotification), object: nil, userInfo: nil)
            
            self!.showRefreshTipView(total_number)
            self!.pullRefreshTime = nowTime
            self!.newsTopics = newsTopics
            self!.tableView.reloadData()
        }
        
        // 获取更多新闻内容
        
        NetworkRequest.shareNetworkRequest.loadHomeCategoryMoreNewsFeed(topTitle!.category!, lastRefreshTime: pullRefreshTime!, tableView: tableView) { [weak self] (moreTopics) in
                self?.newsTopics += moreTopics
                self!.tableView.reloadData()
        }
        
    }
    //获取现在时间
    fileprivate func getNowDateReloadBgImage(_ model :WeatherForecastModel?) -> String {
        
        var contentDict : dayOrNight?
        
        var dayTime : Int?
        
        var nightTime : Int?
        
        if let day = model?.sunrise {
            let dayStr = (day as NSString).substring(to: 2)
            
            dayTime = Int(dayStr)
        }
        if let night = model?.sunset {
            nightTime = Int((night as NSString).substring(to: 2))
        }
        
        let currentDate :Date = Date()
        
        let dateFormatter : DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH"
        
        let hour = Int(dateFormatter.string(from: currentDate))
        
        if hour! >= dayTime! && hour! <= nightTime! {//白天
            
            contentDict = model?.day!
            
        }else{
            contentDict = model?.night!
        }
        
        let imageUrl = contentDict?.bgPic
        
        
        return imageUrl!
    }
    //每次刷新上面显示的标题
    fileprivate lazy var tipView :TipView = {
        
        let tipView = TipView()
        
        tipView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: 35)
        
        tipView.backgroundColor = UIColor.clear
        
        return tipView
    }()

    //天气的背景图片
    fileprivate lazy var bgImageView : UIImageView = {
        
        let bgImageView = UIImageView()
        bgImageView.tag = 19019
        bgImageView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height - 35 - 64 - 49)
        return bgImageView
    }()
    
    //Mark:天气的headerView
    fileprivate lazy var headerView : WeatherHeaderView = {
        
        let headerView = Bundle.main.loadNibNamed("WeatherHeaderView", owner: nil, options: nil)!.last as! WeatherHeaderView
        
        return headerView
    }()
    //Mark: 刷新有多少条文章更新
    fileprivate func showRefreshTipView(_ count :Int) {
        
      showTipViewAnimated(count, false)
        
    }

    // Mark: 显示弹出屏蔽新闻内容
    fileprivate func showPopView(_ filterWords: [FilterWord], point: CGPoint) {
        let popVC = PopViewController()
        popVC.filterWords = filterWords
        popVC.closeButtonPoint = point
        //Mark: 不喜欢按钮
        popVC.addButtonClickClosure { [weak self](button) in
            
            self!.newsTopics.remove(at: self!.didIndexPath!.row)
            
            self!.tableView.deleteRows(at: [self!.didIndexPath!], with: .none)
            
            self!.showTipViewAnimated(0, true)
            self!.tableView.reloadData()
            popVC.dismiss(animated: true, completion: {
                
            })
        }
        /// 设置转场动画的代理
        // 默认情况下，modal 会移除以前控制器的 view，替换为当前弹出的控制器
        // 如果自定义转场，就不会移除以前控制器的 view
       
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
    
    

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.topTitle?.category!.compare("news_local").rawValue == 0 {
            return 4
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.topTitle?.category!.compare("news_local").rawValue == 0 {
            
            tableView.tableViewNoDataOrNewworkFail(weatherModel.count)
            return weatherModel.count
        }else{
            tableView.tableViewNoDataOrNewworkFailGradient(newsTopics.count)
            
            return newsTopics.count
        }
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        guard self.topTitle?.category!.compare("news_local").rawValue != 0 else{
            
            let model = weatherModel[(indexPath as NSIndexPath).row]
            
            let formodel = model.forecast15
            
            
            if indexPath.section == 0 {
            
                let calendarCell = tableView.dequeueReusableCell(withIdentifier: CalendarCellID) as! CalendarCell

                calendarCell.model = formodel[1]
                calendarCell.selectionStyle = .none
                return calendarCell
                
            }else if indexPath.section == 1{
                
                let forecastCell = tableView.dequeueReusableCell(withIdentifier: ForecastCellID) as! ForecastCell
                forecastCell.selectionStyle = .none
                forecastCell.dailyArray = formodel
                ///点击查看白天和晚上的天气
                forecastCell.didSelectScrollViewClosure({ [weak self](sender) in
                    let forecast = formodel[sender.tag]
                    let weathpopView = WeatherPopView.createView(fromNibName: "WeatherPopView")
                    weathpopView?.forcastModel = forecast
                    let alertVC = TYAlertController(alert: weathpopView, preferredStyle: TYAlertControllerStyle.alert)
                    alertVC?.backgoundTapDismissEnable = true
                    self!.present(alertVC!, animated: true, completion: nil)
                })
            
                return forecastCell
            }else if indexPath.section == 2{
                
                let hourCell = tableView.dequeueReusableCell(withIdentifier: HourCellID) as! HourCell
                
                hourCell.hourArray = model.hourfc
                
                
                return hourCell
                
            }else{
                
                let suggestionCell = tableView.dequeueReusableCell(withIdentifier: SuggestionCellID) as! SuggestionCell
                
                suggestionCell.reloadData(model.indexes)
                //生活指数
                suggestionCell.didSelectedSuggItemClosure({[weak self] (model) in
                    
                    let indexView = IndexView(frame: CGRect(x: 0, y: 0, width: 280, height: 130))
                    indexView.indexModel = model
                    let alertVC = TYAlertController(alert: indexView, preferredStyle: TYAlertControllerStyle.alert)
                    alertVC?.backgoundTapDismissEnable = true
                    self!.present(alertVC!, animated: true, completion: nil)
                })
                
                return suggestionCell
                
            }
            
        }
        
        let newsTopic = newsTopics[(indexPath as NSIndexPath).row]
        
        if newsTopic.cell_type == 3 {//段子 美女 趣图
        
            let cell = tableView.dequeueReusableCell(withIdentifier: topicJokesCellID) as! HomeJokesCell
            
            tableView.separatorStyle = .none
           
            cell.jokesTopic = newsTopic

            //图片的点击回调
            cell.jokesImageViewClickClosure({ (picImageV) in
                
                
                if newsTopic.label_style == 4 {//趣图
                    
                    if CGFloat(newsTopic.large_image!.height!) > Screen_Height{
                        
                        cell.picImageView.showLongImage()
                        
                    }else{
                       cell.picImageView.scaleImageView()
                    }
                }else{//美女
                    
                    cell.picImageView.scaleImageView()
                }
            })
            //按钮的点击回调
            cell.jokesButtonClickClosure({ [weak self] (sender , jokesCell) in
                self!.jokesCellButtonClickAction(sender ,jokesCell)
            })
            ///改变皮肤
            let model = UserDefaults.standard.object(forKey: userChangedModel)
            
            if let model1 =  model {
                let isNight = model1 as! Bool
                
                cell.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
                cell.jokesView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
                cell.contentLabel.textColor  = isNight ? UIColor.gray :  UIColor.black
                cell.contentView.backgroundColor = isNight ?  UIColor.darkGray : ZZGlobalColor()
                cell.bottomView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
                cell.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
            }
            if newsTopic.isTitleColor  != nil  {
                cell.contentLabel.textColor = UIColor.lightGray
            }
            cell.selectionStyle = .none
            return cell
            
        }else {//推荐热点等
            tableView.separatorStyle = .singleLine
           
            
            let topicCell = tableViewcellReload(newsTopic, tableView,indexPath)
            
            topicCell.selectionStyle = .none
            ///改变皮肤
            let model = UserDefaults.standard.object(forKey: userChangedModel)
            
            if let model1 =  model {
                let isNight = model1 as! Bool
                
                topicCell.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
                topicCell.contentView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
                
                topicCell.titleLabel.textColor  = isNight ? UIColor.gray :  UIColor.black
            }
            
            if newsTopic.isTitleColor != nil {
                
                topicCell.titleLabel.textColor = UIColor.lightGray
            }
          

            return topicCell;

        }
    }
    //刷新 cell 的数据
    func tableViewcellReload(_ newsTopic:NewsTopic, _ tableView : UITableView ,_ indexPath :IndexPath) -> HomeTopicCell {
        
        
        
        if newsTopic.image_list.count != 0 {//三张图
            let cell = tableView.dequeueReusableCell(withIdentifier: topicSmallCellID) as! HomeSmallCell
            cell.newsTopic = newsTopic
            
            cell.closeSmallCellButtonClickClosure({ [weak self] (sender,filterWords) in
                self?.didIndexPath = indexPath
                // closeButton 相对于 tableView 的坐标
                let point = self!.view.convert(cell.frame.origin, from: tableView)
                let convertPoint = CGPoint(x: cell.closeButton.x, y: point.y + cell.closeButton.y + 119)
                self!.showPopView(filterWords, point: convertPoint)
            })
            return cell
        } else {
            if newsTopic.middle_image?.height != nil {//大图
                if newsTopic.video_detail_info?.video_id != nil || newsTopic.large_image_list.count != 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: topicLargeCellID) as! HomeLargeCell
                    cell.newsTopic = newsTopic
                    cell.selectionStyle = .none
                    cell.closeLargeCellButtonClickClosure({ [weak self] (sender,filterWords) in
                         self?.didIndexPath = indexPath
                        // closeButton 相对于 tableView 的坐标
                        let point = self!.view.convert(cell.frame.origin, from: tableView)
                        
                        let convertPoint = CGPoint(x: cell.closeButton.x, y: point.y + cell.closeButton.y + 119)
                        self!.showPopView(filterWords, point: convertPoint)
                    })
                    return cell
                } else {//右边一张图
                    let cell = tableView.dequeueReusableCell(withIdentifier: topicMiddleCellID) as! HomeMiddleCell
                    cell.newsTopic = newsTopic
                    cell.selectionStyle = .none
                    cell.closeMiddleCellButtonClickClosure({ [weak self] (sender,filterWords) in
                         self?.didIndexPath = indexPath
                        // closeButton 相对于 tableView 的坐标
                        let point = self!.view.convert(cell.frame.origin, from: tableView)
                        let convertPoint = CGPoint(x: cell.closeButton.x, y: point.y + cell.closeButton.y + 119)
                        self!.showPopView(filterWords, point: convertPoint)
                    })
                    return cell
                }
            } else {//没有图
                let cell = tableView.dequeueReusableCell(withIdentifier: topicNoImageCellID) as! HomeNoImageCell
                cell.newsTopic = newsTopic
                cell.selectionStyle = .none
                cell.closeNoImageCellButtonClickClosure({ [weak self] (sender,filterWords) in
                     self?.didIndexPath = indexPath
                    // closeButton 相对于 tableView 的坐标
                    let point = self!.view.convert(cell.frame.origin, from: tableView)
                    let convertPoint = CGPoint(x: cell.closeButton.x, y: point.y + cell.closeButton.y + 119)
                    self!.showPopView(filterWords, point: convertPoint)
                })
                return cell
            }
        }
        
    }
    // MARK: - UITableViewDeleagte
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        guard self.topTitle?.category!.compare("news_local").rawValue != 0 else{
         
            if indexPath.section == 0 {
                
                return 70
            }else if indexPath.section == 1{
                
                return 240
            }else if indexPath.section == 2{
                return 70
            }else{
                return 220
            }
            
        }
        let newsTopic =  newsTopics[(indexPath as NSIndexPath).row]
        if newsTopic.cell_type == 3 {
            if newsTopic.label_style == 5 { //段子
                
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.lineBreakMode = .byCharWrapping
                paraStyle.alignment = .left
                paraStyle.lineSpacing = 5
                paraStyle.hyphenationFactor = 1.0
                paraStyle.firstLineHeadIndent = 0.0
                paraStyle.paragraphSpacingBefore = 0.0
                paraStyle.headIndent = 0
                paraStyle.tailIndent = 0
                
                let attributeDict = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:0.5] as [String : Any]
                let size = newsTopic.content!.boundingRect(with: CGSize(width:Screen_Width - 30,height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attributeDict, context: nil).size
                
                let sizeHeight = size.height
                
                 return sizeHeight + 88
                
            }else if newsTopic.label_style == 7 {//美女
                
                var cellH = CGFloat()
                
                if CGFloat(newsTopic.large_image!.height!) > Screen_Height {
                    
                    cellH = Screen_Height - 64 - 40 - 49 + 68.0
                }else{
                    cellH = CGFloat(newsTopic.large_image!.height!) + 68.0
                }
                
                return cellH
            }else if newsTopic.label_style == 4 {//趣图
             
                return CGFloat(newsTopic.large_image!.height!) - 64 - 40 - 49 + 68.0
            }
          
        }else if newsTopic.cell_type == 32 {
            let attributeDict = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSKernAttributeName:0.5] as [String : Any]
            let size = newsTopic.content!.boundingRect(with: CGSize(width:Screen_Width - 30,height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attributeDict, context: nil).size
            
            return size.height + 55
        }
            return newsTopic.cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard self.topTitle?.category!.compare("news_local").rawValue != 0 else{
            
          return
            
        }
        let newsTopic = newsTopics[(indexPath as NSIndexPath).row]
        
        newsTopic.isTitleColor = true
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if (cell?.isKind(of: HomeTopicCell.classForCoder()))! {
            
            let topicCell = cell as! HomeTopicCell
            
            topicCell.titleLabel.textColor = UIColor.lightGray
            
        }else if (cell?.isKind(of: HomeJokesCell.classForCoder()))!{
         
            let homejokesCell = cell as! HomeJokesCell
            
            homejokesCell.contentLabel.textColor = UIColor.lightGray
            
        }
  
        
        let detailVC =  HomeDetailViewController()
        
        detailVC.hidesBottomBarWhenPushed = true
        
        detailVC.newTopics = newsTopic
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
       
    }
    //头文字
    fileprivate lazy var headerSectionArr : Array = { () -> [String] in 
        
        let sectionArr = ["","15日预报","24小时预报","生活指数"]
        
        return sectionArr
    }()
    
    //设置 TableView 的sectionheader
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard self.topTitle?.category!.compare("news_local").rawValue != 0 else{
            
            if weatherModel.count != 0  {
                
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 30))
                headerView.backgroundColor = ZZWeatherBGColor()
                
                let label = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.width - 30, height: 30))
                label.textColor = UIColor.white
                label.textAlignment = .left
                label.font = UIFont.systemFont(ofSize: 14)
                label.text = headerSectionArr[section]
                headerView.addSubview(label)
                
                let lineView = UIView(frame: CGRect(x: 0, y: 30, width: self.view.width, height: 1))
                lineView.alpha = 0.4
                lineView.backgroundColor = UIColor.white
                headerView.addSubview(lineView)
                
                return section == 0 ? UIView() : headerView

            }
            return UIView()
        }
        return UIView()
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard self.topTitle?.category!.compare("news_local").rawValue != 0 else{
            
            let footView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 10))
            footView.backgroundColor = UIColor.clear
            
            return footView
            
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard self.topTitle?.category!.compare("news_local").rawValue != 0 else{
            
            if section == 0 {
                return 0.0001
            }
            return 30.0
            
        }
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        guard self.topTitle?.category!.compare("news_local").rawValue != 0 else{
            
            return 10.0
            
        }
        return 0.0001
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight:CGFloat = 30.0
        
        if(scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
        
    }
    // MARK: 段子 cell上 按钮的点击事件
    func jokesCellButtonClickAction(_ sender :UIButton ,_ cell : HomeJokesCell) {
        
        if sender.tag == 110 {//赞
            
            if cell.badBtn.isSelected {
                self.view.makeToast("你已经踩过了")
                return
            }
            if sender.isSelected {
                self.view.makeToast("你已经赞过了")
                return
            }
            sender.isSelected = true
            let num = Int(sender.titleLabel!.text!)
            let result = num! + 1
            sender.setTitle("\(result)", for: UIControlState())
        }else if sender.tag == 111{//踩
            if cell.goodBtn.isSelected {
                self.view.makeToast("你已经赞过了")
                return
            }
            
            if sender.isSelected  {
                self.view.makeToast("你已经踩过了")
                return
            }
            sender.isSelected = true
            let num = Int(sender.titleLabel!.text!)
            let result = num! + 1
            sender.setTitle("\(result)", for: UIControlState())
        }else if sender.tag == 112{//评论
            
        }else if sender.tag == 113{//收藏
            
        }else if sender.tag == 114{//分享
            let shareView = HomeShareView.getView(nil)
            shareView.showShareView()
        }
       
    }
     // MARK: 提示文字的动画
    func showTipViewAnimated(_ count :Int , _ isClose: Bool) {
        
        if isClose {//关闭提示
            
            self.tipView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: 35)
            
            self.tipView.tipLabel.text = "我们将为您减少类似新闻的推送"
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
        }else{//刷新提示
            
            self.tipView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: 35)
            self.tableView.frame = CGRect(x: 0, y: 35, width: Screen_Width, height: Screen_Height - 104 - 49)
            
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
                    self.tableView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height - 104 - 49)
                    
                })
            })
        }
    }
    
    // MARK: 改变皮肤
    func switchTheSkin(_ isNight : Bool)  {
        view.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
        tableView.backgroundColor = isNight ? UIColor.darkGray :  UIColor.white
        
        tableView.separatorColor = isNight ? UIColor.gray :  ZZColor(235, g: 235, b: 235, a: 1)
    
        let cells = tableView.visibleCells
        
        for cell in cells {
            
            cell.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            cell.contentView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            
            if cell.isKind(of: HomeTopicCell.classForCoder()) {
                let topicCell = cell as! HomeTopicCell
                topicCell.titleLabel.textColor  = isNight ? UIColor.gray :  UIColor.black
            }else if cell.isKind(of: HomeJokesCell.classForCoder()){
                let jokesCell = cell as! HomeJokesCell
                jokesCell.contentLabel.textColor  = isNight ? UIColor.gray :  UIColor.black
                jokesCell.bottomView.backgroundColor = isNight ? UIColor.darkGray :  UIColor.white
                jokesCell.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
                jokesCell.contentView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
                jokesCell.jokesView.backgroundColor = isNight ?  UIColor.darkGray : UIColor.white
            }
            
        }
        
    }
    
}

