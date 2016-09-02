//
//  AccountDetailTableHeaderView.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/2.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

class AccountDetailTableHeaderView: UIView {
      private let lineView = UIView.init()
      private let moneyAmountLabel = UILabel.init()
      private let circleImageView = UIImageView.init()
      private let dateLabel = UILabel.init()
    
    func setUpDateAndMoneyAmount(date : String, amount : String) {
       self.lineView.frame = CGRectMake(self.bounds.size.width * 0.5 - 0.5, 0, 1, self.bounds.size.height)
       self.lineView.backgroundColor = UIColor.lightGrayColor()
       self.addSubview(lineView)
        
       self.circleImageView.frame = CGRectMake(self.bounds.size.width * 0.5 - 3, self.bounds.size.height * 0.5 - 3, 6, 6)
       self.circleImageView.image = UIImage.init(named: "day_indicator_6x6_")
       self.addSubview(circleImageView)
       
       self.dateLabel.frame = CGRectMake(0,self.bounds.size.height * 0.5 - 10 * KHeightScale, self.bounds.size.width * 0.5 - 20 * KWidthScale, 20 * KHeightScale)
       self.dateLabel.textAlignment = .Right
       self.dateLabel.numberOfLines = 1
       self.dateLabel.textColor = UIColor.lightGrayColor()
       self.dateLabel.font = UIFont.systemFontOfSize(10 * KHeightScale)
       self.dateLabel.text = date
       self.addSubview(dateLabel)
 
       self.moneyAmountLabel.frame = CGRectMake(self.bounds.size.width * 0.5 + 20 * KWidthScale,self.bounds.size.height * 0.5 - 10 * KHeightScale, self.bounds.size.width * 0.5 - 20 * KWidthScale, 20 * KHeightScale)
       self.moneyAmountLabel.textAlignment = .Left
       self.moneyAmountLabel.numberOfLines = 1
       self.moneyAmountLabel.textColor = UIColor.lightGrayColor()
       self.moneyAmountLabel.font = UIFont.systemFontOfSize(10 * KHeightScale)
       self.moneyAmountLabel.text = amount
       self.addSubview(moneyAmountLabel)

        
        
    
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
