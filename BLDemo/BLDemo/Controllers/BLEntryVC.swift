//
//  BLEntryVC.swift
//  BLDemo
//
//  Created by Daniel on 23/3/17.
//  Copyright © 2017 AppVania. All rights reserved.
//

import Foundation
import UIKit

class BLEntryVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    //TODO : CHANGE THIS TO CUSTOM COMPONENT
    @IBOutlet weak var playerWidgetView: UIView!
    @IBOutlet weak var playerWidgetViewBottomConstraint: NSLayoutConstraint!
    
    var entries : [BLEntry] = []
    var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // TODO : MANAGE THREADING IN THIS LOAD ENTRIES METHOD
        self.loadEntries()
        DispatchQueue.main.async {
            self.playerWidgetViewBottomConstraint.constant = -self.playerWidgetView.bounds.height
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func loadEntries() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator = UIActivityIndicatorView()
            self?.activityIndicator.center = (self?.view.center)!
            self?.view.addSubview((self?.activityIndicator)!)
            self?.activityIndicator.startAnimating()
        }
        let downloadEntries = BLNetworkManager.downloadEntries { unProcessedArray in
            guard let response = unProcessedArray else {
                print("Something is wrong")
                return
            }
            // TODO : MAKE SURE THIS PART OF CODE RUN IN MAIN THREAD
            self.entries = BLParser.parse(response)
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
            }
        }
        downloadEntries.resume()
    }
}


extension BLEntryVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entries.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath) as! BLEntryCell
        let entry = entries[indexPath.row]
        cell.setupFrom(entry: entry)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize.zero
        let width = collectionView.frame.size.width
        size = CGSize(width: width, height : 1.2 * width)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
}





class BLEntryCell : UICollectionViewCell {
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var entryTitleLbl: UILabel!
    @IBOutlet weak var entryImageView : UIImageView!
    @IBOutlet weak var entryUserLbl: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userInfoLbl: UILabel!
    
    func cleanup() {
        self.entryTitleLbl.text = ""
        self.entryImageView.image = nil
        self.entryUserLbl.text = ""
        self.userAvatar.image = nil
        self.userInfoLbl.text = ""
    }
    
    func setupFrom(entry : BLEntry) {
        cleanup()
        self.entryTitleLbl.text = entry.name
        self.entryUserLbl.text = entry.author.name
        // MEDIEVAL WAY TO LOAD IMAGE WITHOUT LIBRARY - 
        //TODO: IMAGE CACHING SYSTEM
        //TODO: ADD ACTIVITY INDICATOR
        self.userAvatar.imageFromUrl(urlString: entry.author.images.s!)
        self.entryImageView.imageFromUrl(urlString: (entry.images?.s)!)
        self.entryUserLbl.text = entry.author.name
        self.userInfoLbl.text = entry.author.name
    }
}
