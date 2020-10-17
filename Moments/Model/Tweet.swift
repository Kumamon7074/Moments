//
//  Tweet.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/15.
//

import Foundation
import SwiftyJSON

struct Tweet {
    var content:String?
    var images:[URL]?
    var comments:[Comment]?
    let sender:Profile
    
    init?(json:JSON) {
        guard json["content"].string != nil || json["images"].array != nil else {
            return nil
        }
        if let content = json["content"].string {
            self.content = content
        }
        if let imagesJosn = json["images"].array{
            images = [URL]()
            for imageJson in imagesJosn {
                if let url = URL(string: imageJson["url"].stringValue) {
                    images?.append(url)
                }
            }
        }
        sender = Profile(json: json["sender"])
        if let commontsJson = json["comments"].array {
            comments = [Comment]()
            for commentJson in commontsJson {
                comments?.append(Comment(json: commentJson))
            }
        }
    }
}
