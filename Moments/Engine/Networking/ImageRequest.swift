//
//  ImageRequest.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/15.
//

import UIKit

struct ImageRequest:Request {
    
    var url: URL?

    var method: HTTPMethod {
        .GET
    }
    
    var parameters: [String : Any]?
    
    func decode(data: Data) -> Data? {
        return data
    }
    
    typealias Response = Data
    
}
