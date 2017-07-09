//
//  CommentView.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/28.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class CommentView: UIView {

    ///输入文字的block
    fileprivate var eventTextViewClosure :((_ text: String) -> ())?

    ///设置占位符
    var placeholderText : String?{
        didSet{
            self.placeholderLabel.text = placeholderText
        }
    }
    
    var showResponder : Bool? {
        didSet{
            if showResponder! {
                self.textView.becomeFirstResponder()
            }else{
                self.textView.resignFirstResponder()
            }
        }
    }
    
    
    var ID : String?
    
    //当文字大于限定高度之后的状态
    var statusTextView : Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
 
        addTapGesture()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///设置UI
    func setupUI() {
        addSubview(backGroundView)
        
        backGroundView.addSubview(lineView)
        
        backGroundView.addSubview(textView)
        
        backGroundView.addSubview(placeholderLabel)
        
        backGroundView.addSubview(sendButton)
        
        backGroundView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(50)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(0.8)
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(15)
            make.bottom.equalTo(-10)
            make.width.equalTo(Screen_Width - 80)
        }
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(4)
            make.left.equalTo(40)
            make.height.equalTo(39)
        }
        sendButton.snp.makeConstraints { [weak self](make) in
            make.centerY.equalTo(self!.textView)
            make.right.equalTo(-5)
            make.width.equalTo(50)
        }
        
    }
    
    ///点击空白取消的手势
    func addTapGesture() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        addGestureRecognizer(tap)
    }
    func tapClick() {
        self.textView.resignFirstResponder()
        endEditing(true)
    }

    //背景view
    fileprivate lazy var backGroundView : UIView = {
        
        let backGroundView = UIView()
        
        backGroundView.backgroundColor = UIColor.white
        
        return backGroundView
    }()
    //lineView
    fileprivate lazy var lineView : UIView = {
        
        let lineView = UIView()
        lineView.backgroundColor = ZZColor(241, g: 241, b: 241, a: 1)
        
        return lineView
    }()
    
    //textView
    fileprivate lazy var textView : UITextView = {
        
        let textView = UITextView()
        
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.black
        textView.delegate = self
        textView.layer.cornerRadius = 15
        textView.backgroundColor = ZZColor(244, g: 245, b: 247, a: 1.0)
        textView.textContainerInset = UIEdgeInsetsMake(8, 10, 4, 10)
        textView.textAlignment = .left
        return textView
    }()
    
    //占位label
    fileprivate lazy var placeholderLabel : UILabel = {
        
        let placeholderLabel = UILabel()
        placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        placeholderLabel.textColor = UIColor.gray
        placeholderLabel.textAlignment = .left
        placeholderLabel.text = "抢沙发~"
        return placeholderLabel
    }()
    
    //发送button
    fileprivate lazy var sendButton : UIButton = {
        
        let sendButton = UIButton(type: UIButtonType.custom)
        sendButton.setTitle("发布", for: .normal)
        sendButton.setTitleColor(UIColor.black, for: .normal)
        sendButton.setTitleColor(ZZColor(202, g: 202, b: 202, a: 1.0) , for: .disabled)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendButton.addTarget(self, action: #selector(sendClick), for: .touchUpInside)
        sendButton.isEnabled = false
        return sendButton
    }()
    
    //点击发送
    func sendClick() {
        endEditing(true)
        textView.resignFirstResponder()
        textView.endEditing(true)
        eventTextViewClosure!(textView.text)
        
        textView.text = ""
        placeholderLabel.text = placeholderText
        sendButton.isEnabled = false
        backGroundView.snp.remakeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(50)
        }
    }
  
    ///暴露给外界的方法
    func clikSendButtonClourse(_ closure : @escaping (_ text :String) -> () ) {
        
        eventTextViewClosure = closure
    }
    
}
extension CommentView : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count == 0 {
            placeholderLabel.text = placeholderText
            sendButton.isEnabled = false
        }else{
            placeholderLabel.text = ""
            sendButton.isEnabled = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //限制字数
        let existedlength = textView.text.characters.count
        let selectedlength = range.length
        let replacelength = text.characters.count
        if existedlength - selectedlength + replacelength > 140 {
            return false
        }
        return true
    }
}



