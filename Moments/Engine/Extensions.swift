//
//  Extensions.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/14.
//

import UIKit
import CryptoKit

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}

extension String {
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
