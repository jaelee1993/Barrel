//
//  API.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import Combine

class API {
    private static let decoder        = JSONDecoder()
    private static let baseUrl = "https://services.surfline.com/kbyg/"
    
    
    static func getSubRegionOverview(subRegionId:String) -> AnyPublisher<Overview, NetworkingError> {
        let path = "regions/overview?subregionId=\(subRegionId)&meterRemaining=undefined"
        let url = baseUrl + path
        
        return NetworkingManager.sharedInstance.GET(urlString: url).tryMap { data in
            return data
        }.decode(type: Overview.self, decoder: JSONDecoder())
        .mapError({NetworkingError.map($0)})
        .eraseToAnyPublisher()
    }
    
    static func getSpotElements<T:Codable>(oceanElement:OceanElement, spotId:String, parameter:T) -> AnyPublisher<Overview, NetworkingError> {
        var url = baseUrl + "spots/forecasts/\(oceanElement.rawValue)?"
        do {
            let bodyDict = try parameter.toDictionary()
            let params = urlParamBuilder(dictionary: bodyDict)
            url = url+params
            
            return NetworkingManager.sharedInstance.GET(urlString: url).tryMap { data in
                return data
            }.decode(type: Overview.self, decoder: JSONDecoder())
            .mapError({NetworkingError.map($0)})
            .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkingError.other(error))
                .eraseToAnyPublisher()
        }
    }
    
    
    
    
    
    
   
    
}









extension API {
    static public func urlParamBuilder(dictionary:[String:Any]) -> String {
        var param:String = ""
        for (key,value) in dictionary
        {
            param = "\(param)&\(key)=\(value)"
        }
        
        if param != ""
        {
            param.remove(at: param.indexAt(0))
            return param
        }
        return param
    }
}
