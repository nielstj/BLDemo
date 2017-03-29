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
    
    let contentManager = BLContentManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // TODO : MANAGE THREADING IN THIS LOAD ENTRIES METHOD
        contentManager.delegate = self
        contentManager.fetchEntries()
        
        DispatchQueue.main.async {
            self.playerWidgetViewBottomConstraint.constant = -self.playerWidgetView.bounds.height
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contentManager.delegate = self
        self.entries = contentManager.entries
        self.collectionView.reloadData()
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}


extension BLEntryVC: BLContentManagerProtocol {
 
    func contentManagerDidStartFetchEntries() {
        
    }
    
    func contentManagerDidFailedFetchEntries(error: Error) {
        
    }
    
    func contentManagerDidFinishFetchEntries(results: [BLEntry]) {
        self.entries = results
        self.collectionView.reloadData()
        
        // TEST PLAYER
        DispatchQueue.main.async { [unowned self] in
            self.playerWidgetViewBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
            let url = URL(string: (self.entries.first?.audioLink)!)!
            let playerLayer = BLAudioPlayerManager.shared.playerLayerFromURL(url)
            playerLayer.frame = self.playerWidgetView.bounds
            self.playerWidgetView.layer.addSublayer(playerLayer)
            BLAudioPlayerManager.shared.player.play()
        }
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
        cell.indexPath = indexPath
        cell.playBtnCallback = { [unowned self](indexPath, state) in
            switch state {
            case .on: print("play track \(indexPath.row)")
            case .off: print("pause track \(indexPath.row)")
            }
        }
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


protocol Toggleable {
    mutating func toggle()
}

enum OnOffSwitch: Toggleable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off: self = .on
        case .on: self = .off
        }
    }
}


class BLEntryCell : UICollectionViewCell {
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var entryTitleLbl: UILabel!
    @IBOutlet weak var entryImageView : UIImageView!
    @IBOutlet weak var entryUserLbl: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userInfoLbl: UILabel!
    
    
    var playBtnCallback: ((IndexPath, OnOffSwitch) -> Void)?
    var playState: OnOffSwitch = .off
    var indexPath: IndexPath!
    
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
    
    @IBAction func playBtnTapped(_ sender: UIButton) {
        playState.toggle()
        let string = playState == .on ? "Pause" : "Play"
        self.playBtn.setTitle(string, for: .normal)
        playBtnCallback?(indexPath, self.playState)
    }
    
    
    
}
