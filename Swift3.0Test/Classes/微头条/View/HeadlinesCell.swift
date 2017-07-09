//
//  Headlinesswift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/6/23.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class HeadlinesCell: UITableViewCell {

    ///数据赋值
    var headlinesModel : HeadlinesModel!{
        didSet{
            
            filterWords = headlinesModel.filter_words
            let reachability = UserDefaults.standard.object(forKey: "reachability") as! String
            let networkMode = UserDefaults.standard.object(forKey: "networkMode") as! String
            let model = UserDefaults.standard.object(forKey: userChangedModel)
            if let model1 =  model {
                let isNight = model1 as! Bool
                imgvAvatar.backgroundColor = isNight ? UIColor.gray :ZZGlobalColor()
                labelName.textColor = isNight ? UIColor.gray : UIColor.black
                labelContent.textColor = isNight ? UIColor.gray : UIColor.black
                contentView.backgroundColor = isNight ? UIColor.darkGray : UIColor.white
                backgroundColor = isNight ? UIColor.darkGray :  UIColor.white
                bottomCommentView.backgroundColor = isNight ? UIColor.darkGray :  UIColor.white
                viewSeparator.backgroundColor = isNight ? UIColor.lightGray : ZZColor(244, g: 244, b: 244, a: 1)
            }
            
            if !(reachability.compare("WWAN").rawValue  == 0 && networkMode.compare("极省流量（不下载图）").rawValue == 0) {
                if let urlStr = headlinesModel.avatar_url {
                    imgvAvatar.kf.setImage(with: URL(string:urlStr)!)
                }
            }
           
            if let name = headlinesModel.screen_name {
                labelName.text = name
            }
            ///时间 + 用户描述
            if let time = headlinesModel.behot_time {
                var timeStr =  NSString.changeDateTime(time)
                
                if let desc = headlinesModel.verified_content {
                    timeStr = timeStr.appending("·")
                    timeStr = timeStr.appending(desc)
                }
                labelPubTime.text = timeStr
            }
            
            
            if let content = headlinesModel.content {
                
                labelContent.text = content as String
            }
            
            var moreBtnH : CGFloat = 0.0
            
            if (headlinesModel.shouldShowMoreButton)! { // 如果文字高度超过6行
                
                if (headlinesModel.isOpening)! { // 展开后隐藏
                    moreBtnH = 0
                    labelMore.text = ""
                    cstHeightlbContent?.constant = CGFloat(MAXFLOAT)
                } else {
                    moreBtnH = 20;
                    labelMore.text = "全文"
                    cstHeightlbContent?.constant = MyClassConstants.maxContentLabelHeight;
                }
            }else{
                cstHeightlbContent?.constant = MyClassConstants.maxContentLabelHeight;
            }
            
            //更新“全文”的约束
            cstHeightlbMore?.constant   = moreBtnH;
            
            cstTopPicContainer?.constant = 5;
            
            ///缩略图
            var thumbPicsArray : [String] = NSMutableArray() as! [String]
            
            if headlinesModel.thumb_image_list.count > 0 {
                
                let imageList = headlinesModel!.thumb_image_list
                var imageCount :Int?
                if imageList.count == 5 {
                    imageCount = 4
                }else if imageList.count == 7 || imageList.count == 8{
                    imageCount = 6
                }else if imageList.count > 9{
                    imageCount = 9
                }else{
                    imageCount = imageList.count
                }
                    
                for i in 0..<imageCount! {
                        
                    let listDict = imageList[i]
                        
                    thumbPicsArray.append(listDict.url! )
                }
                
            }
            
            ///大图
            var originalPicsArray : [String] = NSMutableArray() as! [String]
            
            if headlinesModel.large_image_list.count > 0 {
                
                
                let imageList = headlinesModel!.large_image_list
                
                var imageCount :Int?
                if imageList.count == 5 {
                    imageCount = 4
                }else if imageList.count == 7 || imageList.count == 8{
                    imageCount = 6
                }else if imageList.count > 9{
                    imageCount = 9
                }else{
                    imageCount = imageList.count
                }
                for i in 0..<imageCount! {
                        
                    let listDict = imageList[i]
                        
                    originalPicsArray.append(listDict.url! )
                }
            }
            
            ///通过设置缩略图来先确定高度
            var picContainerH :CGFloat?
            
            if thumbPicsArray.count != 0{
                picContainerH = picContainerView.setupPicUrlArray(thumbPicsArray)
               
            }else{
                picContainerH = picContainerView.setupPicUrlArray(originalPicsArray)
                
            }
            cstHeightPicContainer?.constant = picContainerH!;
            
            // 说明是视频
            if headlinesModel.video_duration != nil  && (thumbPicsArray.count == 1 || originalPicsArray.count == 1){
                
                /// 格式化时间
                let minute = Int(headlinesModel!.video_duration! / 60)
                let second = headlinesModel!.video_duration! % 60
                rightBottomLabel.text = String(format: "%02d:%02d", minute, second)
                rightBottomLabel.isHidden =  false
                playButton.isHidden =  false
                
            }else{
                rightBottomLabel.isHidden =  true
                playButton.isHidden =  true
            }
            ///原图
            picContainerView.picOriArray = originalPicsArray
            
            var bottomTop : CGFloat = 0.0
            if thumbPicsArray.count > 0 {
                bottomTop = 10.0
            }
            if originalPicsArray.count > 0 {
                bottomTop = 10.0
            }
            cstTopViewBottom?.constant = bottomTop
            ///评论数
            var commentCount :String?
            if let count = headlinesModel?.comment_count {
              commentCount = count >= 10000 ? "\(count / 10000)万" : "\(count)"
            }else{
                commentCount = "0"
            }
            bottomCommentView.btnComment.setTitle(commentCount, for: .normal)
            
            ///点赞
            var likeCount :String?
            if let count = headlinesModel?.digg_count {
                likeCount = count >= 10000 ? "\(count / 10000)万" : "\(count)"
            }else{
                likeCount = "0"
            }
            bottomCommentView.btnLike.setTitle(likeCount, for: .normal)
            bottomCommentView.btnLike.isSelected = (headlinesModel?.isLike!)! ? true: false;
            ///转发
            var forwardCount :String?
            if let count = headlinesModel?.forward_count {
                if count > 0 {
                   forwardCount = count >= 10000 ? "\(count / 10000)万" : "\(count)"
                }else{
                    forwardCount = "转发"
                }
            }else{
                forwardCount = "转发"
            }
            bottomCommentView.btnShare.setTitle(forwardCount, for: .normal)
            
        }
        
    }
    
    
    /*********************************************************************************/
    ///记录indexpath
    var indexPath : NSIndexPath?
    ///更多展开
    var labelMoreClick:((_ cell : HeadlinesCell) -> ())?
    ///评论框点击事件
    var bottomButtomClick:((_ cell : HeadlinesCell, _ sender : UIButton) -> ())?
    ///图片
    var picImgViewClick : ((_ imageView : UIImageView , _ picOriArray : [String]) -> ())?
    ///关闭
    var closeButtonClick : ((_ sender : UIButton , _ filterwords : [FilterWord]) -> ())?
    ///关闭里面的数据
    var filterWords : [FilterWord]?
    
    //查看全部的约束
    var cstHeightlbMore : NSLayoutConstraint?
    
    //内容的约束
    var cstHeightlbContent : NSLayoutConstraint?
    
    //图片的
    var cstHeightPicContainer : NSLayoutConstraint?
    var cstTopPicContainer : NSLayoutConstraint?
    
    //评论框view的
    var cstTopViewBottom : NSLayoutConstraint?
    
    /*********************************************************************************/
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupUI() {
        contentView.addSubview(imgvAvatar)
        
        imgvAvatar.addTarget(target: self, action: #selector(onAvatar(_ :)))
        
        contentView.addSubview(labelName)
        
        contentView.addSubview(labelPubTime)
        
        contentView.addSubview(focuseButton)
        
        focuseButton.addTarget(self, action: #selector(onFocuse(_ :)), for: .touchUpInside)
        
        contentView.addSubview(labelContent)
        
        contentView.addSubview(labelMore)
        
        labelMore.addTarget(target: self, action: #selector(onMore(_ :)))
        
        contentView.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(closeBtnClick(_ :)), for: .touchUpInside)
        
        contentView.addSubview(picContainerView)
        
        contentView.addSubview(bottomCommentView)
        
        bottomCommentView.headlinesBottomButtonClosure { [weak self](button) in
            self!.bottomButtomClick!(self!,button)
        }
        
        contentView.addSubview(viewSeparator)
        
        imgvAvatar.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.width.height.equalTo(40)
        }
        
        labelName.snp.makeConstraints { (make) in
            make.left.equalTo(imgvAvatar.snp.right).offset(10)
            make.right.equalTo(focuseButton.snp.left).offset(-5)
            make.top.equalTo(10)
            make.height.equalTo(20)
        }
        labelPubTime.snp.makeConstraints { (make) in
            make.left.equalTo(imgvAvatar.snp.right).offset(10)
            make.right.equalTo(focuseButton.snp.left).offset(-5)
            make.top.equalTo(labelName.snp.bottom).offset(0)
            make.height.equalTo(20)
        }
        
        labelPubTime.setContentHuggingPriority(251, for: .horizontal)
        labelPubTime.setContentCompressionResistancePriority(751, for: .horizontal)
        
        closeButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(imgvAvatar.snp.centerY)
            make.size.equalTo(CGSize(width: 30, height: 16))
        }
        
        focuseButton.snp.makeConstraints { (make) in
            make.right.equalTo(closeButton.snp.left).offset(-10)
            make.centerY.equalTo(imgvAvatar.snp.centerY)
            make.height.equalTo(25)
            make.width.equalTo(50)
        }
        //动态添加约束
        cstHeightlbContent = NSLayoutConstraint(item: labelContent, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0)
        
        contentView.addConstraint(cstHeightlbContent!)
        
        labelContent.snp.makeConstraints { (make) in
            make.top.equalTo(imgvAvatar.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(labelMore.snp.top).offset(-5)
        }
        // 不然在6/6plus上就不准确了
        labelContent.preferredMaxLayoutWidth = Screen_Width - 20
        
        cstHeightlbMore = NSLayoutConstraint(item: labelMore, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0)
        
        contentView.addConstraint(cstHeightlbMore!)
        
        labelMore.snp.makeConstraints { (make) in
            make.top.equalTo(labelContent.snp.bottom).offset(5)
            make.left.equalTo(10)
            make.width.equalTo(80)
        }
        
        cstHeightPicContainer = NSLayoutConstraint(item: picContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0)
        
        contentView.addConstraint(cstHeightPicContainer!)
        
        cstTopPicContainer = NSLayoutConstraint(item: picContainerView, attribute: .top, relatedBy: .equal, toItem: labelMore, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        contentView.addConstraint(cstTopPicContainer!)
        
        picContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        picContainerView.setContentHuggingPriority(249, for: .vertical)
        picContainerView.setContentCompressionResistancePriority(749, for: .vertical)
        
        picContainerView.addSubview(rightBottomLabel)
        
        picContainerView.addSubview(playButton)
        
        rightBottomLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 50, height: 20))
            make.right.equalTo(picContainerView.snp.right).offset(-7)
            make.bottom.equalTo(picContainerView.snp.bottom).offset(-5)
        }
        
        playButton.snp.makeConstraints { (make) in
            make.center.equalTo(picContainerView)
        }
        
        picContainerView.picImageViewClosure { [weak self](picImageView , picOriArray) in
            self!.picImgViewClick!(picImageView , picOriArray)
        }
        
        cstTopViewBottom = NSLayoutConstraint(item: bottomCommentView, attribute: .top, relatedBy: .equal, toItem: picContainerView, attribute: .bottom, multiplier: 1.0, constant: 0)
        cstTopViewBottom?.priority = UILayoutPriorityDefaultLow
        contentView.addConstraint(cstTopViewBottom!)
        
        bottomCommentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(34)
        }
        viewSeparator.snp.makeConstraints { (make) in
            make.top.equalTo(bottomCommentView.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(5)
        }
        ///确定 cell上的最后一个view
        hyb_lastViewInCell = viewSeparator
        
       
    }
    ///头像
     lazy var imgvAvatar : UIImageView = {
        
        let imgvAvatar = UIImageView()
        imgvAvatar.backgroundColor = ZZGlobalColor()
        imgvAvatar.layer.cornerRadius = 20
        imgvAvatar.layer.masksToBounds = true
        imgvAvatar.isUserInteractionEnabled = true
       
        return imgvAvatar
    }()

    ///名字
     lazy var labelName : UILabel = {
        
        let labelName = UILabel()
        labelName.font = UIFont.systemFont(ofSize: 14)
        labelName.textColor = UIColor.black
        labelName.textAlignment = .left
        
        return labelName
    }()
    
    ///时间
    fileprivate lazy var labelPubTime : UILabel = {
        
        let labelPubTime = UILabel()
        labelPubTime.font = UIFont.systemFont(ofSize: 13)
        labelPubTime.textColor = UIColor.gray
        labelPubTime.textAlignment = .left
        
        return labelPubTime
    }()
    
    ///关注
    fileprivate lazy var focuseButton : UIButton = {
        
        let focuseButton = UIButton(type: UIButtonType.custom)
        focuseButton.setTitle("关注", for: .normal)
        focuseButton.setTitle("已关注", for: .selected)
        focuseButton.setTitleColor(UIColor.white, for: .normal)
        focuseButton.setTitleColor(UIColor.gray, for: .selected)
        focuseButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        focuseButton.backgroundColor = ZZColor(18, g: 132, b: 255, a: 1)
        focuseButton.layer.masksToBounds = true
        focuseButton.layer.cornerRadius = 2
        return focuseButton
    }()
    
    /// 右下角的 x 按钮
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "add_textpage_17x12_"), for: UIControlState())
        
        return closeButton
    }()
    
    ///内容
    lazy var labelContent : UILabel = {
        
        let labelContent = UILabel()
        labelContent.font = UIFont.systemFont(ofSize: MyClassConstants.contentLabelFontSize)
        labelContent.textColor = UIColor.black
        labelContent.textAlignment = .left
        labelContent.numberOfLines = 0
        return labelContent
    }()
    ///全文按钮
     lazy var labelMore : UILabel = {
        
        let labelMore = UILabel()
        labelMore.font = UIFont.systemFont(ofSize: 14)
        labelMore.textColor = ZZColor(99, g: 184, b: 255, a: 1)
        labelMore.textAlignment = .left
        labelMore.isUserInteractionEnabled = true
        labelMore.text = "全文"
        return labelMore
    }()
    ///图片
    fileprivate lazy var picContainerView : CellPhotoContainer = {
        
        let picContainerView = CellPhotoContainer()
        picContainerView.frameWidth = Screen_Width - 20
        
        return picContainerView
    }()
    
    ///评论
     lazy var bottomCommentView : CellBottomView = {
        
        let bottomCommentView = CellBottomView(frame:CGRect.zero)
        
        return bottomCommentView
    }()
    
    ///分割线
     lazy var viewSeparator : UIView = {
        
        let viewSeparator = UIView()
        viewSeparator.backgroundColor = ZZColor(244, g: 244, b: 244, a: 1)
        return viewSeparator
    }()
    
    /// 中间的播放按钮
    fileprivate lazy var playButton: UIButton = {
        let playButotn = UIButton()
        playButotn.setImage(UIImage(named: "playicon_video_60x60_"), for: UIControlState())
        playButotn.sizeToFit()
        playButotn.isUserInteractionEnabled = false
        playButotn.isHidden = true
        return playButotn
    }()
    
    /// 右下角显示图片数量或视频时长
    lazy var  rightBottomLabel: UILabel = {
        let rightBottomLabel = UILabel()
        rightBottomLabel.textAlignment = .center
        rightBottomLabel.layer.cornerRadius = 10
        rightBottomLabel.layer.masksToBounds = true
        rightBottomLabel.font = UIFont.systemFont(ofSize: 10)
        rightBottomLabel.textColor = UIColor.white
        rightBottomLabel.backgroundColor = ZZColor(0, g: 0, b: 0, a: 0.6)
        rightBottomLabel.isHidden = true
        return rightBottomLabel
    }()
}
extension HeadlinesCell{
    
    ///头像的点击手势
    func onAvatar(_ tap: UITapGestureRecognizer) {
        SVProgressHUD.showSuccess(withStatus: "点击了头像")
    }
    
    ///点击关注
    func onFocuse(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.backgroundColor = ZZColor(250, g: 250, b: 250, a: 1)
            sender.layer.borderColor = ZZGlobalColor().cgColor
            sender.layer.borderWidth = 1
        }else{
            sender.backgroundColor = ZZColor(18, g: 132, b: 255, a: 1)
            sender.layer.borderColor = UIColor.clear.cgColor
            sender.layer.borderWidth = 0
        }
    }
    
    ///点击关闭
    func closeBtnClick(_ sender :UIButton) {
        closeButtonClick!(sender, filterWords!)
    }
    ///点击全文
    func onMore(_ tap: UITapGestureRecognizer) {
        
        labelMoreClick!(self)
    }
    
    /*********************************************************************************/
    /// MARK: 暴露给外界的点击事件
    func didSelectedMoreClosure(_ closure : @escaping (_ cell : HeadlinesCell) -> ()) {
        
        labelMoreClick = closure
    }
 
    /// 点击评论区
    func headlinesCommentButtonClosure(_ closure : @escaping (_ cell :HeadlinesCell, _ sender : UIButton) -> ()) {
        bottomButtomClick = closure
    }
    
    /// 点击评论区
    func picImageViewClickClosure(_ closure:@escaping (_ picImageVeiw : UIImageView ,_ picOriArray : [String]) -> ()) {
        
        picImgViewClick = closure
    }
    
    /// 举报按钮点击回调 父类申明 子类实现
    func closeHeadlinesCellButtonClickClosure(_ closure:@escaping (_ button: UIButton , _ filterWord :[FilterWord] )->() ) {
        
        closeButtonClick = closure
    }
    /*********************************************************************************/
}
