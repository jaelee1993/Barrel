//
//  SurfDataCollectionViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 8/17/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class SurfDataCollectionViewCell: UICollectionViewCell {
    var surfDataView:SingleForcastDataView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
            
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        setupSurfDataView()
    }
    fileprivate func setupSurfDataView() {
        surfDataView = SingleForcastDataView()
        surfDataView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(surfDataView)
        surfDataView.constraintsToSuperView(contentView)
    }
    
}
