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
    private let tap = UITapGestureRecognizer.init()
    private var tapTime : NSNumber = 0
    private let editButton = UIButton.init(type: .Custom)
    private let deleteButton = UIButton.init(type: .Custom)
    private lazy var editBlock = {(modle:MUAccountDetailModel, isDelete: Bool) in}
    private lazy var refreshMonthBalanceBlock = {() in}
    private lazy var data = MUAccountDetailModel()
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
        
        typeImageView.userInteractionEnabled = true
        typeImageView.exclusiveTouch = true
        self.tap.addTarget(self, action: "tapStartAnimation")
        typeImageView.addGestureRecognizer(self.tap)
        
        editButton.setImage(UIImage.init(named: "item_edit_27x27_"), forState: .Normal)
        deleteButton.setImage(UIImage.init(named: "item_delete_27x27_"), forState: .Normal)
        editButton.addTarget(self, action: "cellEdit", forControlEvents: .TouchUpInside)
        deleteButton.addTarget(self, action: "cellDelete", forControlEvents: .TouchUpInside)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endAnimation:", name: KNotificationCellAnimationEnd, object: nil)
        self.addObserver(self, forKeyPath: "tapTime", options: NSKeyValueObservingOptions.New, context: nil)
        

    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print("tapTime 改变了",change!["new"],change!["old"],self.data.accountTitleName,self.data.moneyAmount)
    }
    override func updateConstraints() {
        super.updateConstraints()
        
        lineView.frame = CGRectMake(self.bounds.size.width * 0.5 - 0.5, 0, 1, self.bounds.size.height)
        lineView.backgroundColor = UIColor.lightGrayColor()
        
        typeImageView.frame = CGRectMake(self.bounds.size.width * 0.5 - KAccountDetailTypeImageViewHeight * 0.5,0.0, KAccountDetailTypeImageViewHeight, KAccountDetailTypeImageViewHeight)
        
        titleLabel.frame = CGRectMake(self.bounds.size.width * 0.5 + KAccountItemWidthMargin, 0, self.bounds.size.width * 0.5 - KAccountItemWidthMargin, 15 * KHeightScale)
        
        tipsLabel.frame = CGRectMake(self.bounds.size.width * 0.5 +  KAccountItemWidthMargin, 15 * KHeightScale, self.bounds.size.width * 0.5 -  KAccountItemWidthMargin, 15 * KHeightScale)
        tipsLabel.textAlignment = .Left
       
        
        tipsImageView.frame = CGRectMake(self.bounds.size.width * 0.5 -   KAccountItemWidthMargin - KAccountDetailTipsImgaeViewHeight,0, KAccountDetailTipsImgaeViewHeight, KAccountDetailTipsImgaeViewHeight)
        
        
        self.addSubview(lineView)
        self.addSubview(typeImageView)
        self.addSubview(tipsLabel)
        self.addSubview(titleLabel)
        self.addSubview(tipsImageView)
        
       
    }
    func setContentData(data : MUAccountDetailModel) {
        self.data = data
        self.updateConstraints()
        self.setNeedsDisplay()
        
        self.tipsLabel.text = data.tipsString
        let money = data.moneyAmount >= 0 ? data.moneyAmount :data.moneyAmount * (-1.0)
        
        titleLabel.textAlignment = .Left
        if(data.moneyAmount > 0.0){
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
        
        self.addSubview(editButton)
        self.addSubview(deleteButton)
       
        self.refreshMonthBalanceBlock()
       
    
        
    }
    private func getAttributeText(text : String) -> NSMutableAttributedString {
        let str = NSMutableAttributedString.init(string: text)
        str.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(KTitleFont), range: NSRange.init(location: 0, length: 2))
        str.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSRange.init(location: 0, length: 2))
        str.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(KLittleFont), range: NSRange.init(location: 4, length: Int(String(text.endIndex))!-4))
        str.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange.init(location: 4, length: Int(String(text.endIndex))!-4))
        return str
    }
    //MARK: TapGesture
    @objc
    private func tapStartAnimation() {
        if self.tapTime.integerValue == 0{
           self.tapTime = NSNumber.init(integer: 1)
        }
    
      var frameLeft = self.typeImageView.frame
      var frameRight = self.typeImageView.frame
       deleteButton.frame = frameLeft
       editButton.frame = frameRight
       
       self.titleLabel.hidden = true
       self.tipsImageView.hidden = true
       self.tipsLabel.hidden = true
       self.deleteButton.hidden = false
       self.editButton.hidden = false
//        if(self.tapTime == 0){
//            self.titleLabel.hidden = false
//            self.tipsImageView.hidden = false
//            self.tipsLabel.hidden = false
//            self.deleteButton.hidden = true
//            self.editButton.hidden = true
//        }else if(self.tapTime == 1){
//            self.titleLabel.hidden = true
//            self.tipsImageView.hidden = true
//            self.tipsLabel.hidden = true
//            self.deleteButton.hidden = false
//            self.editButton.hidden = false
//            print("tap ===",self.tapTime)
//        }
       frameLeft.origin.x = KAccountItemWidthMargin
       frameRight.origin.x = KWidth - KAccountItemWidthMargin - frameLeft.size.width
        
        if self.tapTime.integerValue >= 2 {
        deleteButton.frame = frameLeft
        editButton.frame = frameRight
         UIView.animateWithDuration(NSTimeInterval.init(0.5),animations: { [unowned self]() -> Void in
                self.deleteButton.frame = self.typeImageView.frame
                self.editButton.frame = self.typeImageView.frame
            }, completion: { (isdone:Bool) -> Void in
                //if(isdone == true){
                self.tapTime = 0
                self.titleLabel.hidden = false
                self.tipsImageView.hidden = false
                self.tipsLabel.hidden = false
                self.deleteButton.hidden = true
                self.editButton.hidden = true
                self.deleteButton.frame = CGRectZero
                self.editButton.frame = CGRectZero
               // }
            })
        }else if(self.tapTime == 1){
          UIView.animateWithDuration(NSTimeInterval.init(0.5)) { () -> Void in
               self.deleteButton.frame = frameLeft
               self.editButton.frame = frameRight
               self.tapTime = 2
        }
        }
            
       
    }
    func setCellItmeEditeBlock(block: (data : MUAccountDetailModel,isDelete: Bool) -> Void) {
        self.editBlock = block
    }
    func setRefreshMonthBalanceBlock(block:() ->Void) {
        self.refreshMonthBalanceBlock = block
    }
    @objc
    private func cellEdit() {
      self.editBlock(self.data,false)
    }
    @objc
    private func cellDelete() {
     self.editBlock(self.data,true)
    }
    @objc
    private func endAnimation(noti : NSNotification) {
     if(self.tapTime.integerValue > 0){
       self.tapTime = 2
       self.tapStartAnimation()
      }
    }
    deinit {
      self.removeObserver(self, forKeyPath: KNotificationCellAnimationEnd)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
