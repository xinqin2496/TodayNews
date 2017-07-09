//
//  SearchContentViewController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/6.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//
//  显示搜索结果
//

import UIKit

protocol SearchContentViewControllerDelegate: NSObjectProtocol {
    func cancelButtonClickedPopViewcontroller()
}

let searchContentCellID = "searchCell"

class SearchContentViewController: BaseViewController {

    var keywords = [Keyword]()
    
    weak var tableView: UITableView?
    
    weak var delegate: SearchContentViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadRefresh()
        
        
    }
    
    // 设置 UI
    fileprivate func setupUI() {
        searchBar.contentInset = UIEdgeInsets(top: 5.0, left: 8.0, bottom: 5.0, right: 51.0)
        navigationItem.titleView = searchBar
        let tableView = UITableView(frame: view.bounds)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = kMargin
        let nib = UINib(nibName: "searchCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: searchContentCellID)
        view.addSubview(tableView)
        self.tableView = tableView
    }

    func loadRefresh() {
//        NetworkRequest.shareNetworkRequest.loadSearchPromptTitle { (object) in
//            print("搜索提示文字---\(object)")
//        }
    }
    fileprivate lazy var searchBar: IDSearchBar = {
        var searchBar = IDSearchBar()
        searchBar.delegate = self
        searchBar.height = 40
        searchBar.placeholder = "请输入关键字"
        searchBar.showsCancelButton = true
        searchBar.setSearchFieldBackgroundImage(UIImage(named:"background_Introduce_17x17_"), for: UIControlState.normal)
        
        return searchBar
    }()
   
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SearchContentViewController: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        weak var weakSelf = self
        dismiss(animated: false) {
            weakSelf!.delegate?.cancelButtonClickedPopViewcontroller()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchContentCellID) as! searchCell
        cell.searchText = searchBar.text
        cell.keyword = keywords[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text
        NetworkRequest.shareNetworkRequest.loadSearchResult(searchText!) { (keywords) in
            self.keywords = keywords
            self.tableView?.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        NetworkRequest.shareNetworkRequest.loadSearchResult(searchText!) { (keywords) in
            self.keywords = keywords
            self.tableView?.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
}

class Keyword: NSObject {
    var keyword: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        keyword = dict["keyword"] as? String
    }
    
}
