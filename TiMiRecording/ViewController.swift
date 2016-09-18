//
//  ViewController.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/8/31.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit



class ViewController: UIViewController,TopBackgroundImageViewDelegate{
    private let topView = TopBackgroundImageView()
    private lazy var detailItemTableView = AccountDetailItemTableView.init(frame: CGRectMake(0, 300 * KHeightScale, KWidth, KHeight - 300 * KHeightScale), style: .Plain)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.topView.frame = CGRectMake(0, 0, KWidth, 300 * KHeightScale)
        self.topView.backImageName = "background7_375x155_"
        topView.delegate = self
        self.view.addSubview(topView)
        topView.configSubViews()
        
        self.setUpTabelView()
        
     
    }
    private func setUpTabelView() {

      self.view.addSubview(self.detailItemTableView)
      self.detailItemTableView.setSpringAnimationBlock {[unowned self] (height) -> Void in
        
        if height > 0.0 {
            self.topView.animatiedAddButton(height/CGFloat.init(110.0))
        }else{
           self.topView.resetAccountAddButtonTrasnform()
        }
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    func presentAccountDetailEditingViewController() {
           self.presentViewController(AccountDetailEditingViewController(), animated: true, completion: nil)
       
        
    }
    func openCarmera() {
        print("open carmera")
    }
}
