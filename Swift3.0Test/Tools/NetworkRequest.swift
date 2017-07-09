//
//  NetworkRequest.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import MJRefresh

class NetworkRequest: NSObject {

    //单例
   static let shareNetworkRequest = NetworkRequest()
    
    
    /// 有多少条文章更新
    func loadArticleRefreshTip(_ finished:@escaping (_ count: Int)->()) {
        let url = BASE_URL + "2/article/v52/refresh_tip/"
        Alamofire
            .request(url)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    let data = json["data"].dictionary
                    let count = data!["count"]!.int
                    finished(count!)
                }
        }
        
    }
    //上海本地的天气 此处获取的是 中华万年历 上面的天气通的数据
    func loadLocationWeatherData(_ finished: @escaping (_ weather : [WeatherModel]) -> ()) {
        
        let url = "http://zhwnlapi.etouch.cn/Ecalender/api/v2/weather"
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyyMMdd"
        
        let nowStr = dateFormatter.string(from: Date())
        
        //六安 "101221501"
        let params = [
            "app_key" : "99817882",
            "citykey" : "101020100",
            "date"       :nowStr
            ] as [String :AnyObject]
        
        //网络请求的方法
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                
                //guard 确保返回 的是 success
                guard response.result.isSuccess else{
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }            //if let 可选值解包
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    //返回 json 字符串
                    
                    if let dict = json.dictionaryObject {
                        
                        var topics = [WeatherModel]()
                        let model = WeatherModel(dict: dict as [String : AnyObject] )
                            
                        topics.append(model)
                        
                        finished(topics)
                    }
                }
        }
        
    }
    
    
    //获取首页顶部标题内容 (和视频内容一个接口) 返回一个数组
    func loadHomeTitlesData(_ finished:@escaping (_ topTitles:[HomeTopTitles]) -> ()) {
        
        let url = BASE_URL + "article/category/get_subscribed/v1/?"
        
        let params = [
                      "device_id" : device_id,
                      "aid"       :13,
                      "iid"       :IID
                      ] as [String :AnyObject]
        
        //网络请求的方法
        Alamofire
        .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
        .responseJSON { (response) in
            
            //guard 确保返回 的是 success
            guard response.result.isSuccess else{
                SVProgressHUD.showError(withStatus: "加载失败...")
                return
            }            //if let 可选值解包
            if let value = response.result.value {
                
                let json = JSON(value)
                //返回 json 字符串
                let dataDict = json["data"].dictionary
                
                if let data = dataDict?["data"]?.arrayObject {
                    var topics = [HomeTopTitles]()
                    for dict in data {
                        let title = HomeTopTitles(dict: dict as! [String : AnyObject] )
                        
                            topics.append(title)
                        
                    }
                    finished(topics)
                }
            }
        }
        
    }
    
    
    /// 首页 -> 『+』点击，添加标题，获取推荐标题内容
    func loadRecommendTopic(_ finished:@escaping (_ recommendTopics: [HomeTopTitles]) -> ()) {
        let url = BASE_URL + "article/category/get_extra/v1/?"
        let params = ["device_id": device_id,
                      "aid": 13,
                      "iid": IID] as [String : AnyObject]
        Alamofire
        .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
        .responseJSON { (response) in
            
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let dataDict = json["data"].dictionary
                    
                    if let data = dataDict?["data"]?.arrayObject {
                        var topics = [HomeTopTitles]()
                        for dict in data {
                            let title = HomeTopTitles(dict: dict as! [String: AnyObject])
                            topics.append(title)
                        }
                        
                        finished(topics)
                    }
                }
        }
    }
        
    /// 获取首页不同分类的新闻内容(和视频内容使用一个接口)
    func loadHomeCategoryNewsFeed(_ category: String, tableView: UITableView, finished:@escaping (_ nowTime: TimeInterval,_ newsTopics: [NewsTopic],_ total_number : Int)->()) {
        //监听网络状态
//        NetworkStatusListener()
        
        let url = BASE_URL + "api/news/feed/v52/?"
        let params = ["device_id": device_id,
                      "category": category,
                      "iid": IID,
                      "concern_id" : "6216118345905736194"] as [String :AnyObject]

        tableView.mj_header = WQGifHeader(refreshingBlock: { 
            let nowTime = Date().timeIntervalSince1970
            Alamofire
                .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (response) in
                    tableView.mj_header.endRefreshing()
                    guard response.result.isSuccess else {
                        SVProgressHUD.showError(withStatus: "加载失败...")
                        return
                    }
                    if let value = response.result.value {
                        let json = JSON(value)
                        let total_number = json["total_number"].stringValue
                        let datas = json["data"].array
                        var topics = [NewsTopic]()
                        for data in datas! {
                            let content = data["content"].stringValue
                            let contentData: Data = content.data(using: String.Encoding.utf8)!
                            
                            let dict = JSON(contentData).dictionaryObject
                            if let object = dict {
                                let topic = NewsTopic(dict: object as [String : AnyObject])
                                topics.append(topic)
                            }
                        }
                        finished(nowTime, topics, Int(total_number)!)
                }
            }

        })
      

        tableView.mj_header.isAutomaticallyChangeAlpha = true //根据拖拽比例自动切换透
        tableView.mj_header.beginRefreshing()
    }
    
    /// 获取首页不同分类的更多新闻内容
    func loadHomeCategoryMoreNewsFeed(_ category: String, lastRefreshTime: TimeInterval, tableView: UITableView, finished:@escaping (_ moreTopics: [NewsTopic] )->()) {
        
        
        let url = BASE_URL + "api/news/feed/v52/?"
        let params = ["device_id": device_id,
                      "category": category,
                      "iid": IID,
                      "last_refresh_sub_entrance_interval": lastRefreshTime] as [String : AnyObject]
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            Alamofire
                .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (response) in
                    tableView.mj_footer.endRefreshing()
                    guard response.result.isSuccess else {
                        SVProgressHUD.showError(withStatus: "加载失败...")
                        return
                    }
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let datas = json["data"].array
                        var topics = [NewsTopic]()
                        for data in datas! {
                            let content = data["content"].stringValue
                            let contentData: Data = content.data(using: String.Encoding.utf8)!

                            let dict = JSON(contentData).dictionaryObject
                            
                            if let object = dict {
                                let topic = NewsTopic(dict: object as [String : AnyObject])
                                topics.append(topic)
                            }
                           
                        }
                        finished(topics)
                    }
            }
        })
        tableView.mj_footer.isAutomaticallyHidden = true
    }
    //搜索的文字提示
    func loadSearchBarTitle(_ finished:@escaping (_ searchTitle: String)->()) {
        
        let url = BASE_URL + "search/suggest/homepage_suggest/?"
        
        let params = [
            "device_id" : device_id,
            "aid"       :13,
            "iid"       :IID
            ] as [String :AnyObject]

        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    let data = json["data"].dictionary
                    let title = data!["homepage_search_suggest"]!.string
                    finished(title!)
                }
        }

    }
    //搜索页面 提示文字
    func loadSearchPromptTitle(_ finished:@escaping (_ searchTitle: [AnyObject])->()) {
        
        let url = BASE_URL + "/search/suggest/wap/initial_page/?"
        
        let params = [
            "device_id" : device_id,
            "aid"       :13,
            "iid"       :IID
            ] as [String :AnyObject]
        
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    let data = json["data"].dictionary
                    let array = data!["suggest_words"]!.arrayObject
                    finished(array! as [AnyObject])
                }
        }
        
    }
        
    
    /// 搜索内容
    func loadSearchResult(_ keyword: String, finished:@escaping (_ keywords: [Keyword]) -> ()) {
        let url = BASE_URL + "2/article/search_sug/?"
        let params = [
            "device_id" : device_id,
            "aid"       :13,
            "iid"       :IID,
            "keyword"   :keyword
            ] as [String :AnyObject]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    if let datas = json["data"].arrayObject {
                        var keywords = [Keyword]()
                        for data in datas {
                            let keyword = Keyword(dict: data  as! [String: AnyObject])
                            keywords.append(keyword)
                        }
                        finished(keywords)
                    }
                }
        }
    }
    
    /** -------------------------- 视 频 --------------------------    **/
    //
    /// 获取视频顶部标题内容
    func loadVideoTitlesData(_ finished:@escaping (_ topTitles: [VideoTopTitle])->()) {
        // version_code 表示今日头条的版本号，经过测试 >= 5.6 版本新增了『火山直播』
        // os_version 表示 iOS 的系统版本，经测试 >= 8.0 版本新增了『火山直播』
        let url = BASE_URL + "video_api/get_category/v1/?"
        let params = ["device_id": device_id,
                      "version_code": "5.7.1",
                      "iid": IID,
                      "device_platform": "iphone",
                      "os_version": "9.3.2"] as [String :  AnyObject]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    if let data = json["data"].arrayObject {
                        var titles = [VideoTopTitle]()
                        for dict in data {
                            let title = VideoTopTitle(dict: dict as! [String: AnyObject])
                            titles.append(title)
                        }
                        finished( titles)
                    }
                }
        }
    }

    /** -------------------------- 微 头 条 --------------------------   **/
    ///获取微头条内容
    func loadHeadlinesNewsFeed( tableView: UITableView, finished:@escaping (_ nowTime: TimeInterval,_ HeadlinesModel: [HeadlinesModel],_ total_number : Int)->()) {
     
        let url = BASE_URL + "api/news/feed/v54/?"
        let params = ["device_id": device_id,
                      "iid": "11429169384",
                      "category":"weitoutiao",
                      "aid": 13,
                      "concern_id" : "6368255615201970690"] as [String :AnyObject]
        
        tableView.mj_header = WQGifHeader(refreshingBlock: {
            let nowTime = Date().timeIntervalSince1970
            Alamofire
                .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (response) in
                    tableView.mj_header.endRefreshing()
                    guard response.result.isSuccess else {
                        SVProgressHUD.showError(withStatus: "加载失败...")
                        return
                    }
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let total_number = json["total_number"].stringValue
                        let datas = json["data"].array
                        var headlines = [HeadlinesModel]()
                        for data in datas! {
                            let content = data["content"].stringValue
                            let contentData: Data = content.data(using: String.Encoding.utf8)!
                            
                            let dict = JSON(contentData).dictionaryObject
                            let topic = HeadlinesModel(dict: dict! as [String : AnyObject])
                            headlines.append(topic)
                        }
                        finished(nowTime, headlines, Int(total_number)!)
                    }
            }
            
        })
        
        
        tableView.mj_header.isAutomaticallyChangeAlpha = true //根据拖拽比例自动切换透
        tableView.mj_header.beginRefreshing()
    }
    /// 获取微头条更多内容
    func loadHeadlinesMoreNewsFeed( lastRefreshTime: TimeInterval, tableView: UITableView, finished:@escaping (_ HeadlinesModel: [HeadlinesModel] )->()) {
        
        
        let url = BASE_URL + "api/news/feed/v52/?"
        let params = [
                      "device_id": device_id,
                      "iid": "11429169384",
                      "category":"weitoutiao",
                      "aid": 13,
                      "concern_id" : "6368255615201970690",
                      "last_refresh_sub_entrance_interval": lastRefreshTime] as [String : AnyObject]
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            Alamofire
                .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (response) in
                    tableView.mj_footer.endRefreshing()
                    guard response.result.isSuccess else {
                        SVProgressHUD.showError(withStatus: "加载失败...")
                        return
                    }
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let datas = json["data"].array
                        var headline = [HeadlinesModel]()
                        for data in datas! {
                            let content = data["content"].stringValue
                            let contentData: Data = content.data(using: String.Encoding.utf8)!
                            
                            let dict = JSON(contentData).dictionaryObject
                            let topic = HeadlinesModel(dict: dict! as [String : AnyObject])
                            headline.append(topic)
                        }
                        finished(headline)
                    }
            }
        })
        tableView.mj_footer.isAutomaticallyHidden = true
    }

    

    /*************** 网络状态监听部分（开始） *************************/
    // Reachability必须一直存在，所以需要设置为全局变量
    let reachability = Reachability()!
    
    func NetworkStatusListener() {
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    // 移除消息通知
    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    // 主动检测网络状态
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        var reachabStr :String?
        
        if reachability.isReachable { // 判断网络连接状态
            print("网络连接：可用")
            if reachability.isReachableViaWiFi { // 判断网络连接类型
                print("连接类型：WiFi")
                reachabStr = "WiFi"
            } else {
                print("连接类型：移动网络")
                reachabStr = "WWAN"
            }
        } else {
            print("网络连接：不可用")
            reachabStr = "NotReachable"
            DispatchQueue.main.async { // 不加这句导致界面还没初始化完成就打开警告框，这样不行
                self.alert_noNetwrok() // 警告框，提示没有网络
            }
        }
        
        UserDefaults.standard.set(reachabStr, forKey: "reachability")
        UserDefaults.standard.synchronize()
    }
    
    // 警告框，提示没有连接网络 *********************
    func alert_noNetwrok() -> Void {
        SVProgressHUD.showError(withStatus: "没有连接到网络")
    }
    /******************** 网络状态监听部分（结束） *********************************/

}
