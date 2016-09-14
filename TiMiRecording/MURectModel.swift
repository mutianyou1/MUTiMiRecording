//
//  MURectModel.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/13.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

class MURectModel: NSObject {

   var minWidth = CGFloat.init(0.0)
   var minHeight = CGFloat.init(0.0)
    func getStringHeight(stringWidth : CGFloat, stringSize : CGFloat) -> CGFloat {
        return 0.0
    }
}

extension String {
    
    func getStringHeight(stringWidth : CGFloat, content : NSAttributedString) -> CGFloat {
        var range = NSRange.init(location: 0, length:5)
        range.length = Int(String(self.endIndex))!
      
       let rect = content.boundingRectWithSize(CGSizeMake(stringWidth, CGFloat.init(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return rect.height
    }
    
}
