//
//  AccountDetailItemTableViewCell.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/2.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit



class AccountDetailItemTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel.init()
    private let amontLabel = UILabel.init()
    private let tipsLabel = UILabel.init()
    private let typeImageView = UIImageView.init()
    private let tipsImageView = UIImageView.init()
    private let lineView = UIView.init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        lineView.frame = CGRectMake(self.bounds.size.width * 0.5 - 0.5, 0, 1, self.bounds.size.height)
        lineView.backgroundColor = UIColor.lightGrayColor()
        
        typeImageView.frame = CGRectMake(self.bounds.size.width * 0.5 - KAccountDetailTypeImageViewHeight * 0.5, self.bounds.size.height * 0.5 - KAccountDetailTypeImageViewHeight * 0.5, KAccountDetailTypeImageViewHeight, KAccountDetailTypeImageViewHeight)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
