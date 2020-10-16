//
//  Profile.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/15.
//

import Foundation
import SwiftyJSON

struct Profile {
    let username:String
    let nick:String
    var avatarURL:URL?
    var profileImageURL:URL?
        
    init(json:JSON) {
        username = json["username"].stringValue
        nick = json["nick"].stringValue
        if let avatar = json["avatar"].string {
            avatarURL = URL(string: avatar)
        }
        if let profileImage = json["profile-image"].string {
            profileImageURL = URL(string: profileImage)
        }
    }
}
