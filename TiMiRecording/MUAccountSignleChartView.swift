//
//  MUAccountSignleChartView.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/30.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

class MUAccountSignleChartView: UIView {
    var isEmptyChart = false
    var isCurveChart =  true
    var accountTitleName = "无分类"
    var payment : Double = 0.0
    var totalORlastMonthPayment : Double = 1.0
    var color = UIColor.greenColor()
    
    private let compareLabel = UILabel.init(frame: CGRectZero)
    private let standardLayer = CAShapeLayer.init()
    private let compareLayer = CAShapeLayer.init()
    private let titleLabel = UILabel.init(frame: CGRectZero)
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(compareLabel)
        self.addSubview(titleLabel)
        self.titleLabel.textAlignment = .Center
        self.titleLabel.font = UIFont.systemFontOfSize(KLittleFont)
        self.titleLabel.numberOfLines = 0
        self.compareLabel.numberOfLines = 0
        self.compareLayer.lineWidth = 6 * KHeightScale
        self.compareLayer.fillColor = UIColor.clearColor().CGColor
        self.compareLayer.strokeColor = UIColor.redColor().CGColor
        
        self.standardLayer.lineWidth = 6 * KHeightScale
        self.standardLayer.fillColor = UIColor.clearColor().CGColor
        self.standardLayer.strokeColor = UIColor.init(red: 190/255.0, green: 190/255.0, blue: 190/255.0, alpha: 1.0).CGColor
    }
    
    func setUI() {
        if self.isCurveChart == true {
            //rate
            let mark = self.payment / self.totalORlastMonthPayment > 1.0 ? "↑" : "↓"
            let rate = self.payment / self.totalORlastMonthPayment >= 10.0 ? "+999%" :String.init(format: "%.0lf%%", arguments: [fabs(self.payment * 100.0 / self.totalORlastMonthPayment)])
            var compareRate = String.init(format: "对比上月\n%@%@", arguments: [mark,rate])
            if self.isEmptyChart {
                compareRate = "对比上月\n0%"
            }
            let attributedStr = self.getAttributedString(compareRate)
            
            self.compareLabel.frame = CGRectMake(KAccountItemWidthMargin * 0.5, 5 * KHeightScale, self.bounds.size.width - KAccountItemWidthMargin * 0.5, compareRate.getStringHeight(self.bounds.size.width - KAccountItemWidthMargin * 0.5, content: attributedStr))
            self.compareLabel.attributedText = attributedStr
            
            //amount
            let balanceAmount = self.payment - self.totalORlastMonthPayment
            var balanceString = "abc"
            if fabs(balanceAmount) <= 10 {
                balanceString = String.init(format: "%@\n%@", arguments: [self.accountTitleName,"基本持平"])
            }else{
                let isIncrease = balanceAmount > 0 ? "超出":"减少"
                balanceString = String.init(format: "%@%@\n%.2lf元", arguments: [self.accountTitleName,isIncrease,fabs(balanceAmount)])
            }
            if self.isEmptyChart {
               balanceString = "无分类\n0.00元"
            }
            self.titleLabel.text = balanceString
            
            let titleLabelHeigth = balanceString.getStringHeight(self.bounds.size.width, size: KLittleFont)
            self.titleLabel.frame = CGRectMake(0, self.bounds.size.height - titleLabelHeigth -  5 * KHeightScale, self.bounds.size.width, titleLabelHeigth)
            
            self.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.layer.borderWidth = 0.5
            
            
            
            
        }else {
        
           self.compareLabel.frame = CGRectMake(0, self.bounds.size.height * 0.5 - KAccountItemWidthMargin * 0.5, self.bounds.size.width, KAccountItemWidthMargin)
           var compareRate = self.payment * 100.00  / self.totalORlastMonthPayment
           if compareRate.isNaN {
               compareRate = 0.0
            }
            if compareRate > 100.0 {
               compareRate = 100.0
            }
          self.compareLabel.textAlignment = .Center
          self.compareLabel.font = UIFont.systemFontOfSize(KLittleFont)
            
          self.compareLabel.text = String.init(format: "%.0lf%%", arguments: [compareRate])
          self.titleLabel.text = self.accountTitleName
          self.titleLabel.frame = CGRectMake(0, self.bounds.size.height - KAccountItemWidthMargin, self.bounds.size.width, KAccountItemWidthMargin)
          self.layer.borderWidth = 0.0
        }
    }
   
    func startAnimtaion() {
      
        self.standardLayer.removeFromSuperlayer()
        self.compareLayer.removeFromSuperlayer()
        
        let bezierPath = UIBezierPath.init()
        let comparePath = UIBezierPath.init()
        self.layer.addSublayer(standardLayer)
        self.layer.addSublayer(compareLayer)
        
        UIGraphicsBeginImageContext(self.bounds.size)
        CATransaction.begin()
        if self.isCurveChart == true{
            //standard
        
        }else{
           //standard
          var rate = self.payment / self.totalORlastMonthPayment
          if rate.isNaN {
              rate = 0.0
          }
          if rate > 1.0 {
              rate = 1.0
          }
          let center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5)
          bezierPath.addArcWithCenter(center, radius: 30 * KHeightScale, startAngle: CGFloat.init(M_PI * -0.5), endAngle: CGFloat.init( M_PI  * 1.5 ), clockwise: true)
          standardLayer.path = bezierPath.CGPath
          bezierPath.stroke()
          
         //compare
         comparePath.addArcWithCenter(center, radius: 30 * KHeightScale, startAngle: CGFloat.init(M_PI * -0.5 ), endAngle: CGFloat.init((rate - 0.25) * M_PI * 2), clockwise: true)
         compareLayer.path = comparePath.CGPath
         bezierPath.stroke()
        
         let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        compareLayer.addAnimation(animation, forKey: "circle")
        CATransaction.commit()
          
           
        
        }
       UIGraphicsEndImageContext()
        
    }
    private func getAttributedString(text : String) -> NSAttributedString {
        let attributeStr = NSMutableAttributedString.init(string: text)
        
        attributeStr.addAttribute(NSFontAttributeName, value:UIFont.systemFontOfSize(KLittleFont) , range: NSRange.init(location: 0, length: attributeStr.length))
        attributeStr.addAttribute(NSForegroundColorAttributeName, value:UIColor.lightGrayColor() , range: NSRange.init(location: 0, length: 5))
        attributeStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange.init(location: 4, length: attributeStr.length - 5))
        return attributeStr
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
