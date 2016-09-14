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
    var isPayment = true
    var moneyAmount = "7000"
    var tipsString = "我在星巴克消费的休闲时光"
    var thumbnailName = "image_"
    var userPictureName = "image_"
    var index : Int = 0
    var statusCode : Int = 0
    var editable = false
    var time = "2016年12月5日21:56:34"
    override func  setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
