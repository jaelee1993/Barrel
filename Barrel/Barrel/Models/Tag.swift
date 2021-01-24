//
//  SC_Tag.swift
//  Aphrodite
//
//  Created by Jae Lee on 8/26/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit


class Tag:Codable {
    var description:String?
    var displayName:String?
    var score:String?
    var color:String?
    var tagCategory:String?
    var tagName:String?
    
    init(){}
    
    init(tagName:String, displayName:String, description:String) {
        self.tagName = tagName
        self.displayName = displayName
        self.description = description
    }
    
    func attributedTitle() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.firstLineHeadIndent = 10
        paragraphStyle.headIndent = 0
        paragraphStyle.tailIndent = 0
        
        let attributes = [
            NSAttributedString.Key.paragraphStyle  : paragraphStyle,
            NSAttributedString.Key.font            : UIFont.systemFont(ofSize: 12, weight: .light),
            ]
    
        return NSAttributedString(string: self.displayName == nil ? "" : self.displayName!, attributes: attributes)
    }
    
    
    var colorForColorLiteral:UIColor {
        get {
            return self.color == nil ? .black : UIColor.getColorByLiteralName(self.color!)
        }
    }
}


extension Sequence where Iterator.Element == Tag {
    
    
}
