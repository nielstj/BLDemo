//
//  BLPlayerVC.swift
//  BLDemo
//
//  Created by Daniel on 23/3/17.
//  Copyright © 2017 AppVania. All rights reserved.
//

import Foundation
import UIKit

class BLPlayerVC: UIViewController {
    
    @IBOutlet weak var blurBG: UIImageView!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var entryImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
