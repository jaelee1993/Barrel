//
//  String.swift
//  Barrel
//
//  Created by Jae Lee on 7/24/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit


//MARK: - String
extension String {
  
    
    func indexAt(_ theInt:Int)->String.Index {
        return self.index(self.startIndex, offsetBy: theInt)
    }
    
    
    func getDisplayCondition() -> String {
        switch self {
        case "FLAT":
            return "FLAT"
        case "VERY_POOR":
            return "VERY POOR"
        case "POOR":
                return "POOR"
        case "POOR_TO_FAIR":
                return "POOR TO FAIR"
        case "FAIR":
                return "FAIR"
        case "FAIR_TO_GOOD":
                return "FAIR TO GOOD"
        case "GOOD":
                return "GOOD"
        case "GOOD_TO_EPIC":
                return "GOOD TO EPIC"
        case "EPIC":
                return "EPIC"
        default:
            return "N/A"
        }
    }
    func getColorForCondition() -> UIColor {
        switch self {
        case "FLAT":
            return .hetro_systemGray3
        case "POOR":
            return .oceanBlue
        case "POOR_TO_FAIR":
                return .oceanBlue
        case "FAIR":
            return .green
        case "FAIR_TO_GOOD":
            return .green
        case "GOOD":
            return .systemYellow
        case "EPIC":
            return .systemRed
        default:
            return .oceanBlue
        }
    }
}
