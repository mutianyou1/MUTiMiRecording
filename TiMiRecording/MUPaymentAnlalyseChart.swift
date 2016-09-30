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
        if self.subViewsType == MUAccountChartViewType.CIRCLEVIEW || self.lastMonthDatas.isEmpty{
           self.firstChartView.isCurveChart = false
           self.secondChartView.isCurveChart = false
           self.thirdChartView.isCurveChart = false
        }
        var index : Int = 0
        let arrayViews = [firstChartView,secondChartView,thirdChartView]
        for data in self.currentMonthDatas {
            let view = arrayViews[index]
            view.accountTitleName = data.accountTitleName
            view.payment = data.moneyAmount
            view.totalORlastMonthPayment = 300.00
            self.addSubview(view)
            view.frame = CGRectMake( CGFloat.init(index) * KWidth / 3.0, 0, KWidth / 3.0, self.bounds.size.height)
            view.setUI()
            
            index += 1
            
        }
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
