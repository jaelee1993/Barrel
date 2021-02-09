//
//  NetworkingError.swift
//  Barrel
//
//  Created by Jae Lee on 2/9/21.
//  Copyright © 2021 Jae Lee. All rights reserved.
//

import Foundation

enum NetworkingError:Error {
    case urlInvalid
    case invalidHttpResponse
    case statusCode(Int)
    case other(Error)
    
    
    static func map(_ error: Error) -> NetworkingError {
      return (error as? NetworkingError) ?? .other(error)
    }
}
