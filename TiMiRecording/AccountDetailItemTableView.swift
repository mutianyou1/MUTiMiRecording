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
    
    private lazy var dataArray = NSMutableArray()
    private var springLineView = UIView.init()
    private lazy var springAnimationBlock = {(springHeight : CGFloat)  in }
    
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
        return 7
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 0;
        }
        return 2;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(AccountDetailidentifier, forIndexPath: indexPath) as! AccountDetailItemTableViewCell
        if(cell.isKindOfClass(NSNull.self)){
            
            cell = AccountDetailItemTableViewCell.init(style: .Default, reuseIdentifier: AccountDetailidentifier)
           
            
        }
       
        let data = MUAccountDetailModel()
        data.moneyAmount = 100.00
        data.accountTitleName = "家居"
        data.thumbnailName = "type_big_1_38x38_"
        
        if (indexPath.row == 1){
          data.moneyAmount = -200.00
          data.userPictureName = "kRecommendSaving_335x140_"
        }
        cell.setContentData(data)
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
        headView!.setUpDateAndMoneyAmount("\(section+20)日", amount: "\((rand() % 100000) + 300)")
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
        
        print(scrollView.contentOffset.y)
        
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
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
