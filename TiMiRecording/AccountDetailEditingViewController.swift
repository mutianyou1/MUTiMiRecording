//
//  AccountDetailEditingViewController.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/2.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

class AccountDetailEditingViewController: UIViewController {
    private let incomeButton = UIButton.init(type: .Custom)
    private let paidButton = UIButton.init(type: .Custom)
    private lazy var topView = MUAccountEditTopView.init(frame: CGRectZero)
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.addButtons()
        self.topView = MUAccountEditTopView.init(frame: CGRectMake(0, KAccoutTitleMarginToAmount + 30, KWidth, 45 * KHeightScale))
        self.view.addSubview(topView)
        let data = MUAccountDetailModel()
        data.thumbnailName = "type_big_13_48x48_"
        data.accountTitleName = "丽人"
        data.moneyAmount = "¥3000"
        topView.loadData(data)
       
    }
    private func addButtons() {
        let closeButton = UIButton.init(type: .Custom)
        closeButton.frame = CGRectMake(KAccoutTitleMarginToAmount * 0.5, KAccoutTitleMarginToAmount, 18 , 18)
        closeButton.setImage(UIImage.init(named: "btn_item_close_36x36_"), forState: .Normal)
        self.view.addSubview(closeButton)
        closeButton.addTarget(self, action: "close", forControlEvents: .TouchUpInside)
        
       
        incomeButton.setTitle("收入", forState: .Normal)
        incomeButton.titleLabel?.font = UIFont.systemFontOfSize(KBigFont)
        incomeButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        incomeButton.setTitleColor(UIColor.init(red: 253 / 255.0, green: 165/255.0, blue: 65/255.0, alpha: 1.0), forState: .Selected)
        incomeButton.frame = CGRectMake(KWidth * 0.5 - 40 - KAccoutTitleMarginToAmount * 0.5, KAccoutTitleMarginToAmount, 40, 30)
        incomeButton.addTarget(self, action: "incomeOrPaidDataLoad:", forControlEvents: .TouchUpInside)
        self.view.addSubview(incomeButton)
        
      
        paidButton.setTitle("支出", forState: .Normal)
        paidButton.titleLabel?.font = UIFont.systemFontOfSize(KBigFont)
        paidButton.frame = CGRectMake(KWidth * 0.5 + KAccoutTitleMarginToAmount * 0.5, KAccoutTitleMarginToAmount, 40, 30)
        paidButton.addTarget(self, action: "incomeOrPaidDataLoad:", forControlEvents: .TouchUpInside)
        paidButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        paidButton.setTitleColor(UIColor.init(red: 253 / 255.0, green: 165/255.0, blue: 65/255.0, alpha: 1.0), forState: .Selected)
        paidButton.selected = true
        self.view.addSubview(paidButton)
    }
    func close() {
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    func incomeOrPaidDataLoad(sender : UIButton){
        if(sender == incomeButton && sender.selected == false) {
            incomeButton.selected = true
            paidButton.selected = false
        }else if(sender == paidButton && sender.selected == false) {
           paidButton.selected = true
           incomeButton.selected = false
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
