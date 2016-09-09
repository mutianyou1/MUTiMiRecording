//
//  MUPromtViewController.swift
//  MUWindow
//
//  Created by 潘元荣(外包) on 16/6/16.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

class MUPromtViewController: UIViewController {
    var contentView = MUAlertView.init(frame: CGRectZero)
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.view.backgroundColor = UIColor.redColor()
        contentView.frame = self.view.bounds
        self.view.layer.cornerRadius = 10
        self.view.addSubview(contentView)
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
