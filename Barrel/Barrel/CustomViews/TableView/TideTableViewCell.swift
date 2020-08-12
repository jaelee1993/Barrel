//
//  TideTableViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 7/25/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class TideTableViewCell: UITableViewCell {
    var graphView:LineGraphView!
    var dateLabel:UILabel!
    var graphPoints:[LineGraphViewPoint] = [LineGraphViewPoint(point: CGPoint())]
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        setupLabel()
        setupLineGraph()
    }
    
    fileprivate func setupLabel() {
        dateLabel = UILabel()
        dateLabel.text = ""
        dateLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
    
    fileprivate func setupLineGraph() {
        graphView = LineGraphView(frame: self.frame, fillColor: .oceanBlue, strokeColor: .oceanBlue, graphPoints: graphPoints)
        graphView.backgroundColor = UIColor.hetro_white.withAlphaComponent(0.0)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.delegate = self
        contentView.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            graphView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            graphView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            graphView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
        
    }
    
    func configure(tides:[Tide]) {
        var points:[LineGraphViewPoint] = []
        
        for tide in tides {
            if let heightInFeet = tide.height?.inFeet, let date = tide.timestamp?.convertUnixToDate() {
                points.append(LineGraphViewPoint(point: CGPoint(), value: heightInFeet, date: date, other: nil))
                
            }
        }
        graphPoints = points
        graphView.resetGraphPoints(graphViewPoints: graphPoints, customMaximumValue: 6.5)
        
        
    }
}


extension TideTableViewCell:LineGraphViewDelegate {
    func graphViewIsSet(_ graphViewPoint: LineGraphViewPoint) {
        if let date = graphViewPoint.date {
            dateLabel.text = "\(DateService.convertDate(date, format: DateService.F1))"
        }
    }
    
    func graphViewIsFinishedScrolling() {
        dateLabel.text = ""
    }
    
    
}
