//
//  BLAudioPlayerManager.swift
//  BLDemo
//
//  Created by Daniel on 27/3/17.
//  Copyright © 2017 AppVania. All rights reserved.
//

import Foundation


protocol BLAudioPlayerDelegate {
    // AUDIO PLAYERS DELEGATE
    func playerDidPlay(_ audioPlayer : BLAudioPlayer)
    func playerWillPlay(_ audioPlayer : BLAudioPlayer)
    func playerDidPause(_ audioPlayer: BLAudioPlayer)
    //......
}


protocol BLAudioPlayerDataSource {
    // AUDIO PLAYERS DATA SOURCE
    func numberOfTrackForPlayer(_ audioPLayer: BLAudioPlayer) -> Int
    func urlForPlayer(_ audioPlayer: BLAudioPlayer, forTrack: Int) -> URL
    // ...
}



final class BLAudioPlayer: NSObject {
    
}


final class BLAudioPlayerManager: NSObject {
    static let shared = BLAudioPlayerManager()
    var player = BLAudioPlayer()
}
