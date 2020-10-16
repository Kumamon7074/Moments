//
//  Comment.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/15.
//

import Foundation
import SwiftyJSON

struct Comment {
    let content:String
    let sender:Profile
    
    init(json:JSON) {
        content = json["content"].stringValue
        sender = Profile(json: json["sender"])
    }
}
