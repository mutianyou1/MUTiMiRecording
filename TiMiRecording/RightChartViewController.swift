//
//  RightChartViewController.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/23.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

let KEmptyDataIndentifier = "KEmptyData"
let KButtonsTableView = "accountButtonsCell"
private enum ViewsTag : Int{case NODATAIMAGE = 10 ,EDITLABEL,EDITBUTTON,LINEVIEW,CHART1,CHART2,CHART3}
class RightChartViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    private let monthPaymentLabel = UILabel.init()
    private let dayLabel = UILabel.init()
    private var bugetAmount = 0.0
    private lazy var buttonsTableView = UITableView.init(frame: CGRectZero, style: .Plain)
    private let judgeImageView = UIImageView.init()
    private let tipsLabel = UILabel.init()
    private let buttonsTitles = ["当月预算","全部收支汇总","收入及财务状况","历史支出状况"]
    private let buttonsImages = ["anlysis_budget_20x20_","anlysis_balance_20x20_","anlysis_income_20x20_","anlysis_expense_20x20_"]
    private var tableViewY : CGFloat = 0.0
    private let progressView = MUAccountProgressView.init(frame: CGRectMake(0, 0, 0, KHeight))
    
    
    var monthData : MUAccountDetailModel?
    var monthCountData : MUAccountDayDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
       
        
        
        self.buttonsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: KButtonsTableView)
        self.buttonsTableView.separatorStyle = .None
        self.buttonsTableView.scrollEnabled = false
        self.buttonsTableView.delegate = self
        self.buttonsTableView.dataSource = self
        self.view.addSubview(self.buttonsTableView)
        self.buttonsTableView.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "accountDetailAdded:", name: KNotificationEndLoadFMDBData, object: nil)
        self.setUpUI()
    }
    private func setUpUI() {
        if(self.monthCountData == nil){
          self.monthCountData = MUAccountDayDetailModel()
          self.monthCountData!.month = KEmptyDataIndentifier
        }
        
        
   
       self.monthPaymentLabel.numberOfLines = 0
    
       self.view.addSubview(self.monthPaymentLabel)
        
        self.dayLabel.textAlignment = .Center
        self.dayLabel.textColor = UIColor.lightGrayColor()
        self.dayLabel.font = UIFont.systemFontOfSize(KTitleFont)
        tipsLabel.font = UIFont.systemFontOfSize(KMiddleFont)
        tipsLabel.textAlignment = .Center
        self.setDetailUI()
        
    }
    private func addAttributedString() {
        let total = String.init(format: "当月支出%.2lf元\n", arguments: [(monthCountData!.payment)])
        let intcount = CGFloat.init(monthCountData!.allCount)
        let perday = CGFloat.init(monthCountData!.payment) / intcount
        let perDay = String.init(format: "日均%.2lf元", arguments: [perday.isNaN ? 0.0 : perday])
        let attributedStr = NSMutableAttributedString.init(string: String.init(format: "%@%@", arguments: [total,perDay]))
        let range = NSRange.init(location:0, length:  Int(String(total.endIndex))!)
        let rangeEnd = NSRange.init(location: Int(String(total.endIndex))!, length: attributedStr.length -  Int(String(total.endIndex))!)
        
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: rangeEnd)
        attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(KTitleFont), range: range)
        attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(KMiddleFont), range: rangeEnd)
        self.monthPaymentLabel.attributedText = attributedStr
        let height = total.getStringHeight(KWidth * 0.5, content: attributedStr)
        self.monthPaymentLabel.frame = CGRectMake(KAccountItemWidthMargin * 0.5, 2 * KAccountItemWidthMargin, KWidth * 0.5, height)
        self.tableViewY  = height + 2 * KAccountItemWidthMargin
    }
    private func setDetailUI() {
        
       
        self.addAttributedString()
        var amount = NSUserDefaults.standardUserDefaults().valueForKey("USERBUDGET") as? String
        if amount == nil {
          amount = "0.0"
        }
        self.bugetAmount = Double.init(amount!)!
        if(self.monthCountData?.allCount > 0 && self.bugetAmount.isZero){
            self.judgeImageView.removeFromSuperview()
            self.tipsLabel.removeFromSuperview()
            for  index in 0...2 {
                let frameX = KWidth / 3.0
                let view = UIView.init(frame: CGRectMake(CGFloat.init(index) * frameX, self.monthPaymentLabel.frame.origin.y + self.monthPaymentLabel.frame.size.height + KAccountItemWidthMargin, KWidth / 3.0, 80 * KHeightScale))
                view.layer.cornerRadius = 80 * KHeightScale
                view.backgroundColor = KSkyColor
                self.view.addSubview(view)
                self.tableViewY = view.frame.origin.y + 90 * KHeightScale
            }
            let button  = self.view.viewWithTag(ViewsTag.EDITBUTTON.rawValue) as? UIButton
            if button != nil{
               button?.removeFromSuperview()
                
            }
          
            var lineView = self.view.viewWithTag(ViewsTag.LINEVIEW.rawValue)
            if lineView == nil{
               lineView = UIView.init(frame: CGRectMake(0, 0, KWidth, 1))
               lineView?.backgroundColor = UIColor.lightGrayColor()
               lineView?.tag = ViewsTag.LINEVIEW.rawValue
               self.view.addSubview(lineView!)
               self.view.addSubview(dayLabel)
            }
            lineView?.frame.origin.y = self.tableViewY
            
            
        }else if(self.monthCountData?.allCount == 0){
            self.tableViewY = self.monthPaymentLabel.frame.size.height + self.monthPaymentLabel.frame.origin.y
            self.judgeImageView.frame = CGRectMake(KWidth*0.5 - 40, self.tableViewY + KAccountItemWidthMargin, 80, 60)
            self.judgeImageView.image = UIImage.init(named: "timi_noData_79x58_")
            self.view.addSubview(self.judgeImageView)
            
            tipsLabel.frame = CGRectMake(KAccountItemWidthMargin, judgeImageView.frame.origin.y + 70, KWidth - 2 * KAccountItemWidthMargin, KAccountItemWidthMargin)
            tipsLabel.text = "还没有支出，去记录一笔支出吧！"
            self.view.addSubview(tipsLabel)
            
            let addButton = UIButton.init(type: .Custom)
            addButton.backgroundColor = KOrangeColor
            addButton.setTitle("记一笔", forState: .Normal)
            addButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            addButton.titleLabel?.font = UIFont.systemFontOfSize(KTitleFont)
            addButton.addTarget(self, action: "addAccountDetail", forControlEvents: .TouchUpInside)
            addButton.frame = CGRectMake(50 * KWidthScale, 6 * KAccountItemWidthMargin + 70, KWidth - 100, 40 * KHeightScale)
            addButton.layer.cornerRadius = 5
            addButton.tag = ViewsTag.EDITBUTTON.rawValue
            self.view.addSubview(addButton)
            
            let lineView = UIView.init(frame: CGRectMake(0, addButton.frame.size.height + addButton.frame.origin.y + KAccountItemWidthMargin, KWidth, 1))
            lineView.backgroundColor = UIColor.lightGrayColor()
            lineView.tag = ViewsTag.LINEVIEW.rawValue
            self.view.addSubview(lineView)
            self.tableViewY = lineView.frame.origin.y
            self.tableViewY = lineView.frame.origin.y
            
            self.view.addSubview(dayLabel)
        }else if(self.monthCountData!.allCount > 0 && !self.bugetAmount.isZero){
            self.judgeImageView.removeFromSuperview()
            self.tipsLabel.removeFromSuperview()
            self.progressView.layer.borderWidth = 0.0
            self.progressView.layer.borderColor = UIColor.clearColor().CGColor
            if self.progressView.frame.size.width < 10 {
                self.view.addSubview(progressView)
            }
            self.progressView.frame = CGRectMake(0, self.monthPaymentLabel.frame.origin.y + self.monthPaymentLabel.frame.size.height + KAccountItemWidthMargin, KWidth, KAccountItemWidthMargin * 4)
           
            
            self.tableViewY = self.monthPaymentLabel.frame.origin.y + self.monthPaymentLabel.frame.size.height
            self.tableViewY += KAccountItemWidthMargin * 4
            self.progressView.totalAmount = self.bugetAmount
            self.progressView.paymentAmount = 100
            self.progressView.days = 8
            self.progressView.color = UIColor.greenColor()
            self.progressView.startUI()
            self.progressView.startProgressAnimation()
            
            let button  = self.view.viewWithTag(ViewsTag.EDITBUTTON.rawValue) as? UIButton
            if button != nil{
                button?.removeFromSuperview()
                
            }
            var lineView = self.view.viewWithTag(ViewsTag.LINEVIEW.rawValue)
            if lineView == nil{
                lineView = UIView.init(frame: CGRectMake(0, 0, KWidth, 1))
                lineView?.backgroundColor = UIColor.lightGrayColor()
                lineView?.tag = ViewsTag.LINEVIEW.rawValue
                self.view.addSubview(lineView!)
                self.view.addSubview(dayLabel)
            }
            lineView?.frame.origin.y = self.tableViewY
            self.view.bringSubviewToFront(lineView!)
          
        }
        self.tableViewY += KAccountItemWidthMargin
        self.dayLabel.frame = CGRectMake(KAccountItemWidthMargin, self.tableViewY, KWidth - KAccountItemWidthMargin * 2, KAccountItemWidthMargin)
        self.dayLabel.text = "记账第一天么么哒～～"
        self.tableViewY += KAccountItemWidthMargin * 2
        self.buttonsTableView.frame = CGRectMake(KAccountItemWidthMargin * 0.5, self.tableViewY, KWidth - KAccountItemWidthMargin, 200 * KHeightScale)
    }
    //MARK: Notification
    @objc
    private func accountDetailAdded(noti: NSNotification) {
     let array = MUFMDBManager.manager.getDayItemsAccount(KAccountCommontTable)
        if(array.isEmpty){
           return
       }
       self.monthCountData = array.first
       self.monthCountData?.payment *= -1.0
       dispatch_async(dispatch_get_main_queue()) { () -> Void in
          self.setDetailUI()
        }
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc
    private func addAccountDetail() {
       self.presentViewController(AccountDetailEditingViewController(), animated: true, completion: nil)
    }


}
extension RightChartViewController {
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(KButtonsTableView, forIndexPath: indexPath)
        if cell.isKindOfClass(NSNull.self) {
          cell = UITableViewCell.init(style: .Value1, reuseIdentifier: KButtonsTableView)
        }
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        cell.textLabel?.text = self.buttonsTitles[indexPath.section]
        cell.imageView?.image = UIImage.init(named: buttonsImages[indexPath.section])
        cell.textLabel?.font = UIFont.systemFontOfSize(KTitleFont)
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 1.0
       
        return cell
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init()
        return view
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10 * KHeightScale
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40 * KHeightScale
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            
              let VC = MUPromtViewController()
              let rect = CGRectMake(50 * KWidthScale, 200 * KHeightScale, KWidth - 100 * KWidthScale, KHeight - 460 * KHeightScale)
               VC.contentView = MUAlertView.init(frame: rect)
               VC.contentView._ViewType = viewType.alertView
               VC.contentView.showTextView = true
               VC.contentView.textViewKeyBoard = .DecimalPad
               VC.contentView.message = "预算\n预算是衡量支出状况的重要指标！"
              VC.contentView.setBlock({[unowned self] (object) -> Void in
                 let amount = object as? String
                 NSUserDefaults.standardUserDefaults().setValue(amount, forKey: "USERBUDGET")
                 self.bugetAmount = Double.init(amount!)!
                 self.setDetailUI()
                
              })
              setWindowType(windowType.alertWindow, rect: rect, controller: VC)
            
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default:
            break
        
        
        }
    }

}