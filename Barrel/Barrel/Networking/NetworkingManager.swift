//
//  NetworkingManager.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import Combine


class NetworkingManager {
    // Type alias
    typealias dataTaskSessionHandler = (Result<(Data,URLResponse),Error>) -> Void
    typealias networkingDataPublisher = AnyPublisher<Data, NetworkingError>
    
    // Instance
    static let sharedInstance = NetworkingManager()
    
    // NSUrlSession properties
    let defaultSession:URLSession
    var dataTask: URLSessionDataTask?
    
    private init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        sessionConfig.timeoutIntervalForResource = 10.0
        defaultSession = URLSession(configuration: sessionConfig)
    }
    
    public func GET(urlString: String, apiKey: String? = nil, idToken: String? = nil, completion: @escaping dataTaskSessionHandler) {
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let apiKey = apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        }
        if let idToken = idToken {
            request.setValue(idToken, forHTTPHeaderField: "x-id-token")
        }
        
        
        defaultSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data , let response = response else {
                let error = NSError(domain: "Error with: \(urlString)", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            completion(.success((data,response)))
            
            }.resume()
    }
    
    //MARK: - Using Combine
    /** Reactive */
    public func GET(urlString: String, apiKey: String? = nil, idToken: String? = nil)  -> networkingDataPublisher {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkingError.urlInvalid)
              .eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let apiKey = apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        }
        if let idToken = idToken {
            request.setValue(idToken, forHTTPHeaderField: "x-id-token")
        }
        
        return defaultSession.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                guard let httpURLResponse = response.response as? HTTPURLResponse else {
                    throw NetworkingError.invalidHttpResponse
                }
                
                guard httpURLResponse.statusCode == 200 else {
                    throw NetworkingError.statusCode(httpURLResponse.statusCode)
                }
                // 5
                return response.data
            }
            .mapError({NetworkingError.map($0)})
            .eraseToAnyPublisher()
        
    }
    
    public func POST(urlString: String, parameters:[String:Any], apiKey: String? = nil, idToken: String? = nil, completion: @escaping dataTaskSessionHandler) {
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let apiKey = apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        }
        if let idToken = idToken {
            request.setValue(idToken, forHTTPHeaderField: "x-id-token")
        }
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        catch {
            completion(.failure(error))
        }
        
        
        defaultSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data , let response = response else {
                let error = NSError(domain: "Error with: \(urlString)", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            completion(.success((data,response)))
            
            }.resume()
        
    }
    
    //MARK: - Using Combine
    /** Reactive */
    public func POST(urlString: String, parameters:[String:Any], apiKey: String? = nil, idToken: String? = nil) -> networkingDataPublisher {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkingError.urlInvalid).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let apiKey = apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        }
        if let idToken = idToken {
            request.setValue(idToken, forHTTPHeaderField: "x-id-token")
        }
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        catch {
            return Fail(error: NetworkingError.map(error)).eraseToAnyPublisher()
        }
        
        return defaultSession.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                guard let httpURLResponse = response.response as? HTTPURLResponse else {
                    throw NetworkingError.invalidHttpResponse
                }
                
                guard httpURLResponse.statusCode == 200 else {
                    throw NetworkingError.statusCode(httpURLResponse.statusCode)
                }
                // 5
                return response.data
            }
            .mapError({NetworkingError.map($0)})
            .eraseToAnyPublisher()
        
    }
    
    public func PATCH(urlString: String, parameters:[String:Any], apiKey: String? = nil, idToken: String? = nil, completion: @escaping dataTaskSessionHandler) {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PATCH"
        
        if let apiKey = apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        }
        if let idToken = idToken {
            request.setValue(idToken, forHTTPHeaderField: "x-id-token")
        }
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        catch {
            completion(.failure(error))
        }
        
        
        defaultSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data , let response = response else {
                let error = NSError(domain: "Error with: \(urlString)", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            completion(.success((data,response)))
            
            }.resume()
        
    }
    

    public func UPLOAD(urlString:String, image:UIImage, imageName:String, apiKey: String? = nil, idToken: String? = nil, completion: @escaping dataTaskSessionHandler) {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        if let apiKey = apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        }

        if let idToken = idToken {
            request.setValue(idToken, forHTTPHeaderField: "x-id-token")
        }
        request.httpBody = image.jpegData(compressionQuality: 1.0)


        let boundary = UUID().uuidString

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(imageName)\"; filename=\"\(imageName).jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 1.0)!)
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = data
        defaultSession.dataTask(with: request) { (data, response, error) in
           if let error = error {
                completion(.failure(error))
           }
           guard let data = data , let response = response else {
                let error = NSError(domain: "Error with: \(urlString)", code: 0, userInfo: nil)
                completion(.failure(error))
                return
           }
            completion(.success((data, response)))

           }.resume()


        }
    
}


