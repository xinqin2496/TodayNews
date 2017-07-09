//
//  PopView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/7.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//
//  弹出框
//

import UIKit
import SnapKit

class PopView: UIView {
    
     // MARK: 删除
    var closeInterestButtonClosure : ((_ sender : UIButton ) -> ())?
    
     // MARK: 保存选中的理由
    var selectFilterwords :[FilterWord]?
    
    
    //记录 关闭按钮的坐标 显示对应的箭头
    var closeBtnPoint = CGPoint() {
    
        didSet{
            popArraw.snp.remakeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-(Screen_Width - closeBtnPoint.x - 15))
                make.size.equalTo(CGSize(width: 36, height: 8))
                make.bottom.equalTo(bgView.snp.top).offset(1)
            }
            if (closeBtnPoint.y - (Screen_Height ) / 2 ) > 100  {
              
                interestButton.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(bgView).offset(-13)
                    make.right.equalTo(bgView).offset(-13)
                    make.size.equalTo(CGSize(width: 100, height: 30))
                }
                buttonBGView.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(interestButton.snp.top).offset(-3)
                    make.left.equalTo(bgView.snp.left).offset(0)
                    make.right.equalTo(bgView.snp.right).offset(0)
                    make.top.equalTo(bgView.snp.top)
                }
                popArraw.snp.remakeConstraints { (make) in
                    make.right.equalTo(self.snp.right).offset(-(Screen_Width - closeBtnPoint.x - 15))
                    make.size.equalTo(CGSize(width: 36, height: 8))
                    make.top.equalTo(bgView.snp.bottom).offset(-1)
                }
                popArraw.image = UIImage(named: "arrow_down_popdown_textpage_36x8_")
            }
        }
    }
    
    var filterWords: [FilterWord]? {
        didSet {
            let buttonW: CGFloat = (Screen_Width - 30 - 2 * kMargin ) * 0.5
            let buttonH: CGFloat = 35
            for index in 0..<filterWords!.count {
                let word = filterWords![index]
                let button = UIButton()
                button.tag = index
                button.setTitle(word.name, for: UIControlState())
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                button.setTitleColor(UIColor.black, for: .normal)
                button.layer.borderColor = ZZGlobalColor().cgColor
                button.layer.borderWidth = klineWidth
                button.backgroundColor = ZZGlobalColor()
                button.layer.masksToBounds = true
                button.layer.borderWidth = 1
                button.setTitleColor(ZZGlobalRedColor(), for: .selected)
                button.frame = CGRect(x:CGFloat(index % 2) * (buttonW + 8) + 10 , y: CGFloat(Int(index / 2)) * (buttonH + 8) + 5, width: buttonW, height: buttonH)
                button.addTarget(self, action: #selector(wordButtonClick(_:)), for: .touchUpInside)
                buttonBGView.addSubview(button)
              
            }
        }
    }
    
    func wordButtonClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
            
        button.layer.borderColor = button.isSelected ? ZZGlobalRedColor().cgColor :ZZGlobalColor().cgColor

        if button.isSelected {
            selectFilterwords?.append((filterWords?[button.tag])!)
        }else{
            selectFilterwords?.remove(at: (selectFilterwords?.index(of: (filterWords?[button.tag])!))!)
        }
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        addSubview(popArraw)
        addSubview(bgView)
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(interestButton)
        bgView.addSubview(buttonBGView)
        
        interestButton.addTarget(self, action: #selector(clickInterestButton(_ :)), for: .touchUpInside)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        
        popArraw.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-15)
            make.size.equalTo(CGSize(width: 36, height: 8))
            make.bottom.equalTo(bgView.snp.top).offset(1)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(13)
            make.centerY.equalTo(interestButton)
        }
        
        interestButton.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(13)
            make.right.equalTo(bgView).offset(-13)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        buttonBGView.snp.makeConstraints { (make) in
            make.top.equalTo(interestButton.snp.bottom).offset(3)
            make.left.equalTo(bgView.snp.left).offset(0)
            make.right.equalTo(bgView.snp.right).offset(0)
            make.bottom.equalTo(bgView.snp.bottom)
        }
        
    }
    
    /// 箭头
    fileprivate lazy var popArraw: UIImageView = {
        let popArraw = UIImageView()
        popArraw.image = UIImage(named: "arrow_up_popup_textpage_36x8_")
        return popArraw
    }()
    
    /// 白色 view
    fileprivate lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    /// 可选理由
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "可选理由，精准屏蔽"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    /// 不感兴趣按钮
    fileprivate lazy var interestButton: UIButton = {
        let interestButton = UIButton()
        interestButton.layer.cornerRadius = kHomeMargin
        interestButton.layer.masksToBounds = true
        interestButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        interestButton.setTitle("不喜欢", for: UIControlState())
        interestButton.setTitleColor(UIColor.white, for: UIControlState())
        interestButton.backgroundColor = ZZColor(246, g: 91, b: 93, a: 1.0)
        return interestButton
    }()
    
    /// 放置 6 个按钮的容器 view
    fileprivate lazy var buttonBGView: UIView = {
        let buttonBGView = UIView()
        buttonBGView.backgroundColor = UIColor.clear
        return buttonBGView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickInterestButton(_ sender : UIButton) {

        closeInterestButtonClosure!(sender)
    }
    
    //添加闭包按钮
    func addInterestButtonClickClosure(_ closure: @escaping (_ sender :UIButton ) -> ()) {
        
        closeInterestButtonClosure = closure
    }
}
