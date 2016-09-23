//
//  MUAccountDetailModel.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/2.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit




class MUAccountDetailModel: NSObject ,NSCopying{
    var accountTitleName = "家居test"
    var moneyAmount :Double = Double.init(floatLiteral: 0.0)
    var tipsString = ""
    var thumbnailName = ""
    var userPictureName = ""
    var date = ""
    var time : Double = NSDate.init(timeIntervalSinceNow: 0).timeIntervalSince1970
    
    var index : Int = 0
    var statusCode : Int = 0
    var editable = false
    var isPayment = true
    
    override func  setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    func copyWithZone(zone: NSZone) -> AnyObject {
        let data = MUAccountDetailModel()
        data.time = self.time
        data.accountTitleName = self.accountTitleName
        data.tipsString = self.tipsString
        data.isPayment = self.isPayment
        data.thumbnailName = self.thumbnailName
        data.userPictureName = self.userPictureName
        data.date = self.date
        data.moneyAmount = self.moneyAmount
        
        return data
    }
}

class MUAccountDayDetailModel: NSObject {
    var date = "9月1日"
    var month = "9月"
    var allCount : Int32 = 0
    var payment : Double = 0.0
}
