//
//  ForcastDataTableViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 8/17/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class ForcastDataTableViewCell: UITableViewCell {
    var carouselForcastDataView:CarouselForcastDataView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        setupCarouselSurfDataView()
    }
    fileprivate func setupCarouselSurfDataView() {
        carouselForcastDataView = CarouselForcastDataView()
        carouselForcastDataView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(carouselForcastDataView)
        carouselForcastDataView.constraintsToSuperView(contentView)
    }
}
