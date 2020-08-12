//
//  GradientView.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//
import Foundation
import UIKit



class GradientViewHorizontal: UIView {
    
    // Default Colors
    var colors:[CGColor] = []
    var gradient:CAGradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        
        // Must be set when the rect is drawn
        setGradient()
    }
    
    func setGradient() {
        gradient.colors = colors
        
        gradient.transform = CATransform3DMakeRotation(CGFloat.pi * 3/2, 0, 0, 1)
        gradient.frame = self.bounds
        // Draw Path
        self.layer.addSublayer(gradient)
        
    }
    
    override func layoutSubviews() {
        
        // Ensure view has a transparent background color (not required)
        backgroundColor = UIColor.clear
    }
    
    public func resetGradientColors(colors:[CGColor]) {
           self.colors = colors
           setNeedsDisplay()
    }
    
}

class GradientViewVertical: UIView {
    
    // Default Colors
    var colors:[CGColor] = []
    var gradient:CAGradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        
        // Must be set when the rect is drawn
        setGradient()
    }
    
    func setGradient() {
        gradient.colors = colors
        
        gradient.transform = CATransform3DMakeRotation(CGFloat.pi * 1, 0, 0, 1)
        gradient.frame = self.bounds
        // Draw Path
        self.layer.addSublayer(gradient)
        
    }
    
    override func layoutSubviews() {
        
        // Ensure view has a transparent background color (not required)
        backgroundColor = UIColor.clear
    }
    
    public func resetGradientColors(colors:[CGColor]) {
           self.colors = colors
           setNeedsDisplay()
    }
    
}
