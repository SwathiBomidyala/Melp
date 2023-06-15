//
//  NetworkManager.swift
//  MelpDemo
//
//  Created by Bomidyala Swathi on 15/06/23.
//

import Foundation

class NetworkManager {
    //We can maintain headers, access tokens here.
    static let instance = NetworkManager()
    private init() {}
    
    //As of now handled only Get requests, we can create separate functions for other requests
    func getAPIData<T: Decodable>(for: T.Type = T.self, url: String, requestType: RequestType, completionHandler: @escaping (T?, String?) -> Void) {
        
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let urlObj = URL(string: encodedUrl!) else {
            return completionHandler(nil, nil)
        }
        
        //Parsing the data
        let task = URLSession.shared.dataTask(with: urlObj, completionHandler: { (responseData, response, error) in
            do {
                var errorString: String?
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    do {
                        if let data = responseData {
                            let errorObj: GenericError = try JSONDecoder().decode(GenericError.self, from: data)
                            errorString = errorObj.message
                            print("error \(httpResponse.statusCode)")
                            completionHandler(nil, errorString)
                        }
                    } catch {}
                }
                if let data = responseData {
                    completionHandler(try JSONDecoder().decode(T.self, from: data), nil)
                }
            } catch {
                print(error)
            }
        })
        task.resume()
        
        return completionHandler(nil, nil)
    }
}
