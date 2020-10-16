//
//  Networking.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/15.
//

import Foundation
import SwiftyJSON

enum HTTPMethod: String {
    case GET
}

protocol Request {
    var url: URL? { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    associatedtype Response
    func decode(data:Data)->Response?
}

class Networking {
    static let shared = Networking()
    private init(){}
    
    func send<T: Request>(_ req: T, completion: @escaping (T.Response?) -> Void) {
        guard let url = req.url else {return}
        var request = URLRequest(url: url)
        request.httpMethod = req.method.rawValue
        let task = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let data = data,let res = req.decode(data: data) {
                DispatchQueue.main.async { completion(res) }
            } else {
                DispatchQueue.main.async { completion(nil) }
            }
        }
        task.resume()
    }
    
}
