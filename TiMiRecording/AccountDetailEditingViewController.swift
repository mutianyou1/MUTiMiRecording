//
//  AccountDetailEditingViewController.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/2.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit




class AccountDetailEditingViewController: UIViewController ,MUAccountKeyBoardViewDelegate{
    private let incomeButton = UIButton.init(type: .Custom)
    private let paidButton = UIButton.init(type: .Custom)
    private lazy var topView = MUAccountEditTopView.init(frame: CGRectZero)
    private let collectionView = MUAccountEditCollectionView.init(frame: CGRectMake(0, KAccoutTitleMarginToAmount * 1.5 + 30 + 45 * KHeightScale, KWidth, KHeight - KAccoutTitleMarginToAmount * 1.5 - 30 - 45 * KHeightScale - KKeyBoardHeight), collectionViewLayout: UICollectionViewFlowLayout.init())
    private let pageControl = UIPageControl.init()
    private var firstData = MUAccountDetailModel()
    private var currentTime : Double = 0.0
    private var thumbImageViewRect = CGRectZero
    private var thumbImageAniLayer = UIImageView()
    private let keyBoardView = MUAccountKeyBoardView.init(frame: CGRectMake(0, KHeight - KKeyBoardHeight + 10.0, KWidth, KKeyBoardHeight - 10.0))
    var isPayment = true
    var oldData : MUAccountDetailModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.addButtons()
        self.topView = MUAccountEditTopView.init(frame: CGRectMake(0, KAccoutTitleMarginToAmount + 30, KWidth, 45 * KHeightScale))
        self.view.addSubview(topView)

      
       //keyBoardView
        self.view.addSubview(self.keyBoardView)
        self.keyBoardView.delegate = self
        self.keyBoardView.setUpUI(NSDate.init(timeIntervalSinceNow: 0).timeIntervalSince1970,hightlightedMessageButton: false,hightlightedDateButton: false)
        
        
        self.view.addSubview(self.collectionView)
       
      
        //notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeCalendar:", name: KNotificationCurrentTime, object: nil)
        //self.collectionView.backgroundColor =  UIColor.greenColor()
        
        //data load
        self.loadData(ispayment: self.isPayment)
        
        let itemHeightMargin = (self.collectionView.frame.size.height - 3 * KAccountItemHeight) / 2.0
        self.view.addSubview(self.thumbImageAniLayer)
        
        self.collectionView.setCollectionViewBlock { [unowned self](data, layer,row,offSize) -> Void in
            
            if(data.statusCode == MUAccountItemStatus.SHOW_EDIT.rawValue){
                let vc = UIViewController.init()
                vc.view.backgroundColor = KSkyColor
                self.presentViewController(vc, animated: true, completion: nil)
                return
            }
            
          if(data.accountTitleName.containsString("test")){
               let offx = offSize.x + KWidth
                var page = Int.init(offx/KWidth)
            if(offx - CGFloat.init(page) * KWidth > 0){
                page += 1
            }
               
                self.pageControl.currentPage = page - 1
                return
            }
            let animation = CABasicAnimation.init(keyPath: "transform.translation.x")
            let animationY = CABasicAnimation.init(keyPath: "transform.translation.y")
           
            
            var rect = self.thumbImageViewRect
            rect.origin.x -= CGFloat.init(row / KAccountItemNumTrue) * (KAccountItemHeight+KAccountItemWidthMargin)
            rect.origin.x -= layer.frame.origin.x
            rect.origin.x += offSize.x
        
            rect.origin.y += CGFloat.init(row % KAccountItemNumTrue) * (KAccountItemHeight+itemHeightMargin)
            

            
            animation.fromValue = 0.0
            animation.toValue = rect.origin.x
            animationY.fromValue = 0.0
            animationY.toValue = -rect.origin.y
            let groupAnimation = CAAnimationGroup.init()
            groupAnimation.animations = [animation,animationY]
            groupAnimation.delegate = self
            groupAnimation.duration = 0.5
            self.thumbImageAniLayer.image = UIImage.init(named: data.thumbnailName)
            var newRect = CGRectMake(0, 0, layer.frame.size.width, layer.frame.size.height)
            newRect.origin.x = -rect.origin.x
            newRect.origin.x += layer.frame.origin.x
          
            newRect.origin.y = rect.origin.y
            newRect.origin.y += self.thumbImageViewRect.origin.y
           
            self.thumbImageAniLayer.frame = newRect
            self.thumbImageAniLayer.layer.addAnimation(groupAnimation, forKey: "layer")
            self.firstData.moneyAmount = data.moneyAmount
            self.firstData.thumbnailName = data.thumbnailName
            //self.firstData.time = data.time
            //print("move  ---x\(animation.toValue)")
            //print(offSize.x)
        }
    }
    //MARK: edit old data
    func changeNewFirstData(data : MUAccountDetailModel) {
       self.firstData = data.copy() as! MUAccountDetailModel 
       self.oldData = data.copy() as? MUAccountDetailModel
       self.topView.loadData(data)
       self.keyBoardView.setUpUI(data.time, hightlightedMessageButton: !data.tipsString.isEmpty, hightlightedDateButton: true)
    }
    //MARK: Notification
    @objc
    private func closeCalendar(noti : NSNotification){
        let date : NSDate = noti.object as! NSDate
        self.currentTime = date.timeIntervalSince1970
        self.firstData.time = self.currentTime
    }
    //MARK: animation delegate
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.topView.loadData(self.firstData)
        self.collectionView.pagingEnabled = true
        self.thumbImageAniLayer.frame = CGRectZero
        self.keyBoardView.resetAmount()
        
    }
    private func loadData(ispayment ispayment:Bool) {
        dispatch_async(dispatch_get_global_queue(0, 0
            )) { () -> Void in
                self.collectionView.itemArray.removeAllObjects()
                self.collectionView.itemArray.addObjectsFromArray(MUAccountDataManager.manager.getDataFromPlist(ispayment))
                self.firstData = self.collectionView.itemArray.firstObject as! MUAccountDetailModel
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                   
                    self.topView.loadData(self.firstData)
                    self.keyBoardView.resetAmount()
                    self.thumbImageViewRect = self.topView.getThumbnilImageRect()
                    self.collectionView.reloadData()
                    
                    self.pageControl.numberOfPages = self.collectionView.itemArray.count/12
                    if(self.collectionView.itemArray.count % 12 > 0 ){
                       self.pageControl.numberOfPages += 1
                    }
                    self.pageControl.removeFromSuperview()
                    if(self.pageControl.numberOfPages > 1){
                    self.pageControl.frame = CGRectMake(KWidth * 0.5 - 50, KHeight - KKeyBoardHeight , 100, 10.0)
                    self.pageControl.currentPage = 0
                    self.pageControl.currentPageIndicatorTintColor =  KOrangeColor
                    self.pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
                    self.view.addSubview(self.pageControl)
                    }
                }
        }
        
    }
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func incomeOrPaidDataLoad(sender : UIButton){
        if(sender == incomeButton && sender.selected == false) {
            incomeButton.selected = true
            paidButton.selected = false
            self.isPayment = false
            self.loadData(ispayment: false)
        }else if(sender == paidButton && sender.selected == false) {
            paidButton.selected = true
            incomeButton.selected = false
            self.isPayment = true
            self.loadData(ispayment: true)
        }
        
    }
    //MARK: keyboardViewDelegate
    func clickOk() {
        
        var amount = self.keyBoardView.getAmount()
        
      
        if(amount > CGFloat.init(0.0) || self.oldData != nil){
            self.firstData.moneyAmount = Double.init(amount)
            
            if(self.firstData.isPayment){
                amount *= -1.0
                self.firstData.moneyAmount = Double.init(amount)
            }
         
         
            if(self.oldData?.moneyAmount > 0.0){
                let moneyAmount = self.isPayment ?  (self.oldData?.moneyAmount)! * (-1.0) : self.oldData?.moneyAmount
                self.firstData.moneyAmount = amount.isZero ? moneyAmount! : self.firstData.moneyAmount
                
                 
                if(MUFMDBManager.manager.updateData(self.firstData, time: (self.oldData?.time)!, tableName: KAccountCommontTable)){
                  self.successSaveAndDismiss()
                }else{
                  self.saveWithUNKnowError()
                }
            }else{
                
            if(MUFMDBManager.manager.insetData(self.firstData, tableName: KAccountCommontTable)){
               print("插入成功")
               self.successSaveAndDismiss()
            }else{
               self.saveWithUNKnowError()
            }
            }
          
        }else{
              self.saveWithErrorZeroAmount()
        }
    }
    private func successSaveAndDismiss() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(KNotificationAddAccountDetail, object: self.firstData.time)
        })
    }
    //MARK: saveError
    private func saveWithUNKnowError() {
        let controller = MUPromtViewController()
        controller.contentView = MUAlertView.init(frame: CGRectMake(50.0 * KWidthScale , 200 * KHeightScale, KWidth - 100 * KWidthScale, KHeight - 400 * KHeightScale))
        controller.contentView.message = "提示\n数据写入失败请稍后再试！"
        controller.contentView._ViewType = viewType.alertView
        let height = controller.contentView.getHeight() > KHeight * 0.2 ? controller.contentView.getHeight() : KHeight * 0.2
        setWindowType(.alertWindow, rect: CGRectMake(50.0 * KWidthScale , KHeight * 0.5 - height * 0.5, KWidth - 100 * KWidthScale, height), controller:controller)
    }
    //MARK: keyboardViewDelegate
    private func saveWithErrorZeroAmount() {
        let controller = MUPromtViewController()
        controller.contentView = MUAlertView.init(frame: CGRectMake(50.0 * KWidthScale , 200 * KHeightScale, KWidth - 100 * KWidthScale, KHeight - 400 * KHeightScale))
        controller.contentView.message = "提示\n输入金额必须大于0"
        controller.contentView._ViewType = viewType.alertView
        controller.contentView.setBlock({ [unowned self](object) -> Void in
            self.topView.performSelector("shakeAmountLabel", withObject: self.topView, afterDelay: 0.0)
            })
        let height = controller.contentView.getHeight() > KHeight * 0.2 ? controller.contentView.getHeight() : KHeight * 0.2
        setWindowType(.alertWindow, rect: CGRectMake(50.0 * KWidthScale , KHeight * 0.5 - height * 0.5, KWidth - 100 * KWidthScale, height), controller:controller)
    }
    func openCalendar() {
        let controller = MUPromtViewController()
        let rect = CGRectMake(50 * KWidthScale, 100 * KHeightScale, KWidth - 100 * KWidthScale, KHeight - 200 * KHeightScale)
        controller.contentView = MUAlertView.init(frame: rect)
        controller.contentView._ViewType = viewType.calendarView
       controller.contentView.date = NSDate.init(timeIntervalSince1970: self.firstData.time)
        controller.contentView.setBlock {[unowned self] (object) -> Void in
            
            self.keyBoardView.setUpUI(self.firstData.time, hightlightedMessageButton: false, hightlightedDateButton: true)
           
        }
        setWindowType(windowType.alertWindow, rect: rect, controller: controller)
    }
    func startEditMessage() {
        let VC = AccountTipsEditViewController()
         VC.editData = self.firstData.copy() as? MUAccountDetailModel
         VC.setDoneBlock {[unowned self] (userImageName, tips) -> Void in
            self.firstData.tipsString = tips
            self.firstData.userPictureName = userImageName
            
        }
        self.presentViewController(VC, animated: true, completion: nil)
    }
    func addNumberOnKeyBoard(number: String) {
        self.topView.freshAmount(number)
    }
    func clearAll() {
        self.topView.freshAmount("¥0.00")
    }
    //MARK: addButtons
    private func addButtons() {
        let closeButton = UIButton.init(type: .Custom)
        closeButton.frame = CGRectMake(KAccoutTitleMarginToAmount * 0.5, KAccoutTitleMarginToAmount, 18 , 18)
        closeButton.setImage(UIImage.init(named: "btn_item_close_36x36_"), forState: .Normal)
        self.view.addSubview(closeButton)
        closeButton.addTarget(self, action: "close", forControlEvents: .TouchUpInside)
        
       
        incomeButton.setTitle("收入", forState: .Normal)
        incomeButton.titleLabel?.font = UIFont.systemFontOfSize(KBigFont)
        incomeButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        incomeButton.setTitleColor(KOrangeColor, forState: .Selected)
        incomeButton.frame = CGRectMake(KWidth * 0.5 - 80 - KAccoutTitleMarginToAmount * 0.5, KAccoutTitleMarginToAmount, 80, 30)
        incomeButton.addTarget(self, action: "incomeOrPaidDataLoad:", forControlEvents: .TouchUpInside)
        self.view.addSubview(incomeButton)
        
      
        paidButton.setTitle("支出", forState: .Normal)
        paidButton.titleLabel?.font = UIFont.systemFontOfSize(KBigFont)
        paidButton.frame = CGRectMake(KWidth * 0.5 + KAccoutTitleMarginToAmount * 0.5, KAccoutTitleMarginToAmount, 80, 30)
        paidButton.addTarget(self, action: "incomeOrPaidDataLoad:", forControlEvents: .TouchUpInside)
        paidButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        paidButton.setTitleColor(KOrangeColor , forState: .Selected)
        paidButton.selected = self.isPayment
        incomeButton.selected = !self.isPayment
        self.view.addSubview(paidButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
