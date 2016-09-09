//
//  MUAccountDataManager.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/5.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

enum MUAccountItemStatus : Int {case SHOW_EDIT = -1,SHOW_MUST, SHOW_NORAML,HIDDEN}
class MUAccountDataManager: NSObject {
    
    static let manager = MUAccountDataManager()
    
    private override init() {
        super.init()
    }
    func getDataFromPlist(plistName: String, isPayment : Bool) -> [MUAccountDetailModel] {
      let path = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
        
      var array = Array<MUAccountDetailModel>()
        
      let dict = NSDictionary.init(contentsOfFile: path!)
       
        for  key  in (dict?.allKeys)! {
           let data = MUAccountDetailModel()
            
            
           let subDict = NSMutableDictionary()
            let string = key as! String
            if(!string.containsString("自定义")){
          subDict.setValue("tipsString", forKey: "tipsString")
          subDict.setValue(key, forKey: "accountTitleName")
          subDict.setValue(dict![key as! String]!["imageName"] as! String, forKey: "thumbnailName")
          subDict.setValue(isPayment, forKey: "isPayment")
          subDict.setValue( "¥00.00", forKey: "moneyAmount")
          subDict.setValue(dict![key as! String]!["index"] as! NSNumber, forKey: "index")
          subDict.setValue(dict![key as! String]!["statusCode"] as! NSNumber, forKey: "statusCode")
          subDict.setValue(dict![key as! String]!["editable"] as! Bool, forKey: "editable")
          data.setValuesForKeysWithDictionary(subDict.copy() as! [String : AnyObject])
          array.append(data)
        }
        }
        array.sortInPlace { (data1 : MUAccountDetailModel, data2 : MUAccountDetailModel) -> Bool in
            if (data1.index < data2.index){
               return true
            }
            return false
        }
        
      return array
    }
}
