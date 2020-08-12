//
//  Codable.swift
//  Barrel
//
//  Created by Jae Lee on 7/24/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation


//MARK: - Encodable
extension Encodable {
    func toDictionary() throws -> [String:Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {throw NSError()}
        return dictionary
    }
}
