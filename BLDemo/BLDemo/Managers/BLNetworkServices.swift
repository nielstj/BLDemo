//
//  BLNetworkService.swift
//  BLDemo
//
//  Created by Daniel on 23/3/17.
//  Copyright © 2017 AppVania. All rights reserved.
//

import Foundation
import UIKit


struct BLNetworkService {
    
    private static let session = URLSession.shared
    private static let baseURLString = "https://gist.githubusercontent.com/"
    private static let jsonURL = "anonymous/fec47e2418986b7bdb630a1772232f7d/raw/5e3e6f4dc0b94906dca8de415c585b01069af3f7/57eb7cc5e4b0bcac9f7581c8.json"
    
    static func downloadEntries(completion: @escaping (Array<[String: Any]>?, Error?)->()) -> URLSessionDataTask {
        let urlString = baseURLString + jsonURL
        var request = URLRequest(url: NSURL(string: urlString)! as URL)
        request.httpMethod = "GET"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let _: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return session.dataTask(with: request as URLRequest, completionHandler: {
            data, response, err -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            if let networkError = err {
                completion(nil, networkError)
                return
            }
            do {
                let rawJson = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                completion(rawJson["data"] as? Array<[String : Any]>, nil)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            } catch {
                completion(nil, error)
            }
        })
    }
}


struct BLParser {
    static func parse(_ input: Array<[String : Any]>) -> [BLEntry] {
        return input.map{ BLEntry.createFrom($0) }
    }
}
