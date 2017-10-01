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
        
        let githubEndpoint = Constants.pullURL
        
        print("here's the end point \(githubEndpoint)")
        
        let session = URLSession.shared
        let url = URL(string: githubEndpoint)!
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    do {
                        if NSString(data:data, encoding: String.Encoding.utf8.rawValue) != nil {
                            var pullResult = [Pull]()
                            
                            let object = try JSONSerialization.jsonObject(with: data, options: [])
                            let rootDict = object as? [[String: AnyObject]]
                            
                            // Parses loose items in API
                            for items in rootDict! {
                                let diffURL = items["diff_url"]
                                
                                let title = items["title"]
                                
                                // Parses the user object
                                let userOBJ = items["user"]
                                let userAvatar = userOBJ!["avatar_url"]
                                let userName = userOBJ!["login"]
                                
                                pullResult.append(Pull(avatarImage: userAvatar as! String, author: userName as! String, pullTitle: title as! String, diffUrl: diffURL as! String))
                            }
                            success(pullResult)
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
    
    class func diffRequest(diffURL: String) {
        
        let url = URL(string: diffURL)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            let diff = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let diffPull = DiffPull(diff: diff! as String)
            var result = [DiffPull]()
            result.append(diffPull)
            print("results are in \(result)")
        }
        task.resume()
    }
}
