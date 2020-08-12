//
//  UIView.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//
import Foundation
import UIKit

//MARK: - View
extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius:CGFloat, fillCollor: CGColor! = nil, strokeColor: CGColor! = nil) {
        let bounds = self.bounds
        let maskPath:UIBezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer:CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        let frameLayer = CAShapeLayer()
        frameLayer.frame = bounds
        frameLayer.path = maskPath.cgPath
        frameLayer.strokeColor = strokeColor
        frameLayer.lineWidth = 1
        frameLayer.fillColor = fillCollor
        
        self.layer.addSublayer(frameLayer)
    }
    
    
    func roundAllCorners(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func constraintsToSafeArea(_ superView:UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor),
            ])
    }
    func constraintsToSuperView(_ superView:UIView, constant:CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: constant),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -constant),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: constant),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -constant),
            ])
    }
    
    func constraintsToSuperView(_ superView:UIView, topBottom:CGFloat = 0, leadingTrailing:CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: topBottom),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -topBottom),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leadingTrailing),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -leadingTrailing),
            ])
    }
    func constraintsToSuperView(_ superView:UIView, top:CGFloat = 0, bottom:CGFloat = 0, leading:CGFloat = 0, trailing:CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -bottom),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leading),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -trailing),
            ])
    }
    
    
    func dropShadow(_ color:UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 0.9
    }
    func dropShadow(_ color:UIColor, offset:CGSize) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 0.9
    }
    
    func dropShadow(_ color:UIColor, offset:CGSize, cornerRadius:CGFloat, shadowRadius:CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = shadowRadius
    }
    
    /**
     This function draws gradient
    */
    func drawGradient(_ colorTop:UIColor, _ colorBottom:UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = frame
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }


    
    
    
    func drawBottomBorder(_ rect:CGRect) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:0, y:rect.maxY))
        
        path.addLine(to: CGPoint(x:rect.maxX, y:rect.maxY))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        shapeLayer.lineWidth = 0.4
        
        self.layer.addSublayer(shapeLayer)
        
        self.setNeedsDisplay()
    }
    func drawTopBorder() {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:0, y:bounds.minY))
        
        path.addLine(to: CGPoint(x:bounds.maxX, y:bounds.minY))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        shapeLayer.lineWidth = 1
        
        self.layer.addSublayer(shapeLayer)
        
        self.setNeedsDisplay()
    }
    
    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }
        
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
    
    
    //Removes all subview from view
    func removeAllSubViews(){
        for v in self.subviews{
            v.removeFromSuperview()
        }
    }
    
    var userInterfaceStyle:UIUserInterfaceStyle {
        if #available(iOS 13.0, *) {
           return traitCollection.userInterfaceStyle
        } else {
           return UIUserInterfaceStyle.light
        }
    }
}
