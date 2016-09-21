//
//  MUAccountDetailModel.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/2.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit




class MUAccountDetailModel: NSObject {
    var accountTitleName = "家居test"
    var moneyAmount :Double = 0.00
    var tipsString = "我在星巴克消费的休闲时光，时间静止唯有想你"
    var thumbnailName = "image_"
    var userPictureName = "image_"
    var date = "9月1日"
    var time : Double = NSDate.init(timeIntervalSinceNow: 0).timeIntervalSince1970
    
    var index : Int = 0
    var statusCode : Int = 0
    var editable = false
    var isPayment = true
    
    override func  setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

class MUAccountDayDetailModel: NSObject {
    var date = "9月1日"
    var month = "9月"
    var allCount : Int32 = 0
    var payment : Double = 0.0
}
