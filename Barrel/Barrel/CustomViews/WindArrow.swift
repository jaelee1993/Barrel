//
//  WindArrow.swift
//  Barrel
//
//  Created by Jae Lee on 8/8/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class WindArrow: UIView {
    var fillColor:UIColor = .hetro_black
    var strokeColor:UIColor = .hetro_black
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawArrow()
    }
    
    func drawArrow() {
        let width = self.frame.width
        let height = self.frame.height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.5 * width, y: 0 * height))
        path.addLine(to: CGPoint(x: 0.333 * width, y: 0.417 * height))
        path.addLine(to: CGPoint(x: 0.10 * width, y: 0.417 * height))
        path.addLine(to: CGPoint(x: 0.5 * width, y: 1 * height))
        path.addLine(to: CGPoint(x: 0.9 * width, y: 0.417 * height))
        path.addLine(to: CGPoint(x: 0.667 * width, y: 0.417 * height))
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        
        // Set up the appearance of the shape layer
        layer.strokeEnd = 1
        layer.lineWidth = 1
        layer.fillColor = UIColor.oceanBlue.cgColor
        layer.strokeColor = UIColor.oceanBlue.cgColor
        
        self.layer.addSublayer(layer)
    }
}
