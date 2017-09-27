//
//  APIHandler.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/26/17.
//  Copyright © 2017 self. All rights reserved.
//

import Foundation

class APIHandler {
    
    class func callAPI(_ success: @escaping (_ pulls: [Pull]) -> (), error errorCallback: @escaping (_ errorMessage: String) -> ()) {
        
        let getEndpoint = RequestConstants.pullURL
        let session = URLSession.shared
        let url = URL(string: getEndpoint)!
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    do {
                        if NSString(data:data, encoding: String.Encoding.utf8.rawValue) != nil {
//                            var pullResult: [Pull] = []
                            
                            let object = try JSONSerialization.jsonObject(with: data, options: [])
                            let rootDict = object as? [[String: AnyObject]]
                            
                            var parsedDataObj = [String]()
                            
                            // Parses loose items in API
                            for items in rootDict! {
                                let diffURL = items["diff_url"]
                                parsedDataObj.append(diffURL as! String)
                                
                                let title = items["title"]
                                parsedDataObj.append(title as! String)
                                
                                // Parses the user object
                                let userOBJ = items["user"]
                            
                                let userAvatar = userOBJ!["avatar_url"]
                                parsedDataObj.append(userAvatar as! String)
                                
                                let userName = userOBJ!["login"]
                                parsedDataObj.append(userName as! String)
                            }
//                            success(pullResult)
                        } else {
                            errorCallback("No Valid Information")
                        }
                    } catch {
                        print("Data was not properly formatted")
                    }
                } else {
                    print("Not a 200 response")
                    errorCallback(error as! String)
                    return
                }
            }
        })
        task.resume()
    }
    
    
}
