//
//  ProfileRequest.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/15.
//

import Foundation
import SwiftyJSON

struct ProfileRequest:Request {

    var url : URL? {
        return  URL(string: "https://thoughtworks-mobile-2018.herokuapp.com/user/jsmith")
    }
    
    var method: HTTPMethod{
        return .GET
    }
    
    var parameters: [String : Any]?
    
    func decode(data: Data) -> Profile? {
        guard let json = try? JSON(data: data) else {
            return nil
        }
        return Profile(json: json)
    }
    
    typealias Response = Profile
}
