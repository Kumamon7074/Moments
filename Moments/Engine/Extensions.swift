//
//  Extensions.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/14.
//

import UIKit

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
