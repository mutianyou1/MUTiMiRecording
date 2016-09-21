//
//  MUAccountKeyBoardView.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/8.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

let MUKeyBoardbuttonHeight : CGFloat = (KKeyBoardHeight -  30*KHeightScale - 10.0)/4.0
let MUKeyBoardbuttonWidth : CGFloat = KWidth / 4.0
let MUKeyBoardTopMargin : CGFloat = 30 * KHeightScale
let MUKeyBoardTitleArray = ["1","2","3","4","5","6","7","8","9","清零","0","."]

public protocol MUAccountKeyBoardViewDelegate : NSObjectProtocol {
    func addNumberOnKeyBoard(number : String)
    func clearAll()
    func openCalendar()
    func startEditMessage()
    func clickOk()
}
class MUAccountKeyBoardView: UIView {

    
    private var amountString = "¥0.00"
    private var amount : CGFloat = 0.00
    private let dateButton = UIButton.init(type: .Custom)
    private let editMessageButton = UIButton.init(type: .Custom)
    private var dotIndex = 0
    private let dateFormatter = NSDateFormatter.init()
    weak var delegate :MUAccountKeyBoardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.dateFormatter.dateFormat = "YYYY年\nM月dd日"
        for   index   in 0...11  {
             let button = UIButton.init(type: .Custom)
                 button.frame = CGRectMake(CGFloat.init(index % 3) * MUKeyBoardbuttonWidth, MUKeyBoardTopMargin +  CGFloat.init(index / 3) * MUKeyBoardbuttonHeight, MUKeyBoardbuttonWidth, MUKeyBoardbuttonHeight)
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
            button.titleLabel?.textAlignment = .Center
            button.setTitle(MUKeyBoardTitleArray[index], forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.exclusiveTouch = true
            //button.titleLabel?.font = UIFont.systemFontOfSize(28 * KHeightScale)
            button.titleLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Thin", size: 28 * KHeightScale)
            button.setTitleColor(KOrangeColor, forState: .Highlighted)
            button.addTarget(self, action: "inputAmount:", forControlEvents: .TouchUpInside)
            self.addSubview(button)
        }
        
        let backView = UIView.init(frame:CGRectMake(0 , 0, KWidth, MUKeyBoardTopMargin))
        backView.backgroundColor = UIColor.lightGrayColor()
        backView.alpha = 0.5
        self.dateButton.frame = CGRectMake(0, 0, 80 * KWidthScale, MUKeyBoardTopMargin)
        self.dateButton.titleLabel?.font = UIFont.systemFontOfSize(10 * KHeightScale)
        self.dateButton.setTitleColor(KOrangeColor, forState: .Highlighted)
        self.dateButton.setTitleColor(KOrangeColor, forState: .Selected)
        self.dateButton.titleLabel?.textAlignment = .Left
        self.dateButton.titleLabel?.numberOfLines = 0
        self.dateButton.addTarget(self, action: "openCalendar", forControlEvents: .TouchUpInside)
        self.dateButton.exclusiveTouch = true
        self.addSubview(backView)
        self.addSubview(dateButton)
        
        self.editMessageButton.frame = CGRectMake(KWidth - MUKeyBoardbuttonWidth,MUKeyBoardTopMargin ,MUKeyBoardbuttonWidth , MUKeyBoardbuttonHeight * 2.0)
       self.editMessageButton.exclusiveTouch = true
       self.editMessageButton.setImage(UIImage.init(named: "addItem_remark_18x20_"), forState: .Normal)
       self.editMessageButton.setImage(UIImage.init(named: "addItem_remark_light_18x20_"), forState: .Selected)
       self.editMessageButton.setImage(UIImage.init(named: "addItem_remark_light_18x20_"), forState: .Highlighted)
       self.editMessageButton.addTarget(self, action: "startEditMessage", forControlEvents: .TouchUpInside)
       self.editMessageButton.layer.borderColor = UIColor.lightGrayColor().CGColor
       self.editMessageButton.layer.borderWidth = 0.5;
       self.addSubview(editMessageButton)
        
          let okButton = UIButton.init(type: .Custom)
          okButton.frame = CGRectMake(KWidth - MUKeyBoardbuttonWidth, frame.height - MUKeyBoardbuttonHeight - MUKeyBoardbuttonHeight, MUKeyBoardbuttonWidth, MUKeyBoardbuttonHeight + MUKeyBoardbuttonHeight)
          okButton.setTitle("OK", forState: .Normal)
          okButton.layer.borderWidth = 0.5
          okButton.layer.borderColor = UIColor.lightGrayColor().CGColor
          okButton.titleLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Thin", size: 28 * KHeightScale)
          okButton.setTitleColor(KOrangeColor, forState: .Highlighted)
          okButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
          okButton.addTarget(self, action: "clickOK", forControlEvents: .TouchUpInside)
          okButton.exclusiveTouch = true
          self.addSubview(okButton)
        
        
    }
    func setUpUI(date : NSTimeInterval , hightlightedMessageButton : Bool , hightlightedDateButton: Bool) {
        var dateStr = "今天"
        let durain = date - NSDate.init(timeIntervalSinceNow: 0).timeIntervalSince1970
        if(durain < 0 && durain > -24 * 60 * 60 ){
          dateStr = "今天"
        }else{
          dateStr = self.dateFormatter.stringFromDate(NSDate.init(timeIntervalSince1970: date))
        }
        if(date > 0.0){
          self.dateButton.setTitle(dateStr, forState: .Normal)
        }
          self.dateButton.selected = hightlightedDateButton
          self.editMessageButton.selected = hightlightedMessageButton
       
    
    }
    //MARK: button methods
    func inputAmount(sender : UIButton) {
        
        let title = sender.titleLabel?.text
       
        if((title!.containsString("清零"))){
            self.resetAmount()
            self.delegate?.clearAll()
        }else if((title!.containsString("."))){
            if(self.dotIndex == 2){
               self.dotIndex == 3
            }else{
              self.dotIndex = self.dotIndex == 0 ? 1: 2
            }
        }else{
            if(self.dotIndex == 2){
               amount +=  CGFloat.init(Int.init(title!)!)*0.01
               self.dotIndex = 3
            }else if(self.dotIndex == 1){
                amount +=  CGFloat.init(Int.init(title!)!)*0.1
                self.dotIndex = 2
            }else if(self.dotIndex != 3){
                    
                    if(amount >= 1.00 ){
                      amount *= 10.00
                      amount += CGFloat.init(Int.init(title!)!)
                    }else{
                      amount += CGFloat.init(Int.init(title!)!)
                    }
                
                }
            self.amount *= 1.000
            self.amountString = "¥\(self.amount)"
            self.amountString = String(format: "¥%.02f", arguments: [self.amount])
            if(self.amount > 100000000.00){
                let controller = MUPromtViewController()
                controller.contentView = MUAlertView.init(frame: CGRectMake(50.0 * KWidthScale , 200 * KHeightScale, KWidth - 100 * KWidthScale, KHeight - 400 * KHeightScale))
                controller.contentView.message = "提示\n输入金额不能超过1亿"
                controller.contentView._ViewType = viewType.alertView
                let height = controller.contentView.getHeight() > KHeight * 0.2 ? controller.contentView.getHeight() : KHeight * 0.2
                setWindowType(.alertWindow, rect: CGRectMake(50.0 * KWidthScale , KHeight * 0.5 - height * 0.5, KWidth - 100 * KWidthScale, height), controller:controller)
                return
            }

            
            }
            self.delegate?.addNumberOnKeyBoard(self.amountString)
        
    }
    func startEditMessage() {
        self.delegate?.startEditMessage()
    }
    func clickOK() {
        self.delegate?.clickOk()
    }
    func openCalendar() {
       self.delegate?.openCalendar()
    }
    func getAmount() -> CGFloat{
         return self.amount
    }
    func resetAmount() {
        self.amountString = "¥0.00"
        self.dotIndex = 0
        self.amount = 0.00
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
