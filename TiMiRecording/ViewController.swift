//
//  ViewController.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/8/31.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit



class ViewController: UIViewController,TopBackgroundImageViewDelegate{
    private let topView = TopBackgroundImageView()
    private lazy var detailItemTableView = AccountDetailItemTableView.init(frame: CGRectMake(0, 300 * KHeightScale, KWidth, KHeight - 300 * KHeightScale), style: .Plain)
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.topView.frame = CGRectMake(0, 0, KWidth, 300 * KHeightScale)
        self.topView.backImageName = "background7_375x155_"
        topView.delegate = self
       
        self.view.addSubview(topView)
        topView.configSubViews()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidAddAccountDetail", name: KNotificationAddAccountDetail, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTopViewMonthBalance:", name: KNotificationCellRefreshMonthBalance, object: nil)
        self.setUpTabelView()

        
        
     
    }
    private func setUpTabelView() {

      self.view.addSubview(self.detailItemTableView)
      self.detailItemTableView.setSpringAnimationBlock {[unowned self] (height) -> Void in
        if height > 0.0 {
            self.topView.animatiedAddButton(height/CGFloat.init(110.0))
        }else{
            self.topView.resetAccountAddButtonTrasnform()
        }
        }
     self.detailItemTableView.setCellItmeEditeBlock {[unowned self] (data, isDelete) -> Void in
        if(isDelete){
            let controller = MUPromtViewController()
            controller.contentView = MUAlertView.init(frame: CGRectMake(50.0 * KWidthScale , 200 * KHeightScale, KWidth - 100 * KWidthScale, KHeight - 400 * KHeightScale))
            controller.contentView.message = "提示\n是否删除该条数据！"
            controller.contentView._ViewType = viewType.alertView
            controller.contentView.ShowCancelButton = true
            let height = controller.contentView.getHeight() > KHeight * 0.2 ? controller.contentView.getHeight() : KHeight * 0.2
            controller.contentView.setBlock({[unowned self] (object) -> Void in
                let str = object as? String
                if(str!.containsString("YES")){
                    NSNotificationCenter.defaultCenter().postNotificationName(KNotificationCellAnimationEnd, object: nil)
                    
                    
                    MUFMDBManager.manager.removeData(data, tableName: KAccountCommontTable)
                    //NSThread.sleepForTimeInterval(1.0)
                    self.userDidAddAccountDetail()
                }else{
                 NSNotificationCenter.defaultCenter().postNotificationName(KNotificationCellAnimationEnd, object: nil)
                }
            })
        setWindowType(.alertWindow, rect: CGRectMake(50.0 * KWidthScale , KHeight * 0.5 - height * 0.5, KWidth - 100 * KWidthScale, height), controller:controller)
        }else{
           let VC = AccountDetailEditingViewController()
            NSNotificationCenter.defaultCenter().postNotificationName(KNotificationCellAnimationEnd, object: nil)
            VC.isPayment = data.isPayment
            self.presentViewController(VC, animated: true, completion: {[unowned VC] () -> Void in
                //let data_ = data
                data.moneyAmount = data.moneyAmount < 0 ? data.moneyAmount * (-1.0) : data.moneyAmount
                VC.changeNewFirstData(data)
            })
           
        }
        }
        self.loadAccountData()
        
      
    }
    func loadAccountData() {
//        
//        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
//            for data in MUFMDBManager.manager.getDayItemsAccount(KAccountCommontTable) {
//                self.detailItemTableView.secitonDataArray.addObject(data)
//            }
//            
//            if self.detailItemTableView.secitonDataArray.count == 0 {
//                return
//            }
//
//           
//            for data in self.detailItemTableView.secitonDataArray {
//               
//                
//                let data_ = data as! MUAccountDayDetailModel
//                self.detailItemTableView.dataArray.append(MUFMDBManager.manager.getDayItemsAccount(KAccountCommontTable, date: data_.date))
//                
//            }
//        dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                
//                self.detailItemTableView.reloadData()
//                self.detailItemTableView.setNeedsDisplay()
//                self.detailItemTableView.contentOffset = CGPointZero
//                let data = self.detailItemTableView.secitonDataArray.firstObject as? MUAccountDayDetailModel
//                
//                self.topView.loadAccountTableSumarize(data!.month)
//            }
//            
//        }
       let group = dispatch_group_create()
       dispatch_group_async(group, dispatch_get_global_queue(0, 0)) { () -> Void in
        
        for data in MUFMDBManager.manager.getDayItemsAccount(KAccountCommontTable) {
            self.detailItemTableView.secitonDataArray.addObject(data)
        }
        
        if self.detailItemTableView.secitonDataArray.count == 0 {
            //return
        }
        
        
        for data in self.detailItemTableView.secitonDataArray {
            
            
            let data_ = data as! MUAccountDayDetailModel
            self.detailItemTableView.dataArray.append(MUFMDBManager.manager.getDayItemsAccount(KAccountCommontTable, date: data_.date))
            
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.detailItemTableView.reloadData()
            self.detailItemTableView.setNeedsDisplay()
            self.detailItemTableView.contentOffset = CGPointZero
            let data = self.detailItemTableView.secitonDataArray.firstObject as? MUAccountDayDetailModel
            if data != nil{
              self.topView.loadAccountTableSumarize(data!.month)
            }else{
              self.topView.loadAccountTableSumarize("")
            }
            self.detailItemTableView.setNeedsDisplay()
        }

        }

        dispatch_group_notify(group, dispatch_get_global_queue(0, 0)) { () -> Void in
            var data = self.detailItemTableView.secitonDataArray.firstObject as? MUAccountDayDetailModel
            if data == nil {
               data = MUAccountDayDetailModel()
               data?.month = "当月"
            }
            NSNotificationCenter.defaultCenter().postNotificationName(KNotificationEndLoadFMDBData, object: data)
        }

     
    }
    //MARK: Notification
    func userDidAddAccountDetail() {
    self.detailItemTableView.secitonDataArray.removeAllObjects()
       self.detailItemTableView.dataArray.removeAll()
       self.loadAccountData()
    }
    func refreshTopViewMonthBalance(noti:NSNotification) {
        let date = noti.object as! String
         self.topView.refreshMonthBalance(MUFMDBManager.manager.searchForAccountMonth(date, tableName: KAccountCommontTable))
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    func presentAccountDetailEditingViewController() {
           self.presentViewController(AccountDetailEditingViewController(), animated: true, completion: nil)
       
        
    }
    func openCarmera() {
       let VC = MUPromtViewController()
       let rect = CGRectMake(30 * KWidthScale, KHeight - 3 * 40 * KHeightScale - 10.0, KWidth - 60 * KWidthScale,  3 * 40 * KHeightScale)
       VC.contentView = MUAlertView.init(frame: rect)
       VC.contentView._ViewType = viewType.sheetView
       VC.contentView.sheetButtonTitles = ["拍照","本地图片","取消"]
       VC.contentView.setBlock {[unowned self] (object) -> Void in
           let tag = object as? Int
        switch tag!{
        case 0:
            self.topView.backImageName = "background12_375x155_"
            break
        case 1:
            self.topView.backImageName =  "background1_375x155_"
            break
        case 2:
            
            break
        default:
            break
        }
        }
       setWindowType(windowType.sheetWindow, rect: rect, controller: VC)
    }
   
}
