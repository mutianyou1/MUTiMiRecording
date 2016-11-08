//
//  MUPaymentAnlalyseChart.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/23.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

public enum MUAccountChartViewType : Int {case CURVEVIEW = 0,CIRCLEVIEW}
class MUPaymentAnlalyseChart: UIView {
      var currentMonthDatas = [MUAccountDetailModel]()
      var lastMonthDatas = [MUAccountDetailModel]()
      var subViewsType = MUAccountChartViewType.CURVEVIEW
      var isAnimtaion  = true
      
      private let firstChartView = MUAccountSignleChartView.init(frame: CGRectZero)
      private let secondChartView = MUAccountSignleChartView.init(frame: CGRectZero)
      private let thirdChartView = MUAccountSignleChartView.init(frame: CGRectZero)
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func setUI() {
        
        self.firstChartView.isCurveChart = true
        self.secondChartView.isCurveChart = true
        self.thirdChartView.isCurveChart = true
        
        self.firstChartView.removeFromSuperview()
        self.secondChartView.removeFromSuperview()
        self.thirdChartView.removeFromSuperview()
        
        if self.subViewsType == MUAccountChartViewType.CIRCLEVIEW || self.lastMonthDatas.isEmpty{
           self.firstChartView.isCurveChart = false
           self.secondChartView.isCurveChart = false
           self.thirdChartView.isCurveChart = false
        }
     
        let arrayViews = [firstChartView,secondChartView,thirdChartView]
        let data = MUAccountDetailModel()
        data.accountTitleName = "无分类"
        data.moneyAmount = 80
        let data1 = MUAccountDetailModel()
        data1.accountTitleName = "第二个"
        data1.moneyAmount = 50
        self.currentMonthDatas.append(data1)
        self.currentMonthDatas.append(data)
        self.currentMonthDatas.append(data)
        
        
        
        for data in self.currentMonthDatas {
            let index_ = self.currentMonthDatas.indexOf(data);
            if(index_ >= 3){
                return
            }
            let view = arrayViews[index_!]
            view.accountTitleName = data.accountTitleName
            view.payment = data.moneyAmount
            view.totalORlastMonthPayment = 100
            
            self.addSubview(view)
            view.frame = CGRectMake( CGFloat.init(index_!) * KWidth / 3.0, 0, KWidth / 3.0, self.bounds.size.height)
            view.setUI()
            
            
        }
      
      
//        if index < 1 {
//            self.secondChartView.frame = CGRectMake(  KWidth / 3.0, 0, KWidth / 3.0, self.bounds.size.height)
//            //self.secondChartView.accountTitleName = "第二个"
//            self.secondChartView.totalORlastMonthPayment = 100.0
//            self.secondChartView.payment = 50.0
//            self.addSubview(self.secondChartView)
//            self.secondChartView.setUI()
//            
//            self.thirdChartView.frame = CGRectMake( 2 * KWidth / 3.0, 0, KWidth / 3.0, self.bounds.size.height)
//            self.thirdChartView.payment = 100.0
//            self.thirdChartView.totalORlastMonthPayment = 100.0
//            self.addSubview(self.thirdChartView)
//            self.thirdChartView.setUI()
//        }
        if self.subViewsType != MUAccountChartViewType.CIRCLEVIEW {
          
        
        }
        
    
    }
    func startAnimations() {
        if self.isAnimtaion == false {
           return
        }
    
            self.firstChartView.startAnimtaion()
            self.secondChartView.startAnimtaion()
            self.thirdChartView.startAnimtaion()
        
    
      
        
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
