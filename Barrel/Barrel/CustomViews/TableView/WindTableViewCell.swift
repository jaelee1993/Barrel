//
//  WindTableViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 8/6/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class WindTableViewCell: UITableViewCell {
    var windGraph:WindGraphView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        setupWindGraph()
    }
    fileprivate func setupWindGraph() {
        windGraph = WindGraphView()
        windGraph.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(windGraph)
        windGraph.constraintsToSuperView(contentView, top: 0, bottom: 0, leading: 20, trailing: 20)
    }
    
    func configure(wind:[Wind]) {
        windGraph.configure(winds: wind)
    }

}
