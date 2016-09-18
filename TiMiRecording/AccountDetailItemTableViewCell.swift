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
    private let tipsLabel = UILabel.init()
    private let typeImageView = UIImageView.init()
    private let tipsImageView = UIImageView.init()
    private let lineView = UIView.init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        tipsLabel.textColor = UIColor.lightGrayColor()
        tipsLabel.font = UIFont.systemFontOfSize(KLittleFont)
        tipsLabel.numberOfLines = 1
        tipsLabel.textAlignment = .Left
        
        tipsImageView.layer.cornerRadius = 5.0 * KWidthScale
        tipsImageView.clipsToBounds = true
        

    }
    override func updateConstraints() {
        super.updateConstraints()
        
        lineView.frame = CGRectMake(self.bounds.size.width * 0.5 - 0.5, 0, 1, self.bounds.size.height)
        lineView.backgroundColor = UIColor.lightGrayColor()
        
        typeImageView.frame = CGRectMake(self.bounds.size.width * 0.5 - KAccountDetailTypeImageViewHeight * 0.5,0.0, KAccountDetailTypeImageViewHeight, KAccountDetailTypeImageViewHeight)
        
        titleLabel.frame = CGRectMake(self.bounds.size.width * 0.5 + KAccountItemWidthMargin, 0, self.bounds.size.width * 0.5 - KAccountItemWidthMargin, 15 * KHeightScale)
        
        tipsLabel.frame = CGRectMake(self.bounds.size.width * 0.5 +  KAccountItemWidthMargin, 15 * KHeightScale, self.bounds.size.width * 0.5 -  KAccountItemWidthMargin, 15 * KHeightScale)
        
        tipsImageView.frame = CGRectMake(self.bounds.size.width * 0.5 -   KAccountItemWidthMargin - KAccountDetailTipsImgaeViewHeight,0, KAccountDetailTipsImgaeViewHeight, KAccountDetailTipsImgaeViewHeight)
        
        
        self.addSubview(lineView)
        self.addSubview(typeImageView)
        self.addSubview(tipsLabel)
        self.addSubview(titleLabel)
        self.addSubview(tipsImageView)
    }
    func setContentData(data : MUAccountDetailModel) {
        
        self.updateConstraints()
        self.setNeedsDisplay()
        
        self.tipsLabel.text = data.tipsString
        let money = data.moneyAmount < 0 ? data.moneyAmount * (-1.0):data.moneyAmount
        
        titleLabel.textAlignment = .Left
        if(data.moneyAmount < 0.0){
           var titleFrame = self.titleLabel.frame
               titleFrame.origin.x = 0.0
               titleLabel.textAlignment = .Right
               titleLabel.frame = titleFrame
           var tipsFrame = self.tipsLabel.frame
               tipsFrame.origin.x = 0.0
               tipsLabel.frame = tipsFrame
               tipsLabel.textAlignment = .Right
           var tipsImageFrame = self.tipsImageView.frame
               tipsImageFrame.origin.x = self.bounds.size.width * 0.5 + KAccountItemWidthMargin
               tipsImageView.frame = tipsImageFrame
        }
        self.titleLabel.attributedText = self.getAttributeText(String.init(format: "%@  %0.2lf", arguments: [data.accountTitleName,money]))
        self.typeImageView.image = UIImage.init(named: data.thumbnailName)
        self.tipsImageView.image = UIImage.init(named:data.userPictureName)
        
       
    
        
    }
    private func getAttributeText(text : String) -> NSMutableAttributedString {
        let str = NSMutableAttributedString.init(string: text)
        str.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(KTitleFont), range: NSRange.init(location: 0, length: 2))
        str.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSRange.init(location: 0, length: 2))
        str.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(KLittleFont), range: NSRange.init(location: 4, length: Int(String(text.endIndex))!-4))
        str.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange.init(location: 4, length: Int(String(text.endIndex))!-4))
        return str
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
