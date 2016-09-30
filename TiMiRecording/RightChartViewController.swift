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
    private let addButton = UIButton.init(type: .Custom)
    private let lineView = UIView.init()
    private let chartView = MUPaymentAnlalyseChart.init(frame: CGRectZero)
    
    
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
        self.view.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
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
        
        addButton.backgroundColor = KOrangeColor
        addButton.setTitle("记一笔", forState: .Normal)
        addButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addButton.titleLabel?.font = UIFont.systemFontOfSize(KTitleFont)
        addButton.addTarget(self, action: "addAccountDetail", forControlEvents: .TouchUpInside)
        addButton.layer.cornerRadius = 5
        
        lineView.backgroundColor = UIColor.lightGrayColor()
        lineView.frame = CGRectMake(0, 0, KWidth, 1)
       
        
        self.setDetailUI()
        
    }
    private func addAttributedString() {
        
        var month = MUFMDBManager.manager.dateFormatter.stringFromDate(NSDate.init(timeIntervalSinceNow: 0))
         month =  month.substringFromIndex(month.startIndex.advancedBy(5))
        if month.containsString(self.monthCountData!.month) && !self.monthCountData!.month.containsString("年"){
            month = "当月"
            self.progressView.isAnimtion = true
            self.bugetAmount = 10
            self.chartView.subViewsType = MUAccountChartViewType.CURVEVIEW
            print("是当月")
        }else{
            month = self.monthCountData!.month
            self.progressView.isAnimtion = false
            self.bugetAmount = 0.0
            self.chartView.subViewsType = MUAccountChartViewType.CIRCLEVIEW
            print("不是当月")
        }
        let total = String.init(format: "%@支出%.2lf元\n", arguments: [month,(monthCountData!.payment)])
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
        
        self.view.addSubview(self.chartView)
        self.view.addSubview(self.progressView)
        self.view.addSubview(dayLabel)
        self.view.addSubview(self.judgeImageView)
        self.view.addSubview(lineView)
        
        var amount = NSUserDefaults.standardUserDefaults().valueForKey("USERBUDGET") as? String
        if  amount == nil {
            amount = "0.0"
        }
        self.bugetAmount = Double.init(amount!)!
        self.addAttributedString()
        
        if(self.monthCountData?.allCount > 0 ){
            self.judgeImageView.removeFromSuperview()
            self.tipsLabel.removeFromSuperview()
            self.addButton.removeFromSuperview()
            if (self.bugetAmount.isZero && self.chartView.lastMonthDatas.isEmpty) || (!self.monthPaymentLabel.text!.containsString("当月")){
                self.progressView.removeFromSuperview()
                self.tableViewY = self.monthPaymentLabel.frame.size.height + KAccountItemWidthMargin + self.monthPaymentLabel.frame.origin.y
                self.progressView.isAnimtion = false
                self.progressView.isCompareBudget = true
            }else{
            self.progressView.frame = CGRectMake(0, self.monthPaymentLabel.frame.origin.y + self.monthPaymentLabel.frame.size.height + KAccountItemWidthMargin, KWidth, 3 * KAccountItemWidthMargin)
            self.progressView.isCompareBudget = true
            self.progressView.totalAmount = self.bugetAmount
            self.progressView.paymentAmount = 30.0
            self.progressView.color = KSkyColor
            self.progressView.isAnimtion = true
    
            self.progressView.startUI()
            self.tableViewY =  KAccountItemWidthMargin * 3 + self.progressView.frame.origin.y
            }
            if self.chartView.subViewsType == MUAccountChartViewType.CURVEVIEW {
                self.lineView.removeFromSuperview()
            }
            self.chartView.frame = CGRectMake(0,self.tableViewY, KWidth, 90 * KHeightScale)
            self.chartView.isAnimtaion = true
            self.chartView.setUI()
            self.tableViewY = self.chartView.frame.origin.y + 92 * KHeightScale
            lineView.frame.origin.y = self.tableViewY
            
            
        }else if(self.monthCountData?.allCount == 0){
            self.progressView.removeFromSuperview()
            self.chartView.removeFromSuperview()
            self.dayLabel.removeFromSuperview()
            self.chartView.isAnimtaion = false
            self.tableViewY = self.monthPaymentLabel.frame.size.height + self.monthPaymentLabel.frame.origin.y
            self.judgeImageView.frame = CGRectMake(KWidth*0.5 - 40, self.tableViewY + KAccountItemWidthMargin, 80, 60)
            self.judgeImageView.image = UIImage.init(named: "timi_noData_79x58_")
            self.view.addSubview(self.judgeImageView)
            
            tipsLabel.frame = CGRectMake(KAccountItemWidthMargin, judgeImageView.frame.origin.y + 70, KWidth - 2 * KAccountItemWidthMargin, KAccountItemWidthMargin)
            tipsLabel.text = "还没有支出，去记录一笔支出吧！"
            self.view.addSubview(tipsLabel)
            
            
            
            addButton.frame = CGRectMake(50 * KWidthScale, 6 * KAccountItemWidthMargin + 70, KWidth - 100, 40 * KHeightScale)
            self.view.addSubview(addButton)
        
             lineView.frame = CGRectMake(0, addButton.frame.size.height + addButton.frame.origin.y + KAccountItemWidthMargin, KWidth, 1)
            self.tableViewY = lineView.frame.origin.y
            
        }else if(self.monthCountData!.allCount > 0 && !self.bugetAmount.isZero){
          
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
     let data = noti.object as? MUAccountDayDetailModel
        
        if(data?.allCount <= 0){
            self.monthCountData = data
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.setDetailUI()
            }
        }else{
            self.monthCountData = data
            self.monthCountData?.payment *= -1.0
            let thisMonthDatas = MUFMDBManager.manager.searchTopThreePaymentAccountItemByMonth(self.monthCountData!.month, tableName: KAccountCommontTable)
            var lastMonth = self.monthCountData!.month.substringToIndex(self.monthCountData!.month.endIndex.advancedBy(-1))
            
            if lastMonth.containsString("年") {
               let year = lastMonth.substringToIndex(lastMonth.startIndex.advancedBy(5))
               lastMonth =  lastMonth.substringFromIndex(self.monthCountData!.month.startIndex.advancedBy(5))
               let month = Int.init(lastMonth)
               lastMonth = String.init(format: "%@%d月", arguments: [year,month!-1])
            }else{
                let month = Int.init(lastMonth)
                lastMonth = String.init(format: "%d月", arguments: [month!-1])
            }
            NSThread.sleepForTimeInterval(1.0)
            let lastMonthDatas = MUFMDBManager.manager.searchTopThreePaymentAccountItemByMonth(lastMonth, tableName: KAccountCommontTable)
            
            self.chartView.currentMonthDatas = thisMonthDatas
            self.chartView.lastMonthDatas = lastMonthDatas
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.setDetailUI()
                self.progressView.startProgressAnimation()
                //self.chartView.startAnimations()
            }
        }
       
       
      
    }
    //MARK: Observe
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object != nil {
          let view = object! as? UIView
            if view!.frame.origin.x.isZero{
              self.progressView.startProgressAnimation()
              //self.chartView.startAnimations()
            }
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
                 self.progressView.startProgressAnimation()
                
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