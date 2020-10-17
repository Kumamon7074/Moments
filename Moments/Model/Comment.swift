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
    
    var attrContent:NSAttributedString {
        let commentStr = sender.nick + ": " + content
        let attrText = NSMutableAttributedString(string:commentStr)
        let range: NSRange = attrText.mutableString.range(of: sender.nick, options: .caseInsensitive)
        attrText.addAttribute(.foregroundColor, value: UIColor.flatBlack() as Any, range: NSRange(location: 0, length: commentStr.count))
        attrText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .regular) as Any, range: NSRange(location: 0, length: commentStr.count))
        attrText.addAttribute(.foregroundColor, value: UIColor.flatBlue() as Any, range: range)
        attrText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .bold), range: range)
        return attrText
    }
    
    init(json:JSON) {
        content = json["content"].stringValue
        sender = Profile(json: json["sender"])
    }
}
