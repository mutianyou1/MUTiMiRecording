//
//  TopBackgroundImageView.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/1.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit


public protocol TopBackgroundImageViewDelegate : NSObjectProtocol{
     func openCarmera()
     func presentAccountDetailEditingViewController()
}
class TopBackgroundImageView: UIView {
    private let backImageView = UIImageView.init()
    private let balanceButton = UIButton(type:.Custom)
    private let accountTitleButton = UIButton(type: .Custom)
    private let carmeraButto = UIButton(type: .Custom)
    private let accountAddButton = UIButton(type: .Custom)
    private let monthIncomeLabel = UILabel.init()
    private let monthPaymentLabel = UILabel.init()
    private let placeHolderView = UIView.init()
    
    //delegate
    weak var delegate : TopBackgroundImageViewDelegate?
    var backImageName :String {
        get{
          return "imageName"
        }
        set{
           self.backImageView.image = UIImage(named: newValue)

        }
    }
    func configSubViews(){
        self.backImageView.frame = CGRectMake(0, 0, KWidth, self.bounds.size.height - KMiddleViewAddButtonHeight * KHeightScale * 0.5)
        self.addSubview(self.backImageView)
        
        self.balanceButton.frame = CGRectMake(self.bounds.size.width*0.5 - 70.0, 20 * KHeightScale, 140.0, 30)
        self.balanceButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.balanceButton.backgroundColor = UIColor.clearColor()
        self.balanceButton.layer.cornerRadius = 10.0
        self.balanceButton.layer.borderWidth = 1.0
        self.balanceButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.balanceButton.setTitle("余额78000元", forState: .Normal)
        self.balanceButton.titleLabel?.font = UIFont.systemFontOfSize(12.0 * KHeightScale)
        self.addSubview(balanceButton)
        self.balanceButton.addTarget(self, action: "changeTitle:", forControlEvents: .TouchUpInside)

        self.accountTitleButton.frame = CGRectMake(self.bounds.size.width*0.5 - 30.0, 20 * KHeightScale, 60.0, 30)
        self.accountTitleButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.accountTitleButton.layer.cornerRadius = 10.0
        self.accountTitleButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.accountTitleButton.layer.borderWidth = 1.0
        self.accountTitleButton.setTitle("日常账本", forState: .Normal)
        self.accountTitleButton.titleLabel?.font = UIFont.systemFontOfSize(12.0 * KHeightScale)
        self.addSubview(accountTitleButton)
        self.accountTitleButton.addTarget(self, action: "changeTitle:", forControlEvents: .TouchUpInside)
        self.accountTitleButton.hidden = true
        
        
        self.carmeraButto.frame = CGRectMake(self.bounds.size.width - 40.0, 20 * KHeightScale, 30, 30)
        self.carmeraButto.setBackgroundImage(UIImage.init(named: "btn_camera_additem_44x44_"), forState: .Normal)
        self.addSubview(self.carmeraButto)
        self.carmeraButto.addTarget(self, action: "openCarmera", forControlEvents: .TouchUpInside)
        
        self.monthIncomeLabel.text = "当月收入\n20000.0"
        self.monthIncomeLabel.numberOfLines = 0
        self.monthIncomeLabel.frame = CGRectMake(30.0,self.bounds.size.height - KMiddleViewAddButtonHeight * KHeightScale * 0.5, 100, 50 * KHeightScale)
        self.monthIncomeLabel.textColor = UIColor.lightGrayColor()
        self.monthIncomeLabel.textAlignment = .Left
        self.monthIncomeLabel.font = UIFont.systemFontOfSize(12 * KHeightScale)
        self.addSubview(self.monthIncomeLabel)
        
        self.monthPaymentLabel.text = "当月支出\n2000.00"
        self.monthPaymentLabel.numberOfLines = 0
        self.monthPaymentLabel.frame = CGRectMake(self.bounds.size.width - 130, self.bounds.size.height - KMiddleViewAddButtonHeight * KHeightScale * 0.5, 100, 50 * KHeightScale)
        self.monthPaymentLabel.textColor = UIColor.lightGrayColor()
        self.monthPaymentLabel.textAlignment = NSTextAlignment.Right
        self.monthPaymentLabel.font = UIFont.systemFontOfSize(12 * KHeightScale)
        self.addSubview(monthPaymentLabel)
        
        
         placeHolderView.frame = CGRectMake(self.bounds.size.width * 0.5 - KMiddleViewAddButtonHeight * 0.5 * KHeightScale, self.bounds.size.height - KMiddleViewAddButtonHeight * KHeightScale, KMiddleViewAddButtonHeight * KHeightScale , KMiddleViewAddButtonHeight * KHeightScale)
        placeHolderView.backgroundColor = UIColor.whiteColor()
        placeHolderView.layer.cornerRadius = KMiddleViewAddButtonHeight * 0.5 * KHeightScale
        self.addSubview(placeHolderView)
        
        self.accountAddButton.frame = CGRectMake(self.bounds.size.width * 0.5 - KMiddleViewAddButtonHeight * KHeightScale * 0.5 + 2.0, self.bounds.size.height - KMiddleViewAddButtonHeight * KHeightScale  + 2, KMiddleViewAddButtonHeight * KHeightScale - 4, KMiddleViewAddButtonHeight * KHeightScale - 4)
        self.accountAddButton.layer.cornerRadius =
            KMiddleViewAddButtonHeight * KHeightScale * 0.5 - 2.0
        self.accountAddButton.setBackgroundImage(UIImage(named: "type_add_48x48_"), forState: .Normal)
        self.accountAddButton.addTarget(self, action: "addAccountDetails", forControlEvents: .TouchUpInside)
        //138 204 168
        self.accountAddButton.layer.borderColor = UIColor(red: 138 / 255.0, green: 204 / 255.0, blue: 168 / 255.0, alpha: 1.0).CGColor
        self.accountAddButton.layer.borderWidth = 3
        self.addSubview(accountAddButton)
        
    }
    //MARK: btn method
    func openCarmera() {
        self.delegate?.openCarmera()
    }
    func changeTitle(sender:UIButton) {
        if(sender == accountTitleButton){
           self.balanceButton.hidden = false
        }else{
           self.accountTitleButton.hidden = false
        }
        sender.hidden = true
    }
    func addAccountDetails() {
       
      let trasnfrom = CGAffineTransformMakeRotation(CGFloat.init(M_PI_4 * 2 + M_PI * 2 ))
      UIView.animateWithDuration(0.2, animations: { () -> Void in
           self.accountAddButton.transform = trasnfrom
        }) { (isdone : Bool) -> Void in
            self.accountAddButton.transform = CGAffineTransformIdentity
            self.delegate?.presentAccountDetailEditingViewController()
        }


    }
    func animatiedAddButton(scale : CGFloat) {
        
        if (scale > 0.91){
           return
        }
        let trasnfrom = CGAffineTransformMakeRotation(CGFloat.init(M_PI_4 * 2) + CGFloat.init(M_PI * 3 / 2) * scale )
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.accountAddButton.transform = trasnfrom
            }) { (isdone : Bool) -> Void in
                
                
                if(scale > 0.9 && isdone){
                self.accountAddButton.transform = CGAffineTransformIdentity
                self.delegate?.presentAccountDetailEditingViewController()
                }
        }
    }
    func resetAccountAddButtonTrasnform() {
         UIView.animateWithDuration(0.2) { () -> Void in
             self.accountAddButton.transform = CGAffineTransformIdentity
        }
        
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    // Only override drawRect: if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        // Drawing code
//    }
    

}
