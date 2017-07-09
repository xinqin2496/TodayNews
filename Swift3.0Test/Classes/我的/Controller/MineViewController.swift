//
//  MineViewController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/5.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import SVProgressHUD

let mineCellID = "MineCell"
/// ![](http://obna9emby.bkt.clouddn.com/news/%E6%88%91%E7%9A%84-%E6%9C%AA%E7%99%BB%E5%BD%95_spec.png)
/// ![](http://obna9emby.bkt.clouddn.com/news/%E6%88%91%E7%9A%84.png)
class MineViewController: UITableViewController {
    
    var cells = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 从 plist 加载数据
        loadCellFromPlist()
        // 设置 UI
        setupUI()
        
        self.fd_prefersNavigationBarHidden = true
        
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        
        if let changedModel = model {
            
            self.switchTheSkin(changedModel as! Bool)
        }
        
    }
    // 从 plist 加载数据
    fileprivate func loadCellFromPlist() {
        let path = Bundle.main.path(forResource: "MineCellPlist", ofType: "plist")
        let cellPlist = NSArray.init(contentsOfFile: path!)
        for arrayDict in cellPlist! {
            let array = arrayDict as! NSArray
            var sections = [AnyObject]()
            for dict in array {
                let cell = MineCellModel(dict: dict as! [String: AnyObject])
                sections.append(cell)
            }
            cells.append(sections as AnyObject)
        }
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = ZZGlobalColor()
        
        tableView.separatorStyle = .singleLine
        let footerView = UIView()
        footerView.height = kMargin
        tableView.tableFooterView = footerView
        tableView.rowHeight = kMineCellH 
        UserDefaults.standard.bool(forKey: isLogin) ? (tableView.tableHeaderView = headerView) : (tableView.tableHeaderView = noLoginHeaderView)
        headerView.headerViewClosure = { (iconButton) in
            print(iconButton)
        }
        ///收藏
        headerView.bottomView.collectionButtonClosure = { [weak self](collectionButton) in
            self!.view.makeToast("收藏")
        }
        
        headerView.bottomView.nightButtonClosure = { [weak self](nightButton) in
           nightButton.isSelected = !nightButton.isSelected
                if nightButton.isSelected {
                    
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: postChangedModelNotification), object: nil,userInfo: ["isNight":"true"])
                }else{
    
                    
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: postChangedModelNotification), object: nil,userInfo: ["isNight":"false"])
                }
            self!.switchTheSkin(nightButton.isSelected)
            
            UserDefaults.standard.set(nightButton.isSelected, forKey: userChangedModel)
            
            
           
        }
        
        headerView.bottomView.historyButtonClosure = { [weak self](historyButton) in
            
            self!.view.makeToast("历史")

        }
        
        noLoginHeaderView.bottomView.collectionButtonClosure = headerView.bottomView.collectionButtonClosure
        
        noLoginHeaderView.bottomView.nightButtonClosure = headerView.bottomView.nightButtonClosure
        
        noLoginHeaderView.bottomView.historyButtonClosure = headerView.bottomView.historyButtonClosure
        
    }
    
    /// 懒加载，创建 未登录 headerView
    fileprivate lazy var noLoginHeaderView: MineNoLoginHeaderView = {
        let noLoginHeaderView = MineNoLoginHeaderView.noLoginHeaderView()
        noLoginHeaderView.delegate = self
        return noLoginHeaderView
    }()
    
    /// 懒加载，创建 headerView
    fileprivate lazy var headerView: MineHeaderView = {
        let headerView = MineHeaderView.headerView()
        return headerView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MineViewController: MineNoLoginHeaderViewDelegate {
    
    // MARK: - MineNoLoginHeaderViewDelegate
    func noLoginHeaderView(_ headerView: MineNoLoginHeaderView, mobileLoginButtonClick: UIButton) {
       
        let loginVC = LoginOrRegisterController()
        present(loginVC, animated: true) {
            
        }
    }
    
    func noLoginHeaderView(_ headerView: MineNoLoginHeaderView, wechatLoginButtonClick: UIButton) {
       view.makeToast("微信登录")
    }
    
    func noLoginHeaderView(_ headerView: MineNoLoginHeaderView, qqLoginButtonClick: UIButton) {
        view.makeToast("QQ登录")
    }
    
    func noLoginHeaderView(_ headerView: MineNoLoginHeaderView, weiboLoginButtonClick: UIButton) {
      view.makeToast("微博登录")
    }
    
    func noLoginHeaderView(_ headerView: MineNoLoginHeaderView, moreLoginButtonClick: UIButton) {
        let loginVC = LoginOrRegisterController()
        present(loginVC, animated: true) { 
            
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellAyyay = cells[section] as! [MineCellModel]
        return cellAyyay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: mineCellID)
        if cell == nil {
            cell = UITableViewCell (style: .value1, reuseIdentifier: mineCellID)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.accessoryType = .disclosureIndicator
            cell?.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0)
        }
        
        let cellArray = cells[(indexPath as NSIndexPath).section] as! [MineCellModel]
        let model = cellArray[indexPath.row] 
        
        cell?.textLabel?.text = model.title!
        cell?.detailTextLabel?.text = model.subtitle!
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let cellArray = cells[(indexPath as NSIndexPath).section] as! [MineCellModel]
        let model = cellArray[indexPath.row]
        
        jumpWithCellTitle(model.title!)
    }
   
    
    // MARK: - UIScrollViewDelagate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            if UserDefaults.standard.bool(forKey: isLogin) {
                var tempFrame = headerView.bgImageView.frame
                tempFrame.origin.y = offsetY
                tempFrame.size.height = kZZMineHeaderImageHeight - offsetY
                headerView.bgImageView.frame = tempFrame
                headerView.bgImageView.snp.updateConstraints({ (make) in
                    make.height.equalTo(tempFrame.size.height)
                })
            } else {
                var tempFrame = noLoginHeaderView.bgImageView.frame
                tempFrame.origin.y = offsetY
                tempFrame.size.height = kZZMineHeaderImageHeight - offsetY
                noLoginHeaderView.bgImageView.frame = tempFrame
            }
        }
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    ///点击跳转
    func jumpWithCellTitle(_ title : String) {
        if title.compare("我的关注").rawValue == 0 {
            
        }else if title.compare("消息通知").rawValue == 0 {
            
        }else if title.compare("天猫商城").rawValue == 0 {
            
            let webVC =  WebViewController()
            webVC.urlStr = "https://www.tmall.com"
            navigationController?.pushViewController(webVC, animated: true)
            
        }else if title.compare("京东特供").rawValue == 0 {
            
            let webVC =  WebViewController()
            webVC.urlStr = "https://www.jd.com"
            navigationController?.pushViewController(webVC, animated: true)
            
        }else if title.compare("我要爆料").rawValue == 0 {
            
        }else if title.compare("用户反馈").rawValue == 0 {
            
        }else if title.compare("系统设置").rawValue == 0 {
            
            let setVC = SettingViewController()
    
            setVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(setVC, animated: true)
        }
    }
    
    ///改变界面夜间模式
    func switchTheSkin(_ isNight:Bool) {
        
        let section0View = self.tableView .headerView(forSection: 0)
        let section1View = self.tableView .headerView(forSection: 1)
        let section2View = self.tableView .headerView(forSection: 2)
        
        noLoginHeaderView.bottomView.nightButton.isSelected = isNight
        noLoginHeaderView.bottomView.nightButton.setTitle(isNight ? "日间" : "夜间", for: .normal)
        noLoginHeaderView.bottomView.nightButton.setImage(UIImage(named: isNight ? "日间" : "nighticon_profile_24x24_"), for: .normal)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
            self.noLoginHeaderView.bottomView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            self.noLoginHeaderView.bottomView.collectionButton .setTitleColor (isNight ? UIColor.gray: UIColor.black, for: .normal)
            
            self.noLoginHeaderView.bottomView.historyButton .setTitleColor( isNight ? UIColor.gray : UIColor.black, for: .normal)
            self.noLoginHeaderView.bottomView.nightButton .setTitleColor( isNight ? UIColor.gray : UIColor.black, for: .normal)
            
            section0View?.contentView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
            section1View?.contentView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
            section2View?.contentView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
            self.tableView.separatorColor = isNight ? UIColor.gray : ZZColor(235, g: 235, b: 235, a: 1)
            self.tableView.backgroundColor = isNight ? UIColor.gray : ZZGlobalColor()
            
            let cells = self.tableView.visibleCells
            
            for cell in cells {
                cell.backgroundColor = isNight ? UIColor.darkGray :  UIColor.white
                cell.textLabel?.textColor = isNight ? UIColor.gray :  UIColor.black
                cell.detailTextLabel?.textColor = isNight ? UIColor.gray :  UIColor.black
            }
        })
    }
    
}
