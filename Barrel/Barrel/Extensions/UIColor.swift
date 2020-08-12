//
//  UIColor.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    static var hetro_white:UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.systemBackground
        } else {
           return UIColor.white
        }
    }
    static var hetro_black:UIColor {
       if #available(iOS 13.0, *) {
           return UIColor.label
        } else {
           return UIColor.black
        }
    }
    
    static var hetro_blue:UIColor {
       if #available(iOS 13.0, *) {
           return UIColor.systemBlue
        } else {
           return UIColor.blue
        }
    }
    static var hetro_red:UIColor {
       if #available(iOS 13.0, *) {
           return UIColor.systemRed
        } else {
           return UIColor.red
        }
    }
    
    static var hetro_labelColor:UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.label
        } else {
           return UIColor.black
        }
    }
    static var hetro_secondaryLabelColor:UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.secondaryLabel
        } else {
           return UIColor.darkGray
        }
    }
    
    static var hetro_systemGray:UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.systemGray
        } else {
           return UIColor.darkGray
        }
    }
    
    static var hetro_systemGray2:UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.systemGray2
        } else {
           return UIColor.darkGray
        }
    }
    
    static var hetro_systemGray3:UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.systemGray3
        } else {
           return UIColor.darkGray
        }
    }
    
    static var hetro_systemGray4:UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.systemGray4
        } else {
           return UIColor.darkGray
        }
    }
    
    static var hetro_systemGray5:UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.systemGray5
        } else {
           return UIColor.darkGray
        }
    }
    
    static var hetro_systemGray6:UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.systemGray6
        } else {
           return UIColor.darkGray
        }
    }
    
    static let oceanBlue:UIColor = UIColor(red: 0/255, green: 88/255, blue: 176/255, alpha: 1)
    
    
    
}
