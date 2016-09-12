//
//  MUAlertView.swift
//  MUWindow
//
//  Created by 潘元荣(外包) on 16/6/16.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit


public enum viewType {case alertView, sheetView, upView,rightView,calendarView}

class MUAlertView: UIView {
    private lazy var contentLabel = UILabel()
    private lazy var cancelButton = UIButton.init(type: UIButtonType.System)
    private lazy var certainButton = UIButton.init(type: UIButtonType.System)
    private lazy var  inputTextView = UITextView.init()
    private lazy var  calendar = UIDatePicker.init()
    private lazy var  certainBlock = {()->Void in}
    private let dateFormatter = NSDateFormatter.init()
   var _ViewType = viewType.alertView{
        didSet{
            
            }
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        switch _ViewType {
        case .alertView:
            self.userInteractionEnabled = true
            contentLabel.attributedText = self.getAttributedString( "系统消息：\n请明确以下信息么事都放回我饿复合物绥芬河互粉加哦方式寺佛诶设法二合一")
            contentLabel.textColor = UIColor.blackColor()
            contentLabel.numberOfLines = 0
            contentLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 120)
            self.addSubview(contentLabel)
            
            cancelButton.setTitle("取消", forState: UIControlState.Normal)
            cancelButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            cancelButton.layer.borderWidth = 1
            cancelButton.frame = CGRectMake(-1, self.bounds.size.height - 85, self.bounds.size.width+2, 30)
            cancelButton.addTarget(self, action: "clickButton:", forControlEvents: UIControlEvents.TouchUpInside)
           
            inputTextView.layer.cornerRadius = 5
            inputTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
            inputTextView.layer.borderWidth = 1
            inputTextView.frame = CGRectMake(20, 150, self.bounds.size.width - 40, 120)
            inputTextView.delegate = self
            self.addSubview(inputTextView)
        
        case .rightView:
            contentLabel.text = "dhuhu"
        case .sheetView:
            contentLabel.text = "dhuhu"
        case .upView:
            contentLabel.text = "dhuhu"
        case .calendarView:
            self.calendar.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 40 * KHeightScale)
            self.calendar.locale = NSLocale.init(localeIdentifier: "zh_CN")
            self.calendar.date = NSDate(timeIntervalSinceNow: 0)
            self.calendar.datePickerMode = .Date
            self.addSubview(calendar)
            self.dateFormatter.dateFormat = "YYYY年\nM月dd日"
            
        }
        certainButton.layer.borderWidth = 1
        certainButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        certainButton.setTitle("确定", forState: UIControlState.Normal)
        certainButton.addTarget(self, action: "clickButton:", forControlEvents: UIControlEvents.TouchUpInside)
        certainButton.frame = CGRectMake(-1, self.bounds.size.height - 40 * KHeightScale, self.bounds.size.width+2, 40 * KHeightScale)
        self.addSubview(certainButton)

    }
    @objc
    private func getAttributedString(content :String)->NSAttributedString{
        let style = NSMutableParagraphStyle.init()
        style.lineBreakMode = NSLineBreakMode.ByCharWrapping
        style.lineSpacing = 2//
        let string = NSMutableAttributedString.init(string: content, attributes: [NSParagraphStyleAttributeName:style,NSFontAttributeName:UIFont(name: "Avenir-Light", size: 17)!,NSStrokeWidthAttributeName:-1.5])
        return string
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.clipsToBounds = false
    }
    @objc
    private func clickButton(sender :UIButton){
        
        MUWindow.setWindowFinishBlock(self.certainBlock)
    }
    func setCertainBlock( block : () -> Void) {
        self.certainBlock = block
    }
    func setCurrentDate(date : String) {
         self.calendar.date = self.dateFormatter.dateFromString(date)!
    }
    func getPickedDate() -> String {
        let durain = self.calendar.date.timeIntervalSinceNow
        if(durain < 0 && durain > -24 * 60 * 60 ){
          return "今天"
        }else{
         return self.dateFormatter.stringFromDate(self.calendar.date)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MUAlertView :UITextViewDelegate{
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        UIView.animateWithDuration(NSTimeInterval.init(0.35)) { () -> Void in
            var rect = self.superview?.frame
            rect?.origin.y -= 50;
            self.superview?.frame = rect!
        }
        return true
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text.containsString("\n"){
            UIView.animateWithDuration(NSTimeInterval.init(0.35)) { () -> Void in
                var rect = self.superview?.frame
                rect?.origin.y += 50;
                self.superview?.frame = rect!
            }
           textView.resignFirstResponder()
           return false
        }
        return true
    }


}

