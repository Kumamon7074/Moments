//
//  TweetsRequest.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/15.
//

import Foundation
import SwiftyJSON

struct TweetsRequest:Request {

    var url : URL? {
        return  URL(string: "https://thoughtworks-mobile-2018.herokuapp.com/user/jsmith/tweets")
    }
    
    var method: HTTPMethod{
        return .GET
    }
    
    var parameters: [String : Any]?
    
    func decode(data: Data) -> [Tweet]? {
        guard let json = try? JSON(data: data) else {
            return nil
        }
        var tweets = [Tweet]()
        for tweetJson in json.arrayValue {
            tweets.append(Tweet(json: tweetJson))
        }
        return  tweets
    }
    
    typealias Response = [Tweet]

}
