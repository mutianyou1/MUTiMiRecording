//
//  AccountTipsEditViewController.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/22.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit
let KlineViewLittleMargin = KHeightScale * 5.0
class AccountTipsEditViewController: UIViewController ,UITextViewDelegate{
    private let backButton = UIButton.init(type: .Custom)
    private let dateLabel = UILabel.init(frame: CGRectMake(KAccountItemWidthMargin * 0.5, KAccountItemWidthMargin * 2.0 + KlineViewLittleMargin * 2.0, KWidth - KAccountItemWidthMargin * 0.5, KAccountItemWidthMargin))
    private let tipsTextView = UITextView.init()
    private let openCameraButton = UIButton.init(type: .Custom)
    private let keyBoardToolView = UILabel.init(frame: CGRectMake(0, KHeight - 40, KWidth, 40))
    private lazy var doneBlock = {(userImageName:String, tips : String) -> Void in}
    var editData : MUAccountDetailModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.addButtons()
        SVProgressHUD.setDefaultMaskType(.Black)
    }
    private func addButtons() {
      
        
       let titleLabel = UILabel.init(frame: CGRectMake(0, KAccountItemWidthMargin, KWidth, KAccountItemWidthMargin))
        titleLabel.font = UIFont.systemFontOfSize(KBigFont)
        titleLabel.text = "备注"
        titleLabel.textAlignment = .Center
        self.view.addSubview(titleLabel)
        
        self.backButton.frame = CGRectMake(KAccountItemWidthMargin * 0.5, KAccountItemWidthMargin, 18, 18)
        self.backButton.setImage(UIImage.init(named: "btn_item_close_36x36_"), forState: .Normal)
        self.backButton.addTarget(self, action: "close", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        let lineView = UIView.init(frame: CGRectMake(0, KAccountItemWidthMargin * 2.0 + KlineViewLittleMargin, KWidth, 1))
        lineView.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(lineView)
        
        self.dateLabel.text = "2016年9月20日"
        self.dateLabel.textAlignment = .Left
        self.dateLabel.font = UIFont.systemFontOfSize(KTitleFont)
        self.dateLabel.textColor = UIColor.lightGrayColor()
        
        
        var frame = self.dateLabel.frame
        frame.origin.y += frame.size.height + 1
        frame.size.height = 200
        self.tipsTextView.frame = frame
        self.tipsTextView.font = UIFont.systemFontOfSize(KBigFont)
        self.tipsTextView.delegate = self
        
        self.keyBoardToolView.text = "0/40"
        self.keyBoardToolView.textAlignment = .Center
        self.keyBoardToolView.textColor = UIColor.lightGrayColor()
        self.view.addSubview(self.keyBoardToolView)
        self.keyBoardToolView.userInteractionEnabled = true
    
        openCameraButton.setImage(UIImage.init(named: "btn_camera_additem_44x44_"), forState: .Normal)
        openCameraButton.addTarget(self, action: "openCamera", forControlEvents: .TouchUpInside)
        openCameraButton.frame = CGRectMake(KAccountItemWidthMargin * 0.5, 5, 30, 30)
        openCameraButton.imageView?.layer.cornerRadius = 15.0
        self.keyBoardToolView.addSubview(openCameraButton)
        
        
        let doneButton = UIButton.init(type: .Custom)
        doneButton.setTitle("完成", forState: .Normal)
        doneButton.titleLabel?.font = UIFont.systemFontOfSize(KTitleFont)
        doneButton.setTitleColor(KOrangeColor, forState: .Normal)
        doneButton.addTarget(self, action: "done", forControlEvents: .TouchUpInside)
        doneButton.frame = CGRectMake(KWidth - 60 * KWidthScale, 5, 50 * KWidthScale, 30)
        doneButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        doneButton.layer.borderWidth = 1
        doneButton.layer.cornerRadius = 5.0
        self.keyBoardToolView.addSubview(doneButton)
        
        self.view.addSubview(self.dateLabel)
        self.view.addSubview(self.tipsTextView)
       
       
        if (self.editData != nil) {
            self.dateLabel.text = MUFMDBManager.manager.dateFormatter.stringFromDate(NSDate.init(timeIntervalSince1970: self.editData.time))
            if(!self.editData.userPictureName.isEmpty){
            self.openCameraButton.setImage(UIImage.init(named: (self.editData.userPictureName)), forState: .Normal)
            }
            self.keyBoardToolView.text = String.init(format: "%d/40", arguments: [ Int(String(self.editData.tipsString.endIndex))!])
            self.tipsTextView.text = self.editData.tipsString
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardShow:", name:UIKeyboardDidShowNotification, object: nil)
    }
    func setDoneBlock(block: (userImageName: String, tips : String) -> Void){
      self.doneBlock = block
    }
    //MARK: KeyBoardNotification
    @objc
    private func keyBoardShow(noti : NSNotification) {
       //print(noti.userInfo)
        let rect = noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect_ = rect.CGRectValue()
        UIView.animateWithDuration(0.25) { () -> Void in
            self.keyBoardToolView.frame.origin.y = rect_.origin.y - 40.0
        }
    
    }
    @objc
    private func close() {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    @objc
    private func done() {
    self.doneBlock(self.editData.userPictureName,self.tipsTextView.text)
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    @objc
    private func openCamera() {
        self.tipsTextView.resignFirstResponder()
        self.keyBoardToolView.frame.origin.y = KHeight - 40
        let VC = MUPromtViewController()
        let rect = CGRectMake(KAccoutTitleMarginToAmount, KHeight - 4 * 40 * KHeightScale - 10.0, KWidth - 2 * KAccoutTitleMarginToAmount,  4 * 40 * KHeightScale)
        VC.contentView = MUAlertView.init(frame: rect)
        VC.contentView._ViewType = viewType.sheetView
        VC.contentView.sheetButtonTitles = ["拍照","本地图片","删除本图片","取消"]
        VC.contentView.setSheetViewBlock { (tag) -> Void in
            
            
        }
        setWindowType(windowType.sheetWindow, rect: rect, controller: VC)
    }
    //MARK: TextViewDelegate
    func textViewDidChange(textView: UITextView) {
        let length = Int(String(textView.text.endIndex))
        
        
        if(length <= 40){
            self.keyBoardToolView.text = String.init(format: "%d/40", arguments: [length!])
            self.view.setNeedsDisplay()
        }else{
        
        SVProgressHUD.showErrorWithStatus("输入文字长度不能超过40！")
        self.keyBoardToolView.text = String.init(format: "%d/40", arguments: [40])
        textView.text = textView.text.substringWithRange(Range.init(start: textView.text.startIndex, end: textView.text.startIndex.advancedBy(40)))
        }
    }
    deinit {
      NSNotificationCenter.defaultCenter().removeObserver(self)
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
