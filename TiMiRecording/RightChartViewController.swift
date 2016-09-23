//
//  RightChartViewController.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/23.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit


class RightChartViewController: UIViewController {
    private let monthPaymentLabel = UILabel.init()
    private let budgetLabel = UILabel.init()
    private let remaindsLabel = UILabel.init()
    private let bugetAmount = 0.0
    private var detailTableView :UITableView?
    private let judgeImageView = UIImageView.init()
    private var monthData : MUAccountDetailModel?
    private var monthCountData : MUAccountDayDetailModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setUpUI()
    }
    private func setUpUI() {
       self.monthPaymentLabel.frame = CGRectMake(KAccountItemWidthMargin * 0.5, 2 * KAccountItemWidthMargin, KWidth * 0.5, KAccountItemWidthMargin)
       let total = String.init(format: "当月支出%.2lf元", arguments: [(monthCountData?.payment)!])
       let perDay = String.init(format: "\n日均%.2lf元", arguments: [(monthCountData?.payment)!/Double.init((self.monthCountData?.allCount)!)])
       let attributedStr = NSMutableAttributedString.init(string: String.init(format: "%@%@", arguments: [total,perDay]))
       let range = NSRange.init(location:0, length:  Int(String(total.endIndex))!)
       let rangeEnd = NSRange.init(location: Int(String(total.endIndex))! + 1, length: attributedStr.length -  Int(String(total.endIndex))! + 1)
        
       attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: rangeEnd)
       attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(KTitleFont), range: range)
       attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(KLittleFont), range: rangeEnd)
       self.monthPaymentLabel.attributedText = attributedStr
        
        if(self.monthCountData?.allCount > 0){
           let titleLabel = UILabel.init(frame: CGRectMake(KAccountItemWidthMargin * 0.5, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>))
        
        }else{
        
        
        
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
