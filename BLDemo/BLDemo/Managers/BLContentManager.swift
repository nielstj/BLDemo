//
//  BLContentManager.swift
//  BLDemo
//
//  Created by Daniel on 27/3/17.
//  Copyright © 2017 AppVania. All rights reserved.
//

import Foundation

protocol BLContentManagerProtocol {
    // CONTENT MANAGER DELEGATE
    func contentManagerDidStartFetchEntries()
    func contentManagerDidFinishFetchEntries(results : [BLEntry])
    func contentManagerDidFailedFetchEntries(error: Error)
    //.....
}

final class BLContentManager: NSObject {
    static let shared = BLContentManager()
    var delegate : BLContentManagerProtocol?
    
    private var _content : [BLEntry] = []
    public var entries : [BLEntry] { return self._content }
        
    public func fetchEntries() {
        delegate?.contentManagerDidStartFetchEntries()
        let task = BLNetworkService.downloadEntries { [unowned self](result, error) in
            if error != nil {
                self.delegate?.contentManagerDidFailedFetchEntries(error: error!)
            }
            else {
                self._content = BLParser.parse(result!)
                self.delegate?.contentManagerDidFinishFetchEntries(results: self._content)
            }
        }
        task.resume()
    }
}
