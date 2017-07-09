//
//  DetailBottomView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/10.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailBottomView: UIView {
    @IBOutlet weak var editView: UIView!

    @IBOutlet weak var commentCountLb: UILabel!
   
    var selectedShareItem : ((_ sender : UIButton) -> ())?
    
    var clickCommentViewClourse :(() -> ())?
    
    
    var commentCount: Int? {
        didSet {
            // 评论数量
            commentCountLb.text = "\(commentCount!) "
            commentCountLb.isHidden = (commentCount == 0) ? true : false
        }
    }
    
    override func awakeFromNib() {
        commentCountLb.sizeToFit()
        editView.layer.masksToBounds = true
        editView.layer.cornerRadius = 15
        editView.addTarget(target: self, action: #selector(commentViewClickTap))
    }

    //➡️2080-2081-2082
    @IBAction func clickDetaileBottomViewButton(_ sender: Any) {
        
        let button = sender as! UIButton
        if button.tag == 2081{
            
            button.isSelected = !button.isSelected
        }
        else if button.tag == 2082{
            selectedShareItem!(sender as! UIButton)
        }else{
            self.makeToast("正在开发中,敬请期待!")
        }
    }

    func commentViewClickTap() {
        clickCommentViewClourse?()
    }
    //暴露给外面调用 相当于临时的block
    func didSelectedShareItemClickClosure(_ closure : @escaping (_ sender :UIButton) -> () ) {
        
        selectedShareItem = closure
    }
    
    func didSelectedCommViewTapClosure(_ clourse : @escaping () -> ()) {
        clickCommentViewClourse = clourse
    }
}
