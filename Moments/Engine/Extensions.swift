//
//  Extensions.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/14.
//

import UIKit
import CryptoKit
import func AVFoundation.AVMakeRect

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

extension UIImage {
    func resized(for targetSize: CGSize) -> UIImage? {
          let widthRatio = targetSize.width / size.width
          let heightRatio = targetSize.height / size.height
          let scaleFactor = min(widthRatio, heightRatio)
          let scaledImageSize = CGSize(
              width: size.width * scaleFactor,
              height: size.height * scaleFactor
          )
          let renderer = UIGraphicsImageRenderer(
              size: scaledImageSize
          )
          let scaledImage = renderer.image { _ in
              self.draw(in: CGRect(
                  origin: .zero,
                  size: scaledImageSize
              ))
          }
          return scaledImage
    }
}

extension UIImageView {
    func set(url:URL){
        ImageCache.shared.fetch(url: url) { [weak self](image) in
            guard let `self` = self else {return}
            let size = self.bounds.size
            DispatchQueue.global(qos: .userInitiated).async {
                if let resizedImage = image?.resized(for: size){
                    DispatchQueue.main.sync {
                        UIView.transition(with: self,
                                          duration: 0.3,
                                        options: [.curveEaseOut, .transitionCrossDissolve],
                                        animations: {
                                            self.image = resizedImage
                                        })
                    }
                }
            }
        }
    }
}
