//
//  ViewController.swift
//  BLDemo
//
//  Created by Daniel on 22/3/17.
//  Copyright © 2017 AppVania. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TESTING DOWNLOAD DATA SHOULD MOVE TO UNIT TEST LATER
        
        let downloadEntries = BLNetworkManager.downloadEntries { unProcessedArray in
            guard let response = unProcessedArray else {
                print("Something is wrong")
                return
            }
            let entries = BLParser.parse(response)
            dump(entries)
        }
        downloadEntries.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    

}

