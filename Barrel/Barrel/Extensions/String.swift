//
//  String.swift
//  Barrel
//
//  Created by Jae Lee on 7/24/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
//MARK: - String
extension String {
  
    
    func indexAt(_ theInt:Int)->String.Index {
        return self.index(self.startIndex, offsetBy: theInt)
    }
}
