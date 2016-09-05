//
//  AccountDetailItemTableView.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/2.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

let AccountDetailidentifier = "accountDetailItemCell"

class AccountDetailItemTableView: UITableView,UITableViewDelegate,UITableViewDataSource{
    
    private lazy var dataArray = NSMutableArray()
    override  init(frame: CGRect, style: UITableViewStyle) {
       super.init(frame: frame, style: style)
        
       self.showsVerticalScrollIndicator = false
       self.registerClass(UITableViewCell.self, forCellReuseIdentifier: AccountDetailidentifier)
       self.dataSource = self
       self.delegate = self
       self.backgroundColor = UIColor.whiteColor()
       self.separatorStyle = .None
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: TableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 0;
        }
        return 2;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(AccountDetailidentifier, forIndexPath: indexPath)
        if(cell.isKindOfClass(NSNull.self)){
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: AccountDetailidentifier)
            
        }
        cell.textLabel?.text = "这是第\(indexPath.section)分区\(indexPath.row)行"
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0){
          return nil
        }
        let view = AccountDetailTableHeaderView()
        view.frame = CGRectMake(0, 0, KWidth, 40 * KHeightScale)
        view.setUpDateAndMoneyAmount("0\(section+20)日", amount: "\((rand() % 100000) + 300)")
        return view
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0.0
        }
        return 40.0 * KHeightScale
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40;
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
