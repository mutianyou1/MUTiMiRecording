//
//  MUAccountEditItemCell.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/5.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

class MUAccountEditItemCell: UICollectionViewCell ,UITextViewDelegate{
    private let thumbImageView = UIImageView.init()
    private let titleLabel = UILabel.init()
   
    private  lazy  var   block = {(data :MUAccountDetailModel, layer : CALayer ) in }
    private lazy var data = MUAccountDetailModel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        thumbImageView.frame = CGRectMake(KAccoutTitleMarginToAmount * 0.5, 0, self.bounds.size.width - KAccoutTitleMarginToAmount, self.bounds.size.height - KAccoutTitleMarginToAmount);
        self.addSubview(thumbImageView)
        
        titleLabel.frame = CGRectMake(0, self.bounds.size.height - KAccoutTitleMarginToAmount, self.bounds.size.width, KAccoutTitleMarginToAmount)
        titleLabel.font = UIFont.systemFontOfSize(KTitleFont)
        titleLabel.textAlignment = .Center
        self.addSubview(titleLabel)
        
        let tap = UITapGestureRecognizer.init(target: self, action: "tapCell")
        self.addGestureRecognizer(tap)
     
    }
    func loadItemData(data : MUAccountDetailModel) {
        self.data = data
        self.titleLabel.text = data.accountTitleName
        self.thumbImageView.image = UIImage.init(named: data.thumbnailName)
    }
    func setBlock(block :  ((MUAccountDetailModel ,CALayer) -> Void)) {
        self.block = block
    }
    func tapCell() {
        self.block(self.data,self.thumbImageView.layer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
