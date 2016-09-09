//
//  MUAccountEditCollectionView.swift
//  TiMiRecording
//
//  Created by 潘元荣(外包) on 16/9/5.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

import UIKit

let KMUAccountEditCollectionCell = "MUAccountEditCollectionCell"

class MUAccountEditCollectionView: UICollectionView ,UICollectionViewDataSource,UICollectionViewDelegate{
 
    lazy var itemArray  = NSMutableArray()
    lazy var block = {(data_ : MUAccountDetailModel, layer : CALayer, row : Int ,offSize : CGPoint) in }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let newLayout = UICollectionViewFlowLayout.init()
        newLayout.scrollDirection = .Horizontal
        newLayout.itemSize = CGSizeMake(KAccountItemHeight, KAccountItemHeight)
        newLayout.minimumLineSpacing = KAccountItemWidthMargin
        newLayout.minimumInteritemSpacing = 0.0
        
        super.init(frame: frame, collectionViewLayout: newLayout)
        self.dataSource = self
        self.delegate = self
        self.pagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.registerClass(MUAccountEditItemCell.self, forCellWithReuseIdentifier: KMUAccountEditCollectionCell)
        self.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: collectionView delegate
    override func numberOfSections() -> Int {
        
        return 1;
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(KMUAccountEditCollectionCell, forIndexPath: indexPath) as! MUAccountEditItemCell
        if(cell.isKindOfClass(NSNull.self)) {
            cell = MUAccountEditItemCell.init(frame: CGRectMake(0, 0, KAccountItemHeight,KAccountItemHeight))
        }
        
    cell.loadItemData(itemArray.objectAtIndex(indexPath.row) as! MUAccountDetailModel)
        cell.setBlock {[unowned  self] (data : MUAccountDetailModel, layer :CALayer) -> Void in
           self.block(data,layer,indexPath.row, self.contentOffset)
           self.pagingEnabled = false
        }
        //cell.backgroundColor = UIColor.blackColor()
        return cell
    }
    func setCollectionViewBlock(block : (data : MUAccountDetailModel, layer : CALayer, row : Int, offSize : CGPoint) -> Void) {
       self.block = block
       
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let data = MUAccountDetailModel()
        //let page : Int = scrollView.contentOffset.y
        self.block(data,CALayer(),0, scrollView.contentOffset)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
