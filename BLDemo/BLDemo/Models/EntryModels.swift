//
//  EntryModels.swift
//  BLDemo
//
//  Created by Daniel on 23/3/17.
//  Copyright © 2017 AppVania. All rights reserved.
//

import Foundation

struct BLEntry {
    var name: String!
    var id: String!
    var author: BLAuthor!
    var createdOn : String!
    var modifiedOn : String!
    var images: BLImages?
    var audioLink: String!
    
    static func createFrom(_ json : [String: Any]) -> BLEntry {
        let name = json["name"] as! String
        let id = json["id"] as! String
        let authorJSON = json["author"] as! [String : Any]
        let author = BLAuthor.createFrom(authorJSON)
        let createdOn = json["createdOn"] as! String
        let modifiedOn = json["modifiedOn"] as! String
        let imagesJSON = json["picture"] as! [String : Any]
        let images = BLImages.createFrom(imagesJSON)
        let audioLink = json["audioLink"] as! String
        return BLEntry(name : name, id: id, author: author, createdOn: createdOn, modifiedOn: modifiedOn, images: images, audioLink: audioLink)
    }
}

struct BLAuthor {
    var name: String!
    var images: BLImages!
    static func createFrom(_ json: [String : Any]) -> BLAuthor {
        let name = json["name"] as! String
        let imagesJSON = json["picture"] as! [String : Any]
        let images = BLImages.createFrom(imagesJSON)
        return BLAuthor(name: name, images: images)
    }
    
}

struct BLImages {
    var s: String?
    var m: String?
    var l: String?
    var xs: String?
    var url: String!
    
    static func createFrom(_ json: [String : Any]) -> BLImages {
        let s = json["s"] as? String
        let m = json["m"] as? String
        let l = json["l"] as? String
        let xs = json["xs"] as? String
        let url = json["url"] as! String
        return BLImages(s: s, m: m, l: l, xs: xs, url: url)
    }
    
}
