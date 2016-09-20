//
//  AccountDetailTableHeaderView.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/2.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit



class AccountDetailTableHeaderView: UITableViewHeaderFooterView {
      private let lineView = UIView.init()
      private let moneyAmountLabel = UILabel.init()
      private let circleImageView = UIImageView.init()
      private let dateLabel = UILabel.init()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        
        self.lineView.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(lineView)
        
        
        self.circleImageView.image = UIImage.init(named: "day_indicator_6x6_")
        self.addSubview(circleImageView)
        
        
        self.dateLabel.textAlignment = .Right
        self.dateLabel.numberOfLines = 1
        self.dateLabel.textColor = UIColor.lightGrayColor()
        self.dateLabel.font = UIFont.systemFontOfSize(KLittleFont)
        
        self.addSubview(dateLabel)
        
       
        self.moneyAmountLabel.textAlignment = .Left
        self.moneyAmountLabel.numberOfLines = 1
        self.moneyAmountLabel.textColor = UIColor.lightGrayColor()
        self.moneyAmountLabel.font = UIFont.systemFontOfSize(KLittleFont)
        
        self.addSubview(moneyAmountLabel)

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setUpDateAndMoneyAmount(date : String, amount : String)
    {
     self.lineView.frame = CGRectMake(self.bounds.size.width * 0.5 - 0.5, 0, 1, self.bounds.size.height)
     self.circleImageView.frame = CGRectMake(self.bounds.size.width * 0.5 - 3, self.bounds.size.height * 0.5 - 3, 6, 6)
     self.dateLabel.frame = CGRectMake(0,self.bounds.size.height * 0.5 - KAccoutTitleMarginToAmount * 0.5, self.bounds.size.width * 0.5 -  KAccoutTitleMarginToAmount,  KAccoutTitleMarginToAmount)
     self.moneyAmountLabel.frame = CGRectMake(self.bounds.size.width * 0.5 +  KAccoutTitleMarginToAmount,self.bounds.size.height * 0.5 - KAccoutTitleMarginToAmount * 0.5, self.bounds.size.width * 0.5 - KAccoutTitleMarginToAmount, KAccoutTitleMarginToAmount)
      self.dateLabel.text = date
      self.moneyAmountLabel.text = amount
        
      if(amount.containsString("-0.00")){
           self.moneyAmountLabel.text = ""
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
