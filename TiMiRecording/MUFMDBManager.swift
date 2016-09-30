//
//  MUFMDBManager.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/13.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

class MUFMDBManager: NSObject {
     static let manager = MUFMDBManager.init()
     private var dataBase = FMDatabase.init()
     private var thisYear = "2016"
     let dateFormatter = NSDateFormatter.init()
     private override init() {
        super.init()
        self.dateFormatter.dateFormat = "YYYY年M月dd日"
        thisYear = self.dateFormatter.stringFromDate(NSDate.init(timeIntervalSinceNow: 0.0))
        thisYear = thisYear.substringToIndex(thisYear.startIndex.advancedBy(4))
        self.openDataBase()
        self.creatTable()
    }
    private func openDataBase() {

//      var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
//           path?.appendContentsOf("accountInfo.db")
        let path = NSHomeDirectory().stringByAppendingString("/Documents/KCommonAccountTable")
       self.dataBase = FMDatabase(path: path)
        if(self.dataBase.open()==false){
          print("open failed",path)
        }else{
          print("open success")
        }
    }
    private func creatTable() {
      
        let statement = String.init(format: "create table if not exists %@(time double,date text,month text,accountTitleName text,tipsString text,thumbnailName text,userPictureName text,expend double,income double,primary key(time))", arguments: ["commonAccountTable"])
     
        self.dataBase.executeStatements(statement)
    }
    func addTable(name:String) {
        let statement = String.init(format: "create table if not exists %@(time double,date text,month text,accountTitleName text,tipsString text,thumbnailName text,userPictureName text,expend double,income double,primary key(time))", arguments: [name])
        
        self.dataBase.executeStatements(statement)
    }
    func insetData(data: MUAccountDetailModel,tableName: String) -> Bool{
        var dateString = self.dateFormatter.stringFromDate(NSDate.init(timeIntervalSince1970: data.time))
        var month = dateString.substringToIndex(dateString.startIndex.advancedBy(7))
        
        if (dateString.containsString(thisYear)){
            dateString = dateString.substringFromIndex(dateString.startIndex.advancedBy(5))
            month = month.substringFromIndex(month.startIndex.advancedBy(5))
        }
        let expend : Double = data.moneyAmount > 0.0 ? 0.0 : data.moneyAmount
        let income : Double = data.moneyAmount > 0.0 ? data.moneyAmount : 0.0
        let statement = String.init(format: "insert into  %@(time ,date ,month,accountTitleName ,tipsString ,thumbnailName ,userPictureName ,expend,income) values('%lf','%@','%@','%@','%@','%@','%@','%lf','%lf')", arguments: [tableName,data.time,dateString,month,data.accountTitleName,data.tipsString,data.thumbnailName,data.userPictureName,expend,income])
       return self.dataBase.executeStatements(statement)
       
    }
   //MARK: select
    func selectDatas(tableName: String) -> [MUAccountDetailModel]{
        let statement = String.init(format: "select * from %@   order by time desc", arguments: [tableName])
        let set = self.dataBase.executeQuery(statement, withArgumentsInArray: [tableName])
        var array = [MUAccountDetailModel]()
        while(set.next()){
            let data = MUAccountDetailModel()
             data.date = set.stringForColumn("date")
             data.accountTitleName = set.stringForColumn("accountTitleName")
             data.userPictureName = set.stringForColumn("userPictureName")
             data.tipsString = set.stringForColumn("tipsString")
             data.time = set.doubleForColumn("time")
             data.thumbnailName = set.stringForColumn("thumbnailName")
            let income : Double = set.doubleForColumn("income")
            if(income > 0.0){
               data.moneyAmount = income
               data.isPayment = false
            }else{
               data.moneyAmount = set.doubleForColumn("expend")
            }
             array.append(data)
            
        }
        
      return array
    }
    func getDayItemsAccount(tableName:String , date : String)-> [MUAccountDetailModel] {
        let statement = String.init(format: "select * from %@ where date ='%@' order by time desc", arguments: [tableName,date])
        let set = self.dataBase.executeQuery(statement ,withArgumentsInArray: [tableName])
        
        var dataArray = [MUAccountDetailModel]()
        while(set.next()){
            let data = MUAccountDetailModel()
            data.date = set.stringForColumn("date")
            data.accountTitleName = set.stringForColumn("accountTitleName")
            data.userPictureName = set.stringForColumn("userPictureName")
            data.tipsString = set.stringForColumn("tipsString")
            data.time = set.doubleForColumn("time")
            data.thumbnailName = set.stringForColumn("thumbnailName")
            let income : Double = set.doubleForColumn("income")
            if(income > 0.0){
                data.moneyAmount = income
                data.isPayment = false
            }else{
                data.moneyAmount = set.doubleForColumn("expend")
            }
            dataArray.append(data)
        }
        return dataArray
    }
    func getDayItemsAccount(tableName : String) -> [MUAccountDayDetailModel] {
      let statement = String.init(format: "SELECT date,month,sum(expend) , count(expend)  from %@ GROUP BY date  ORDER BY time desc ", arguments: [tableName])
      let set = self.dataBase.executeQuery(statement ,withArgumentsInArray: [tableName])
      
      var countArray = [MUAccountDayDetailModel]()
       while(set.next()){
           let data = MUAccountDayDetailModel()
               data.date = set.stringForColumn("date")
               data.month = set.stringForColumn("month")
               data.allCount = set.intForColumn("count(expend)")
               data.payment = set.doubleForColumn("sum(expend)")
               countArray.append(data)
        }
         return countArray
    }
    //MARK: search amount
    func searchTotoalAccountBalance(tableName : String, month:String)-> [Double] {
        var incomeAmount = 0.0
        var payment = 0.0
        var statement = String.init(format: "SELECT sum(expend),sum(income)   from %@ ", arguments: [tableName])
        if(!month.isEmpty) {
             statement = String.init(format: "SELECT sum(expend),sum(income)   from %@ where month = '%@'", arguments: [tableName,month])
        }
        let set = self.dataBase.executeQuery(statement, withArgumentsInArray: [tableName])
        while(set.next()) {
             incomeAmount = set.doubleForColumn("sum(income)")
             payment =  set.doubleForColumn("sum(expend)")
        }
        return [incomeAmount,payment,incomeAmount + payment]
    }
    
    func searchForAccountMonth(date : String , tableName : String) -> String {
      let statement = String.init(format: "SELECT  month  from %@   where date= '%@'", arguments: [tableName,date])
       let set = self.dataBase.executeQuery(statement, withArgumentsInArray: [tableName])
        while(set.next()){
           return set.stringForColumn("month")
        }
        return "9月"
     
    }
    func searchTopThreePaymentAccountItemByMonth(month : String,tableName : String) -> [MUAccountDetailModel] {
        let statement = String.init(format: "SELECT month,  accountTitleName ,thumbnailName,sum(expend)  from %@ where month ='%@'   GROUP BY accountTitleName ORDER BY sum(expend) asc ", arguments: [tableName,month])
        let set = self.dataBase.executeQuery(statement ,withArgumentsInArray: [tableName])
        
        var dataArray = [MUAccountDetailModel]()
        var number = 0
        while(set.next()){
            if number >= 3 {
               break
            }
            let data = MUAccountDetailModel()
            data.accountTitleName = set.stringForColumn("accountTitleName")
            data.thumbnailName = set.stringForColumn("thumbnailName")
            let income : Double = set.doubleForColumn("sum(expend)")

            data.moneyAmount = income * -1.0
            number += 1
            dataArray.append(data)
        }
        return dataArray
    }
    //MARK: remove Data
    func removeData(data:MUAccountDetailModel,tableName: String)-> Bool {
        let statement = String.init(format: "delete from %@  where time = %lf", arguments: [tableName,data.time])
        return self.dataBase.executeStatements(statement)
    }
    func removeTable(tableName: String) -> Bool{
        let statement = String.init(format: "drop table if exists  %@", arguments: [tableName])
        
        return self.dataBase.executeStatements(statement)
    }
    //MARK: update Data
    func updateData(data: MUAccountDetailModel ,time : Double ,tableName: String )-> Bool {
        var dateString = self.dateFormatter.stringFromDate(NSDate.init(timeIntervalSince1970: data.time))
        var month = dateString.substringToIndex(dateString.startIndex.advancedBy(7))
        
        if (dateString.containsString(thisYear)){
            dateString = dateString.substringFromIndex(dateString.startIndex.advancedBy(5))
            month = month.substringFromIndex(month.startIndex.advancedBy(5))
        }
        let expend : Double = data.moneyAmount > 0.0 ? 0.0 : data.moneyAmount
        let income : Double = data.moneyAmount > 0.0 ? data.moneyAmount : 0.0
        let statement = String.init(format: "update  %@ set time = '%lf', date = '%@', month='%@',accountTitleName='%@', tipsString ='%@' ,thumbnailName='%@', userPictureName='%@', expend='%lf' ,income='%lf' where time = %lf", arguments: [tableName,data.time,dateString,month,data.accountTitleName,data.tipsString,data.thumbnailName,data.userPictureName,expend,income,time])
        return self.dataBase.executeStatements(statement)
    }
  
}
