//
//  SettingViewController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

let settingCellID = "settingCellID"


/// ![](http://obna9emby.bkt.clouddn.com/news/%E8%AE%BE%E7%BD%AE.png)
class SettingViewController: UIViewController {

    var tableView: UITableView?
    
    var settings = [AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "设置"
        view.backgroundColor = ZZGlobalColor()
        // 从沙盒读取缓存数据的大小
        calcuateCacheSizeFromSandBox()
        // 从 plis 加载数据
        loadSettingFromPlist()
        /// 设置 UI
        setupUI()
        
        ///改变皮肤
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        
        if let model1 =  model {
            self.switchTheSkin(model1 as! Bool)
        }
    }
    
   
    /// 网络缓存图片
    fileprivate func calcuateCacheSizeFromSandBox() {
        let cache = KingfisherManager.shared.cache
        cache.calculateDiskCacheSize { [weak self](size) in
            // 转换成 M
            let sizeM = Double(size) / 1024.0 / 1024.0
            let fileSize = self?.fileSizeOfCache()
            let sizeString = String(format: "%.2fM", sizeM + fileSize!)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
        }
  
    }
    /// 从沙盒读取缓存数据的大小
    func fileSizeOfCache()-> Double {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        //缓存目录路径
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            // 把文件名拼接到路径中
            let path = (cachePath! as NSString).appending("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc, bcd) in floder {
                // 累加文件大小
                if abc == FileAttributeKey.size {
                    size += (bcd as AnyObject).integerValue
                }
            }
        }
        let mm = Double(size) / 1024.0 / 1024.0
        return mm
    }
    func clearCache() {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            let path = (cachePath! as NSString).appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    
                }
            }
        }
    }

    
    fileprivate func setupUI() {
        view.backgroundColor = ZZGlobalColor()
//        navigationController?.navigationBar.barTintColor = UIColor.white
//        navigationController?.navigationBar.tintColor = UIColor.black
//        navigationController?.navigationBar.barStyle = .default
        
        let tableView = UITableView(frame: view.bounds, style: .plain)
        let nib = UINib(nibName: String(describing: SettingCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: settingCellID)

        tableView.backgroundColor = ZZGlobalColor()
        tableView.rowHeight = 55;
        tableView.separatorStyle = .singleLine
        tableView.sectionFooterHeight = 0.1 // 默认是0
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        self.tableView = tableView
        
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: 60))
        footView.backgroundColor = ZZGlobalColor()
        tableView.tableFooterView = footView
        
        let btn = UIButton(type: .custom)
        btn.tag = 346
        btn.backgroundColor = UIColor.clear
        btn.setTitle("今日头条用户协议", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(clickProtocolBtn), for: .touchUpInside)
        footView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(10)
            make.height.equalTo(30)
        }
        
        
    }
    func clickProtocolBtn() {
        let webVC =  WebViewController()
        webVC.urlStr = "http://m.toutiao.com/user_agreement/?hideAll=1#tt_daymode=1&tt_font=m"
        navigationController?.pushViewController(webVC, animated: true)
    }

    // 从 plist 加载数据
    fileprivate func loadSettingFromPlist() {
        let path = Bundle.main.path(forResource: "SettingPlist", ofType: "plist")
        let cellPlist = NSArray.init(contentsOfFile: path!)
        for arrayDict in cellPlist! {
            let array = arrayDict as! NSArray
            var sections = [AnyObject]()
            for dict in array {
                let cell = SettingModel(dict: dict as! [String: AnyObject])
                sections.append(cell)
            }
            settings.append(sections as AnyObject)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /// 设置字体大小
    fileprivate func setupFontAlertController() {
        let alertController = UIAlertController(title: "设置字体大小", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let smallAction = UIAlertAction(title: "小", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fontSize"), object: nil, userInfo: ["fontName": "小","fontSize": "16"])
        })
        let middleAction = UIAlertAction(title: "中", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fontSize"), object: nil, userInfo: ["fontName": "中","fontSize": "18"])
        })
        let bigAction = UIAlertAction(title: "大", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fontSize"), object: nil, userInfo: ["fontName": "大","fontSize": "19"])
        })
        let largeAction = UIAlertAction(title: "特大", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fontSize"), object: nil, userInfo: ["fontName": "特大","fontSize": "20"])
        })
        alertController.addAction(cancelAction)
        alertController.addAction(smallAction)
        alertController.addAction(middleAction)
        alertController.addAction(bigAction)
        alertController.addAction(largeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // 非 wifi 网络流量
    fileprivate func setupNetworkAlertController() {
        let alertController = UIAlertController(title: "非Wifi网络流量", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let bestFlowAction = UIAlertAction(title: "最佳效果（下载大图）", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "networkMode"), object: nil, userInfo: ["networkMode": "最佳效果（下载大图）"])
        })
        let betterFlowAction = UIAlertAction(title: "较省流量（智能下图）", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "networkMode"), object: nil, userInfo: ["networkMode": "较省流量（智能下图）"])
        })
        let leastFlowAction = UIAlertAction(title: "极省流量（不下载图）", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "networkMode"), object: nil, userInfo: ["networkMode": "极省流量（不下载图）"])
        })
        alertController.addAction(cancelAction)
        alertController.addAction(bestFlowAction)
        alertController.addAction(betterFlowAction)
        alertController.addAction(leastFlowAction)
        present(alertController, animated: true, completion: nil)
    }
    // 非 wifi 网络流量播放视频
    fileprivate func setupNetworkPlayVideoAlertController() {
        let alertController = UIAlertController(title: "非Wifi网络播放提醒", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let bestFlowAction = UIAlertAction(title: "每次提醒）", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "networkPlayVideoMode"), object: nil, userInfo: ["networkMode": "每次提醒","isload":"true"])
        })
       
        let leastFlowAction = UIAlertAction(title: "提醒一次", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "networkPlayVideoMode"), object: nil, userInfo: ["networkMode": "提醒一次","isload":"false"])
        })
        alertController.addAction(cancelAction)
        alertController.addAction(bestFlowAction)
        alertController.addAction(leastFlowAction)
        present(alertController, animated: true, completion: nil)
    }
    /// 清除缓存
    fileprivate func clearCacheAlertController() {
        let alertController = UIAlertController(title: "确定清除所有缓存？问答草稿、离线内容及图片均会被清除", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: { (_) in
            SVProgressHUD.show(withStatus: "缓存清理中")
            
            let cache = KingfisherManager.shared.cache
            cache.clearDiskCache()
            cache.clearMemoryCache()
            cache.cleanExpiredDiskCache()
            self.clearCache()
            let sizeString = "0.00M"
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
               SVProgressHUD.dismiss()
               NotificationCenter.default.post(name: Notification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
            })
            
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
       deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight:CGFloat = kMargin
        
        if(scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
        
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let setting = settings[section] as! [SettingModel]
        return setting.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCellID) as! SettingCell
        let cellArray = settings[(indexPath as NSIndexPath).section] as! [SettingModel]
        cell.setting = cellArray[(indexPath as NSIndexPath).row]
        
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                NotificationCenter.default.addObserver(self, selector: #selector(loadCacheSize(_:)), name: NSNotification.Name(rawValue: "cacheSizeM"), object: nil)
            }else if (indexPath as NSIndexPath).row == 1 {
                
                let fontSizeStr = UserDefaults.standard.object(forKey: "fontSize") as! String
                
                if !fontSizeStr.isEmpty {
                    var rightStr : String
                    
                    if fontSizeStr.compare("16").rawValue == 0{
                        rightStr = "小"
                    }else if fontSizeStr.compare("18").rawValue == 0{
                        rightStr = "中"
                    }else if fontSizeStr.compare("19").rawValue == 0{
                        rightStr = "大"
                    }else{
                        rightStr = "特大"
                    }
                    cell.rightTitleLabel.text = rightStr
                }
              
                NotificationCenter.default.addObserver(self, selector: #selector(changeFontSize(_:)), name: NSNotification.Name(rawValue: "fontSize"), object: nil)
            }else if (indexPath as NSIndexPath).row == 3 {
                let networkMode = UserDefaults.standard.object(forKey: "networkMode") as! String
                
                if !networkMode.isEmpty {
                  
                    cell.rightTitleLabel.text = networkMode
                }
                NotificationCenter.default.addObserver(self, selector: #selector(changeNeworkMode(_:)), name: NSNotification.Name(rawValue: "networkMode"), object: nil)
            }else if (indexPath as NSIndexPath).row == 4 {
                NotificationCenter.default.addObserver(self, selector: #selector(changeNeworkPlayVideoMode(_:)), name: NSNotification.Name(rawValue: "networkPlayVideoMode"), object: nil)
            }
        }
       

        return cell
    }
    //改变字体大小
    func changeFontSize(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo as! [String: AnyObject]
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = tableView?.cellForRow(at: indexPath) as! SettingCell
        cell.rightTitleLabel.text = userInfo["fontName"] as? String
        let size = userInfo["fontSize"] as! String
        
        UserDefaults.standard.set(size, forKey: "fontSize")
        UserDefaults.standard.synchronize()
    }
    
    /// 改变网络模式
    func changeNeworkMode(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo as! [String: AnyObject]
        let indexPath = IndexPath(row: 3, section: 0)
        let cell = tableView?.cellForRow(at: indexPath) as! SettingCell
        cell.rightTitleLabel.text = userInfo["networkMode"] as? String
    
        let mode = userInfo["networkMode"] as! String
        UserDefaults.standard.set(mode, forKey: "networkMode")
        UserDefaults.standard.synchronize()
    }
    /// 改变播放提醒模式
    func changeNeworkPlayVideoMode(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo as! [String: AnyObject]
        let indexPath = IndexPath(row: 4, section: 0)
        let cell = tableView?.cellForRow(at: indexPath) as! SettingCell
        cell.rightTitleLabel.text = userInfo["networkMode"] as? String
    }
    
    /// 获取缓存大小
    func loadCacheSize(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo as! [String: AnyObject]
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView?.cellForRow(at: indexPath) as! SettingCell
        cell.rightTitleLabel.text = userInfo["cacheSize"] as? String
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).section == 0 {
            
            if (indexPath as NSIndexPath).row == 0{
                // 清除缓存
                clearCacheAlertController()
            }else if (indexPath as NSIndexPath).row == 1 {
                // 设置字体大小
                setupFontAlertController()
            }else if (indexPath as NSIndexPath).row == 3 {
                // 网络流量
                setupNetworkAlertController()
            }else if (indexPath as NSIndexPath).row == 4 {
                //播放提醒
                setupNetworkPlayVideoAlertController()
            }
            
        }
    }
    
    ///改变界面夜间模式
    func switchTheSkin(_ isNight:Bool) {
        
        let section0View = self.tableView! .headerView(forSection: 0)
        let section1View = self.tableView! .headerView(forSection: 1)
        
        let btn = self.tableView!.tableFooterView!.viewWithTag(346) as! UIButton
        
        view.backgroundColor = isNight ? UIColor.gray :UIColor.white
        
        section0View?.contentView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
        section1View?.contentView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
        
        self.tableView!.tableFooterView?.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
        self.tableView!.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
        
        btn.setTitleColor(isNight ? UIColor.lightGray : UIColor.blue, for: .normal)
        self.tableView!.separatorColor = isNight ? UIColor.gray : ZZColor(235, g: 235, b: 235, a: 1)
        
        let cells = self.tableView!.visibleCells
        
        for cell in cells {
            let setCell = cell as! SettingCell
            cell.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            setCell.contentView.backgroundColor = isNight ? UIColor.darkGray :UIColor.white
            setCell.titleLabel.textColor = isNight ? UIColor.gray : UIColor.black
            setCell.subtitleLabel.textColor = isNight ? UIColor.gray : UIColor.red
            setCell.rightTitleLabel.textColor = isNight ? UIColor.gray :  UIColor.gray
            setCell.switchView.tintColor = isNight ? UIColor.gray : ZZColor(245, g: 245, b: 245, a: 1)
            setCell.switchView.onTintColor = isNight ? UIColor.gray : ZZColor(91, g: 220, b: 104, a: 1.0)
        }
        
    }

}
