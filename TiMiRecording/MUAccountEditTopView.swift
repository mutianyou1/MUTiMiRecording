//
//  MUAccountEditTopView.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/5.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

class MUAccountEditTopView: UIView {
    private let thumbImageView = UIImageView.init()
    private let titleLabel = UILabel.init()
    private let amontLabel = UILabel.init()
    private let layerColorView = UIView.init()
    
    override  init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(layerColorView)
        
        self.thumbImageView.frame = CGRectMake(KAccoutTitleMarginToAmount * 0.5, 5, self.bounds.size.height - 10 * KHeightScale, self.bounds.size.height - 10 * KHeightScale)
        self.addSubview(thumbImageView)
        
        
        self.titleLabel.frame = CGRectMake(self.thumbImageView.frame.size.width + KAccoutTitleMarginToAmount, self.bounds.size.height*0.5 - KAccoutTitleMarginToAmount * 0.5, 60, KAccoutTitleMarginToAmount)
        self.titleLabel.font = UIFont.systemFontOfSize(KTitleFont)
        self.titleLabel.textColor =  UIColor.whiteColor()
        self.titleLabel.textAlignment = .Left
        self.addSubview(titleLabel)
        
        self.amontLabel.frame = CGRectMake(self.titleLabel.frame.width + self.titleLabel.frame.origin.x, self.bounds.size.height * 0.5 - KAccoutTitleMarginToAmount * 0.5, self.bounds.size.width - self.titleLabel.frame.width - self.titleLabel.frame.origin.x, KAccoutTitleMarginToAmount)
        self.amontLabel.textAlignment = .Right
        self.amontLabel.font = UIFont.systemFontOfSize(KTitleFont)
        self.amontLabel.textColor = UIColor.whiteColor()
        self.addSubview(amontLabel)
    }
    func loadData(data :  MUAccountDetailModel) {
         self.titleLabel.text = data.accountTitleName
         self.thumbImageView.image = UIImage.init(named: data.thumbnailName)
         self.amontLabel.text = data.moneyAmount
         self.freshViewColor()
    }
    func getThumbnilImageRect() -> CGRect {
       return CGRectMake(self.thumbImageView.frame.origin.x, self.thumbImageView.frame.origin.y + self.frame.origin.y, self.thumbImageView.frame.size.width, self.thumbImageView.frame.size.height)
    }
    private  func freshViewColor() {
        self.layerColorView.frame = CGRectMake(0, 0, 0, self.bounds.size.height)
        let color = self.getItemImageColor()
        self.layerColorView.backgroundColor = color
        
       let keyAnimation = CABasicAnimation.init(keyPath: "bounds")
       keyAnimation.fromValue = NSValue.init(CGRect: CGRectMake(0, 0, 0, self.bounds.size.height))
       keyAnimation.toValue = NSValue.init(CGRect: CGRectMake(0, 0, self.bounds.size.width * 2.0, self.bounds.size.height))
       keyAnimation.cumulative = false
       keyAnimation.delegate = self
       keyAnimation.duration = 1.0
       self.layerColorView.layer.addAnimation(keyAnimation, forKey: "backgroundColor")
       
        
    }
    func freshAmount(amont : String) {
      self.amontLabel.text = amont
    }
    func shakeAmountLabel() {
       let keyAnimation = CAKeyframeAnimation.init(keyPath: "transform.translation.x")
          keyAnimation.values = [-10,-5,0,5,10]
          keyAnimation.duration = 0.1
          keyAnimation.repeatCount = 2
          keyAnimation.removedOnCompletion = true
       self.amontLabel.layer.addAnimation(keyAnimation, forKey: "transformX")
    }
    private func getItemImageColor() -> UIColor{
        if(self.thumbImageView.image != nil){
        let pixeData = CGDataProviderCopyData(CGImageGetDataProvider(self.thumbImageView.image!.CGImage))
        let data :UnsafePointer<UInt8> = CFDataGetBytePtr(pixeData)
        let pixeInfo : Int = ((Int(self.bounds.size.width) * Int(5)) + Int(15)) * 4
            return UIColor.init(red: CGFloat.init(data[pixeInfo])/255.0, green: CGFloat.init(data[pixeInfo+1])/255.0, blue: CGFloat.init(data[pixeInfo+2])/255.0, alpha: CGFloat.init(data[pixeInfo+3])/255.0)}
        return UIColor.whiteColor()
    }
    //MARK: animationDelegate
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.backgroundColor = self.layerColorView.backgroundColor
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
