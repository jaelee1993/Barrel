//
//  SurfTableViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 8/21/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class SurfTableViewCell: UITableViewCell {
    var barGraph:BarGraph!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        setupBarGraph()
    }
    fileprivate func setupBarGraph() {
        barGraph = BarGraph()
        barGraph.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(barGraph)
        barGraph.constraintsToSuperView(contentView, top: 0, bottom: 0, leading: 20, trailing: 20)
    }
    
    func configure(wave:[Wave]) {
        var cells:[BarCell] = []
        let total = 8.0
        for eachWave in wave {
            if let surf = eachWave.surf {
                if let max = surf.max {
                    let cell = BarCell(name: "\(max)", multiplier: max/total)
                    if let timestamp = eachWave.timestamp {
                        cell.otherData["timestamp"] = timestamp
                    }
                    cells.append(cell)
                }
            }
        }
        barGraph.cells = cells
    }

}
