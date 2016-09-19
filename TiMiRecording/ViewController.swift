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
        
        self.setUpTabelView()
//        let array = MUFMDBManager.manager.selectDatas(KAccountCommontTable)
//        for data  in array {
//        print(data.date)
//        print(data.moneyAmount)
//        }
        
        
     
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
            controller.contentView.setCertainBlock({ () -> Void in
                print("删除了",data.accountTitleName)
               // NSNotificationCenter.defaultCenter().postNotificationName(KNotificationCellAnimationEnd, object: nil)
            })
            setWindowType(.alertWindow, rect: CGRectMake(50.0 * KWidthScale , KHeight * 0.5 - height * 0.5, KWidth - 100 * KWidthScale, height), controller:controller)
        }else{
           print("编辑",data.accountTitleName)
           
        }
        }
        self.loadAccountData()
        
      
    }
    func loadAccountData() {
        
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
           
            self.detailItemTableView.secitonDataArray = NSMutableArray.init(array: MUFMDBManager.manager.getDayItemsAccount(KAccountCommontTable))
            self.detailItemTableView.dataArray = NSMutableArray.init(array: MUFMDBManager.manager.selectDatas(KAccountCommontTable))
            
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.detailItemTableView.reloadData()
            self.detailItemTableView.contentOffset = CGPointZero
            self.detailItemTableView.setNeedsDisplay()
        }
    }
    //MARK: Notification
    func userDidAddAccountDetail() {
       self.loadAccountData()
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
        print("open carmera")
    }
   
}
