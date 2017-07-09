//
//  HomeJokesCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/8.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeJokesCell: UITableViewCell {

    @IBOutlet weak var goodBtn: UIButton!
    @IBOutlet weak var badBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picImageView: UIImageView!
    
    @IBOutlet weak var jokesView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var jokesButtonClick : (( _ sender:UIButton , _ cell : HomeJokesCell) -> ())?
    
    var jokesImageViewClick : ((_ imageView : UIImageView) -> ())?
    
    var jokesTopic : NewsTopic? {
        didSet {
            
            let reachability = UserDefaults.standard.object(forKey: "reachability") as! String
            let networkMode = UserDefaults.standard.object(forKey: "networkMode") as! String
            
            bottomView.isHidden = false
            if jokesTopic!.label_style! == 5 { //段子
                contentLabel.isHidden = false
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
                
                let attributedString = NSAttributedString(string: jokesTopic!.content! as String, attributes: attributeDict)
                
                contentLabel.attributedText = attributedString
                
                picImageView.isHidden = true
                
            }else if jokesTopic!.label_style! == 7 || jokesTopic!.label_style! == 4 {//美女
                contentLabel.isHidden = true
                let urlString = jokesTopic!.large_image!.url!
                if !(reachability.compare("WWAN").rawValue  == 0  && networkMode.compare("极省流量（不下载图）").rawValue == 0){
                   picImageView.kf.setImage(with:URL(string: urlString)!)
                }else{
                    picImageView.backgroundColor = ZZGlobalColor()
                }
            }
            
            if let diggCount = jokesTopic!.digg_count {
                diggCount >= 10000 ? goodBtn.setTitle("\(diggCount / 10000)万", for:  UIControlState()):goodBtn.setTitle("\(diggCount)", for: UIControlState())
            }
            if let buryCount = jokesTopic!.bury_count {
                buryCount >= 10000 ? badBtn.setTitle("\(buryCount / 10000)万", for:  UIControlState()):badBtn.setTitle("\(buryCount)", for: UIControlState())
            }
            if let commentCount = jokesTopic!.comment_count {
                commentCount >= 10000 ? commentBtn.setTitle("\(commentCount / 10000)万", for:  UIControlState()):commentBtn.setTitle("\(commentCount)", for: UIControlState())
            }

            
          
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //给图片添加手势
        picImageView.addTarget(target: self, action: #selector(clickPickImageView))
    }
    func clickPickImageView() {
        
        jokesImageViewClick?(self.picImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonClick(_ sender: UIButton) {
        
        jokesButtonClick?(sender , self)
    }

    //点击按钮
    func jokesButtonClickClosure( _ closure: @escaping (_ sender : UIButton , _ cell : HomeJokesCell) -> () ) {
    
             jokesButtonClick = closure
      }
      //点击图片
    func jokesImageViewClickClosure(_ closure:@escaping (_ picImageVeiw : UIImageView) -> ()) {
        
        jokesImageViewClick = closure
    }
}
class beautyImageList: NSObject {
    
    var height: Int?
    var width: Int?
    
    var url: String?
    
    var url_list: [[String: AnyObject]]?
    
    init(dict: [String: AnyObject]) {
        super.init()
        height = dict["height"] as? Int
        width = dict["width"] as? Int
        url = dict["url"] as? String
        url_list = dict["url_list"] as? [[String: AnyObject]] ?? [[:]]
    }
}
