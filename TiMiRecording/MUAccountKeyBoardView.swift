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
class MUAccountKeyBoardView: UIView {

    
    private let amount = "1200"
    private let dateButton = UIButton.init(type: .Custom)
    private let editMessageButton = UIButton.init(type: .Custom)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        for   index   in 0...11  {
             let button = UIButton.init(type: .Custom)
                 button.frame = CGRectMake(CGFloat.init(index % 3) * MUKeyBoardbuttonWidth, MUKeyBoardTopMargin +  CGFloat.init(index / 3) * MUKeyBoardbuttonHeight, MUKeyBoardbuttonWidth, MUKeyBoardbuttonHeight)
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
            button.titleLabel?.textAlignment = .Center
            button.setTitle(MUKeyBoardTitleArray[index], forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            //button.titleLabel?.font = UIFont.systemFontOfSize(28 * KHeightScale)
            button.titleLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Thin", size: 28 * KHeightScale)
            button.addTarget(self, action: "inputAmount:", forControlEvents: .TouchUpInside)
            self.addSubview(button)
        }
        
        let backView = UIView.init(frame:CGRectMake(0 , 0, KWidth, MUKeyBoardTopMargin))
        backView.backgroundColor = UIColor.lightGrayColor()
        backView.alpha = 0.5
        self.dateButton.frame = CGRectMake(10 * KWidthScale, 0, 80 * KWidthScale, MUKeyBoardTopMargin)
        self.dateButton.titleLabel?.font = UIFont.systemFontOfSize(7 * KHeightScale)
        //self.dateButton.contentMode = .Top
        self.dateButton.titleLabel?.contentMode = .ScaleAspectFill
        self.dateButton.titleEdgeInsets.top = -20.0
        //self.dateButton.backgroundColor = KSkyColor
        self.addSubview(backView)
        self.addSubview(dateButton)
        
        self.editMessageButton.frame = CGRectMake(KWidth - MUKeyBoardbuttonWidth,MUKeyBoardTopMargin ,MUKeyBoardbuttonWidth , MUKeyBoardbuttonHeight * 2.0)
       self.editMessageButton.setImage(UIImage.init(named: "addItem_remark_18x20_"), forState: .Normal)
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
          okButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
          okButton.addTarget(self, action: "clickOK", forControlEvents: .TouchUpInside)
          self.addSubview(okButton)
        
        
    }
    func setUpUI(date : String , hiligtedMessageButton : String) {
    self.dateButton.setTitle(date, forState: .Normal)
        
    if(hiligtedMessageButton.isEmpty){
         return
    }
    self.editMessageButton.setImage(UIImage.init(named: hiligtedMessageButton), forState: .Normal)
       
    
    }
    //MARK: button methods
    func inputAmount(sender : UIButton) {
    
    }
    func startEditMessage() {
    
    }
    func clickOK() {
    
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
