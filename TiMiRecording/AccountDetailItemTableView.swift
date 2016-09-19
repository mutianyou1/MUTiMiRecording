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
    
    lazy var dataArray = NSMutableArray()
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
        
        return self.secitonDataArray.count + 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 0;
        }else{
      
        let data = secitonDataArray.objectAtIndex(section-1) as! MUAccountDayDetailModel
           return Int.init(data.allCount);
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(AccountDetailidentifier, forIndexPath: indexPath) as! AccountDetailItemTableViewCell
        if(cell.isKindOfClass(NSNull.self)){
            
            cell = AccountDetailItemTableViewCell.init(style: .Default, reuseIdentifier: AccountDetailidentifier)
           
            
        }
       
        // 1 section 3  2section 2  3seciotn 1
        if indexPath.section > 0 {
        var sectionData = self.secitonDataArray.objectAtIndex(0)
        var index  :  Int = 0
        var sections = 0
        while(sections < indexPath.section - 1){
                index += Int.init(sectionData.allCount)
                sections += 1
                sectionData = self.secitonDataArray.objectAtIndex(sections)
        }
        //print(indexPath.row + index,"section\(indexPath.section)")
        let data = self.dataArray.objectAtIndex(indexPath.row + index) as! MUAccountDetailModel
            index = 0
            sections = 0
        if (indexPath.row == 1){
          
          data.userPictureName = "kRecommendSaving_335x140_"
        }
          cell.setContentData(data)
          cell.setCellItmeEditeBlock({ (data, isDelete) -> Void in
            self.cellItemEditBlock(data,isDelete)
          })
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
        headView!.setUpDateAndMoneyAmount(data.date, amount: String.init(format: "%.02lf", arguments: [data.payment * (-1.0)]))
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
