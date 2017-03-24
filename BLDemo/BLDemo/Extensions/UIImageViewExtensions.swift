//
//  UIImageViewExtensions.swift
//  BLDemo
//
//  Created by Daniel on 24/3/17.
//  Copyright © 2017 AppVania. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(url: url as URL)
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
                data, response, err -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData as Data)
                }
            })
            task.resume()
        }
    }
}
