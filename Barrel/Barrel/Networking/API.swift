//
//  API.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation


class API {
    private static let decoder        = JSONDecoder()
    private static let baseUrl = "https://services.surfline.com/kbyg/"
    
    static func getSubRegionOverview(subRegionId:String, completion:@escaping(Overview?)->Void) {
        let path = "regions/overview?subregionId=\(subRegionId)&meterRemaining=undefined"
        let url = baseUrl + path
        NetworkingManager.sharedInstance.GET(urlString: url) { (result) in
            switch result {
            case .success(let result):
                let data = result.0
                let response = result.1
                print("Success with: \(String(describing: response.url))")
                do {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                        let overview = try decoder.decode(Overview.self, from: Data(jsonString.utf8))
                        completion(overview)
                    }
                    else {
                        completion(nil)
                    }
                }
                catch {
                    print("Error: \(error)")
                    completion(nil)
                }
                
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    
    static func getSpotElements<T:Codable>(oceanElement:OceanElement, spotId:String, parameter:T, completion:@escaping (Overview?)->Void) {
        
        var url = baseUrl + "spots/forecasts/\(oceanElement.rawValue)?"
        guard let bodyDict = try? parameter.toDictionary() else {
            completion(nil)
            return
        }
         
        let params = urlParamBuilder(dictionary: bodyDict)
        url = url+params
        print(url)
        
        
        NetworkingManager.sharedInstance.GET(urlString: url) { (result) in
            switch result {
            case .success(let result):
                let data = result.0
                let response = result.1
                print("Success with: \(String(describing: response.url))")
                do {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                        let overview = try decoder.decode(Overview.self, from: Data(jsonString.utf8))
                        completion(overview)
                    }
                    else {
                        completion(nil)
                    }
                }
                catch {
                    print("Error: \(error)")
                    completion(nil)
                }
                
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
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
