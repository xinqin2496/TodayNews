//
//  UILabel+Extension.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/8.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

extension UILabel {
    
    //创建label
    class func creatLabel( textString: String ,  Color : UIColor , Alignment : NSTextAlignment ,  font : UIFont) -> UILabel {
        
        let label = UILabel()
        
        label.text = textString
        label.textColor = Color
        label.textAlignment = Alignment
        label.font = font
        
        return label
    }
    
    //label 自适应文字高度
    func getLineSpaceLabel(frame: CGRect , contentStr:NSString,lineSpace:CGFloat,textLengthSpace:NSNumber,paragraphSpacing:CGFloat ) -> UILabel {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.textAlignment = .left
        
        label.numberOfLines = 0
        
        let attributeDict = self.setTextLineSpace(textStr: contentStr, lineSpace: lineSpace, textLengthSpace: textLengthSpace, paragraphSpacing: paragraphSpacing)
    
        let size = contentStr.boundingRect(with: frame.size, options: .usesLineFragmentOrigin, attributes: attributeDict, context: nil).size
        
        let sizeHeight = size.height
        
        label.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: sizeHeight)
        
        let attributedString = NSAttributedString(string: contentStr as String, attributes: attributeDict)
        
        label.attributedText = attributedString
        
        return label
        
    }
    
    func setTextLineSpace(textStr : NSString ,lineSpace:CGFloat,textLengthSpace:NSNumber,paragraphSpacing:CGFloat ) -> [String : Any] {
        
        let paraStyle = NSMutableParagraphStyle()
        
        paraStyle.lineBreakMode = .byCharWrapping
        
        paraStyle.alignment = .left
        
        paraStyle.lineSpacing = lineSpace
        
        paraStyle.hyphenationFactor = 1.0
        
        paraStyle.firstLineHeadIndent = 0.0
        
        paraStyle.paragraphSpacingBefore = 0.0
        
        paraStyle.headIndent = 0
        
        paraStyle.tailIndent = 0
        
        let dict = [NSFontAttributeName:UIFont.systemFont(ofSize: 14),NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:textLengthSpace]

        return dict
        
    }
}
