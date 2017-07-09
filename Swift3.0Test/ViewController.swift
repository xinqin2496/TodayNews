//
//  ViewController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/3.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        bulidUI()
        
        self.tableView.yz_headerScaleImage = UIImage(named: "header")
        self.tableView.yz_headerScaleImageHeight = 240
//
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 240))
        headerView.backgroundColor = UIColor.white
    
        let roundView = UIImageView(frame:  CGRect(x: 50, y: 100, width:200, height: 200))
        
        roundView.image = UIImage(named: "header")//?.circleImage()
        
        roundView.tag = 112;
        
        headerView .addSubview(roundView)
        
//        roundView.rotate360DegreeWithImageView(duration: 10,repeatCount: 10)
        
        roundView.addTarget(target: self, action: #selector(ViewController.clickTostopRotate))
            
        self.tableView.tableHeaderView = headerView
        
        _ = "123456".md5()
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickTostopRotate() {
        
        let imageView = self.tableView.tableHeaderView?.viewWithTag(112) as! UIImageView
        
    
//        imageView.stopRotate()
        
        imageView.scaleImageView()
        
        
    }

    func bulidUI() {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        view.addSubview(tableView)
        
        self.tableView = tableView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewNoDataOrNewworkFailGradient(0)
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .default, reuseIdentifier: "cell")

        cell.textLabel?.text = "hello +\(indexPath.section) + \(indexPath.row)"
        
        return cell
    }
    
    
}



