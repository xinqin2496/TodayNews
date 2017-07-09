//
//  searchCell.swift
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/7.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

import UIKit

class searchCell: UITableViewCell {

    var searchText: String?
    
    var keyword: Keyword? {
        didSet {
            let count = searchText?.characters.count
            let index = keyword!.keyword?.characters.index((keyword!.keyword?.startIndex)!, offsetBy: count!)
            let subString = keyword!.keyword?.substring(from: index!)
            let attributeString = NSMutableAttributedString(string: searchText!, attributes: [NSForegroundColorAttributeName: ZZColor(232, g: 84, b: 85, a: 1.0)])
            let subAttributeString = NSAttributedString(string: subString!)
            attributeString.append(subAttributeString)
            keywordLabel.attributedText = attributeString
        }
    }
    
    @IBOutlet weak var keywordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
