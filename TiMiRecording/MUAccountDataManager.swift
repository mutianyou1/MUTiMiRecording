//
//  MUAccountDataManager.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/5.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit


class MUAccountDataManager: NSObject {
    
    static let manager = MUAccountDataManager()
    
    private override init() {
        super.init()
    }
    func getDataFromPlist(plistName: String, isPayment : Bool) -> [MUAccountDetailModel] {
      let path = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
      let array = NSMutableArray()
      let dict = NSDictionary.init(contentsOfFile: path!)
       
        for  key  in (dict?.allKeys)! {
           let data = MUAccountDetailModel()
            
           let subDict = NSMutableDictionary()
           
          subDict.setValue("tipsString", forKey: "tipsString")
          subDict.setValue(key, forKey: "accountTitleName")
          subDict.setValue(dict![key as! String]!["imageName"] as! String, forKey: "imageName")
          subDict.setValue(isPayment, forKey: "isPayment")
          subDict.setValue( "\(rand()%3000+1000)", forKey: "moneyAmount")
          data.setValuesForKeysWithDictionary(subDict.copy() as! [String : AnyObject])
          array.addObject(data)
        
        }
      return array.copy() as! [MUAccountDetailModel]
    }
}
