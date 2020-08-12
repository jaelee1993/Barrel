//
//  WindGraphView.swift
//  Barrel
//
//  Created by Jae Lee on 8/6/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit

class WindGraphView:UIView {
    var stackView:UIStackView!
    
    init() {
        super.init(frame: CGRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.constraintsToSuperView(self)
    }
    
    func configure(winds:[Wind]) {
        stackView.removeAllSubViews()
        for wind in winds {
            let windView = WindView()
            windView.configure(wind: wind)
            stackView.addArrangedSubview(windView)
        }
        
    }
}



class WindView:UIView {
    var windArrow:WindArrow!
    var time:UILabel!
    var speed:UILabel!
    
    init() {
        super.init(frame: CGRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        setupTime()
        setupSpeed()
        setupImageView()
    }
    func setupTime() {
        time = UILabel()
        time.textAlignment = .center
        time.translatesAutoresizingMaskIntoConstraints = false
        time.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        addSubview(time)
        NSLayoutConstraint.activate([
            time.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            time.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            time.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            time.heightAnchor.constraint(equalToConstant: 14)
        ])
            
    }
    func setupSpeed() {
           speed = UILabel()
           speed.textAlignment = .center
           speed.translatesAutoresizingMaskIntoConstraints = false
           speed.font = UIFont.systemFont(ofSize: 10, weight: .regular)
           addSubview(speed)
           NSLayoutConstraint.activate([
               speed.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
               speed.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
               speed.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
               speed.heightAnchor.constraint(equalToConstant: 14)
           ])
               
       }
    
    func setupImageView() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 3),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            container.bottomAnchor.constraint(equalTo: speed.topAnchor)
        ])
        
        
        windArrow = WindArrow()
        windArrow.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(windArrow)
        NSLayoutConstraint.activate([
            windArrow.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            windArrow.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            windArrow.heightAnchor.constraint(equalToConstant: 15),
            windArrow.widthAnchor.constraint(equalToConstant: 15),
        ])
        
        
        
    }
    
    
    
    func configure(time:Double, direction:Double) {
        
    }
    func configure(wind:Wind) {
        if let timestamp = wind.timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ha"
            time.text = dateFormatter.string(from: timestamp.convertUnixToDate())
        }
        if let direction = wind.direction {
            let radians = CGFloat(direction * Double.pi / 180)
            windArrow.layer.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
        } else {
            windArrow.isHidden = true
        }
        
        if let windSpeed = wind.speed {
            speed.text = "\(Int(round(windSpeed/1.852)))"
        }
        
    }
    
}
