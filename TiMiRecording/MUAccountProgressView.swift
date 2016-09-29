//
//  MUAccountProgressView.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/28.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

class MUAccountProgressView: UIView {
    var totalAmount : Double = 0.0
    private let totalMoneyLabel = UILabel.init()
    var paymentAmount : Double = 0.0
    var days : Int = 0
    private let tipsLabel = UILabel.init()
    private let progressView = UIView.init()
    var color = UIColor.redColor()
    private var coverViewFrame = CGRectZero
    private let lineView = UIView.init()
    private let shapeLayer = CAShapeLayer.init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        let titleLabel = UILabel.init(frame: CGRectMake(KAccountItemWidthMargin * 0.5, KAccountItemWidthMargin * 0.5, 50 * KWidthScale, KAccountItemWidthMargin))
        titleLabel.font = UIFont.systemFontOfSize(KMiddleFont)
        titleLabel.text = "总预算"
        self.addSubview(titleLabel)
        
        
        self.totalMoneyLabel.font = UIFont.systemFontOfSize(KMiddleFont)
        self.totalMoneyLabel.textAlignment = .Right
        self.addSubview(totalMoneyLabel)
        
       
        self.progressView.layer.cornerRadius = 10.0
        self.progressView.layer.borderWidth = 1.0
        self.progressView.layer.borderColor = UIColor.lightGrayColor().CGColor
        lineView.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(lineView)
        
      
        

       
        
        
        self.addSubview(progressView)
        
        
        
       
        self.tipsLabel.font = UIFont.systemFontOfSize(KMiddleFont)
        
        self.addSubview(tipsLabel)
    }
    func startUI() {
        let money = self.totalAmount > 10000.00 ? String.init(format: "%.2lf万元", arguments: [self.totalAmount/10000.00]) : String.init(format: "%.2lf", arguments: [self.totalAmount])
        
        let width = money.getStringWidth(KAccountItemWidthMargin, size: KMiddleFont)
        let width_ = "总预算".getStringWidth(KAccountItemWidthMargin, size: KMiddleFont)
        self.totalMoneyLabel.frame = CGRectMake(self.bounds.size.width - width - KAccountItemWidthMargin * 0.25, KAccountItemWidthMargin*0.5, width, KAccountItemWidthMargin)
        self.totalMoneyLabel.text = money
        self.progressView.frame = CGRectMake(KAccountItemWidthMargin * 0.75 + width_, KAccountItemWidthMargin*0.5, self.bounds.width - width - KAccountItemWidthMargin*1.25  - width_, KAccountItemWidthMargin)
        coverViewFrame = self.progressView.frame
        coverViewFrame.size.width = self.totalAmount > self.paymentAmount ? CGFloat.init(self.paymentAmount/self.totalAmount) * self.progressView.frame.size.width : self.progressView.frame.width
        if coverViewFrame.size.width < 10.0 {
            coverViewFrame.size.width = 10.0
        }
         lineView.frame = CGRectMake(self.progressView.frame.size.width * 0.9 + self.progressView.frame.origin.x, KAccountItemWidthMargin * 0.25, 1, KAccountItemWidthMargin * 1.5 )
        
        
        
        self.tipsLabel.frame = CGRectMake(self.coverViewFrame.origin.x, KAccountItemWidthMargin * 1.5, self.bounds.size.width - KAccountItemWidthMargin * 2, KAccountItemWidthMargin)
        
        let balance = self.totalAmount - self.paymentAmount > 0 ? self.totalAmount - self.paymentAmount : self.paymentAmount - self.totalAmount
        let perday = balance/Double.init(self.days)
        self.tipsLabel.text = self.totalAmount - self.paymentAmount > 0 ? String.init(format: "还可以支出%.2lf元，日均%.2lf元", arguments: [balance,perday]) :String.init(format: "已经超支%.2lf元", arguments: [balance])
        if self.totalAmount - self.paymentAmount <= 0.0 {
            self.color = UIColor.redColor()
        }
    }
    func startProgressAnimation() {

        shapeLayer.removeFromSuperlayer()
        //绘制
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineWidth = self.coverViewFrame.size.height
        shapeLayer.fillColor = self.color.CGColor
        shapeLayer.strokeColor = self.color.CGColor
        shapeLayer.strokeEnd = 1.0
        shapeLayer.strokeStart = 0.0
        self.layer.addSublayer(shapeLayer)
        
        UIGraphicsBeginImageContext(self.bounds.size)
        let path = UIBezierPath.init()
       path.moveToPoint(CGPointMake(self.coverViewFrame.origin.x + 5.0, self.coverViewFrame.origin.y + self.coverViewFrame.size.height * 0.5))
        path.addLineToPoint(CGPointMake(self.coverViewFrame.origin.x + self.coverViewFrame.size.width - 5.0, self.coverViewFrame.origin.y + self.coverViewFrame.size.height * 0.5))
        path.stroke()
        shapeLayer.path = path.CGPath
        
        //动画
        CATransaction.begin()
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.delegate = self
        shapeLayer.addAnimation(animation, forKey: "progress")
        CATransaction.commit()
        UIGraphicsEndImageContext()

        
        
    
    
    }
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.bringSubviewToFront(self.lineView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }


}
