//
//  LoginOrRegisterController.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/4.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class LoginOrRegisterController: UIViewController {


    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var bgView: UIView!
    //手机号view
    @IBOutlet weak var phoneView: UIView!
    //验证码view
    @IBOutlet weak var codeView: UIView!
    //中间提示
    @IBOutlet weak var toastLb: UILabel!
    //进入头条
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwdTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    //中间提示
    @IBOutlet weak var centoastLb: UILabel!
    //手机号右边的按钮view
    @IBOutlet weak var codeButtonView: UIView!
    //验证码右边的按钮view
    @IBOutlet weak var passwdButtonView: UIView!
    @IBOutlet weak var passwdLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupUI()
        
        //添加手势 dismiss
        addDismissGesture()
        
        //手势
        let model = UserDefaults.standard.object(forKey: userChangedModel)
        if let model1 = model {
            let isNight = model1 as! Bool
            view.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            bottomView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            bgView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            phoneView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            codeView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            codeButtonView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
            passwdButtonView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
        }
    }
    ///初始样式
    func setupUI() {
        
        loginButton.layer.borderColor = ZZColor(246, g: 68, b: 65, a: 1.0).cgColor
        loginButton.layer.borderWidth = klineWidth
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 20
        
        phoneView.layer.borderColor = UIColor.lightGray.cgColor
        phoneView.layer.borderWidth = klineWidth
        phoneView.layer.masksToBounds = true
        phoneView.layer.cornerRadius = 20
        
        codeView.layer.borderColor = UIColor.lightGray.cgColor
        codeView.layer.borderWidth = klineWidth
        codeView.layer.masksToBounds = true
        codeView.layer.cornerRadius = 20
        
        passwdButtonView.isHidden = true
        toastLb.isHidden = true
        
        phoneTF.delegate = self
        passwdTF.delegate = self
        
        loginButton.isEnabled = false
        loginButton.backgroundColor = ZZColor(255, g: 124, b: 117, a: 1.0)
        
        phoneTF.addTarget(self, action: #selector(textWithText(_ :)), for: UIControlEvents.editingChanged)
        passwdTF.addTarget(self, action: #selector(textWithText(_ :)), for: UIControlEvents.editingChanged)
    }
    
    func addDismissGesture() {
        
        //下划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_ :)))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeLeftGesture)
    }
  
    //划动手势
    func handleSwipeGesture(_ sender: UISwipeGestureRecognizer){
        //划动的方向
        let direction = sender.direction
        //判断是上下左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.left:
            print("Left")
            break
        case UISwipeGestureRecognizerDirection.right:
            print("Right")
            break
        case UISwipeGestureRecognizerDirection.up:
            print("Up")
            break
        case UISwipeGestureRecognizerDirection.down:
            print("Down")
            UIView.animate(withDuration: 0.5, animations:{}, completion: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
            
            
            break
        default:
            break;
        }
    }
    ///文本输入实时监控
    func textWithText(_ textFiled :UITextField) {
  
        enableLoginBtn()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickDismissButton(_ sender: UIButton) {
        
        dismiss(animated: true) { 
            
        }
    }
    //账号密码登录
    @IBAction func loginAcountPasswdButton(_ sender: UIButton){
        view.endEditing(true)
        
        passwdTF.text = ""
        enableLoginBtn()
    
        codeView.layer.borderColor = UIColor.lightGray.cgColor
        codeView.layer.borderWidth = klineWidth
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            titleLb.text = "账号密码登录"
            passwdTF.placeholder = "密码"
            codeButtonView.isHidden = true
            centoastLb.isHidden = true
            sender.titleLabel?.text = "免密码登录"
            passwdButtonView.isHidden = false
            toastLb.isHidden = true
        }else{
            titleLb.text = "登录你的头条,精彩永不丢失"
            passwdTF.placeholder = "请输入验证码"
            codeButtonView.isHidden = false
            centoastLb.isHidden = false
            sender.titleLabel?.text = "账号密码登录"
            passwdButtonView.isHidden = true
            toastLb.isHidden = true
        }
        
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        view.endEditing(true)
         view.makeToast("点击了登录")
    }
    

    
    @IBAction func RRButtonClick(_ sender: UIButton) {
        
        view.makeToast("人人登录")
    }
    
    @IBAction func wechatButtonClick(_ sender: UIButton) {
        
         view.makeToast("微信登录")
    }
    
    @IBAction func QQButtonClick(_ sender: UIButton) {
       
         view.makeToast("QQ登录")
    }
    
    @IBAction func weiboButtonClick(_ sender: UIButton) {
     
         view.makeToast("新浪微博登录")
    }
    
    @IBAction func tencentWeiboBUttonClick(_ sender: UIButton) {
         view.makeToast("腾讯微博登录")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func enableLoginBtn() {
        if (phoneTF.text?.characters.count)! == 11 && (passwdTF.text?.characters.count)! >= 4 {
            
            self.loginButton.isEnabled = true
            loginButton.backgroundColor = ZZGlobalRedColor()
            
        }else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = ZZColor(255, g: 124, b: 117, a: 1.0)
        }
    }

}

extension LoginOrRegisterController:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneTF {
            phoneView.layer.borderColor = ZZGlobalRedColor().cgColor
            phoneView.layer.borderWidth = klineWidth
        }else{
            codeView.layer.borderColor = ZZGlobalRedColor().cgColor
            codeView.layer.borderWidth = klineWidth
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.enableLoginBtn()
        if textField == phoneTF {
            if (phoneTF.text?.characters.count)! < 11 {
                toastLb.isHidden = false
            }
        }
    }
    
}
