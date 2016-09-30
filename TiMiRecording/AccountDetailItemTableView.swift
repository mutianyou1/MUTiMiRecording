//
//  AccountDetailItemTableView.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/2.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

let AccountDetailidentifier = "accountDetailItemCell"
let AccountDetailHeader = "accountDetailHeader"
class AccountDetailItemTableView: UITableView,UITableViewDelegate,UITableViewDataSource{
    
    lazy var dataArray = Array<Array<MUAccountDetailModel>>()
    lazy var secitonDataArray = NSMutableArray()
    
    private var springLineView = UIView.init()
    private lazy var springAnimationBlock = {(springHeight : CGFloat)  in }
    private lazy var cellItemEditBlock = {(modle:MUAccountDetailModel, isDelete: Bool) in}
    
    override  init(frame: CGRect, style: UITableViewStyle) {
       super.init(frame: frame, style: style)
        
       self.showsVerticalScrollIndicator = false
       self.registerClass(AccountDetailItemTableViewCell.self, forCellReuseIdentifier: AccountDetailidentifier)
       self.dataSource = self
       self.delegate = self
       self.backgroundColor = UIColor.whiteColor()
       self.separatorStyle = .None
       springLineView.backgroundColor = UIColor.lightGrayColor()
       springLineView.frame =  CGRectMake(self.bounds.size.width * 0.5 - 0.5, self.contentOffset.y, 1,self.contentOffset.y * -1.0)
       self.addSubview(springLineView)
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: TableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.secitonDataArray.isKindOfClass(NSNull.self){
           return 0
        }
        return self.secitonDataArray.count + 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 0;
        }else{
      
            if self.dataArray.isEmpty {
              return 0
            }
        let data = secitonDataArray.objectAtIndex(section-1) as! MUAccountDayDetailModel
           return Int.init(data.allCount);
         
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(AccountDetailidentifier, forIndexPath: indexPath) as! AccountDetailItemTableViewCell
        if(cell.isKindOfClass(NSNull.self)){
            
            cell = AccountDetailItemTableViewCell.init(style: .Default, reuseIdentifier: AccountDetailidentifier)
           
            
        }
       
        
        if indexPath.section > 0 {
        
        
            
        let data = self.dataArray[indexPath.section - 1][indexPath.row]
        if (indexPath.row % 2 == 1 && data.tipsString.isEmpty){
          
            data.userPictureName = "kRecommendSaving_335x140_"
            data.tipsString = "昨夜西风凋碧树……"
        }else if(indexPath.row % 2 == 0 && data.tipsString.isEmpty){
            data.userPictureName = "redsky"
            data.tipsString = "河汉清且浅 相去复几许"
        }
          cell.setContentData(data)
          cell.setCellItmeEditeBlock({ (data_, isDelete) -> Void in
               self.cellItemEditBlock(data,isDelete)
          })
          if indexPath.row == 0 {
              cell.setRefreshMonthBalanceBlock({ () -> Void in

                 NSNotificationCenter.defaultCenter().postNotificationName(KNotificationCellRefreshMonthBalance, object: data.date)
              })
          }else{
            cell.setRefreshMonthBalanceBlock({ () -> Void in
                
            })
          }
        }
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0){
          return nil
        }
      
        var headView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(AccountDetailHeader) as! AccountDetailTableHeaderView?
       
        if((headView == nil)){
            
            headView = AccountDetailTableHeaderView.init(reuseIdentifier: AccountDetailHeader)
        }
        headView!.frame = CGRectMake(0, 0, KWidth, 40 * KHeightScale)
        let data = self.secitonDataArray.objectAtIndex(section-1) as! MUAccountDayDetailModel
        headView!.setUpDateAndMoneyAmount(data.date, amount: String.init(format: "%.2lf", arguments: [data.payment * (-1.00)]))
        return headView
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0.0
        }
        return 40.0 * KHeightScale
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1{
          return 40 * KHeightScale
        }
        return 60 * KHeightScale
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //print(scrollView.contentOffset.y)
        NSNotificationCenter.defaultCenter().postNotificationName(KNotificationCellAnimationEnd, object: nil)
        
        if scrollView.contentOffset.y <= 20.0 && scrollView.dragging{
          
            let sprinMargin = scrollView.contentOffset.y > 0.0 ? 0.0 : scrollView.contentOffset.y * -1.0
            springAnimationBlock(sprinMargin)
            springLineView.frame = CGRectMake(self.bounds.size.width * 0.5 - 0.5, scrollView.contentOffset.y, 1, sprinMargin)
        }
        if scrollView.contentOffset.y < 0.0 && scrollView.dragging == false {
            springAnimationBlock(0.0)
        }
    }
    func setSpringAnimationBlock(block: (height : CGFloat)-> Void) {
        self.springAnimationBlock = block
    }
    func setCellItmeEditeBlock(block: (data : MUAccountDetailModel,isDelete: Bool) -> Void) {
        self.cellItemEditBlock = block
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
