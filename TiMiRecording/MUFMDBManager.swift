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
     private var data = FMDatabase.init()
     private override init() {
        super.init()
        self.openDataBase()
        self.creatTable()
    }
    private func openDataBase() {

      var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
       path?.appendContentsOf("accountInfo.db")
       self.data = FMDatabase.init(path: path)
       self.data.open()
    }
    private func creatTable() {
      
        let statement = String.init(format: "create table if not exists %@(time text,date text,accountTitleName text,tipsString text,thumbnailName text,userPictureName text,moneyAmount text,monthAmount text,dayAmount text,primary key(time))", arguments: ["commonAccountTable"])
     
        self.data.executeStatements(statement)
    }
    func addTable(name:String) {
        let statement = String.init(format: "create table if not exists %@(time text,date text,accountTitleName text,tipsString text,thumbnailName text,userPictureName text,moneyAmount text,monthAmount text,dayAmount text,primary key(time))", arguments: [name])
        
        self.data.executeStatements(statement)
    }
    func insetData(data: MUAccountDetailModel,tableName: String) -> Bool{
        let statement = String.init(format: "insert into  %@(time ,date ,accountTitleName ,tipsString ,thumbnailName ,userPictureName ,moneyAmount ,monthAmount,dayAmount) values('%@','')", arguments: ["commonAccountTable"])
        
       return self.data.executeStatements(statement)
        
    }
    func removeData(data:MUAccountDetailModel,tableName: String)-> Bool {
        let statement = String.init(format: "create table if not exists %@(time text,date text,accountTitleName text,tipsString text,thumbnailName text,userPictureName text,moneyAmount text,monthAmount text,dayAmount text,primary key(time))", arguments: ["commonAccountTable"])
        
        return self.data.executeStatements(statement)
    }
    func removeAll(tableName: String) -> Bool{
        let statement = String.init(format: "create table if not exists %@(time text,date text,accountTitleName text,tipsString text,thumbnailName text,userPictureName text,moneyAmount text,monthAmount text,dayAmount text,primary key(time))", arguments: ["commonAccountTable"])
        
        return self.data.executeStatements(statement)
    }
    func selectDatas(user : String,tableName: String) -> [MUAccountDetailModel]{
      return [MUAccountDetailModel()]
    }
    
  
}
