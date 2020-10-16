//
//  ImageCache.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/16.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let cache:NSCache<NSString, UIImage>
    private var diskQueue:DispatchQueue
    private var diskCacheURL:URL
    private let diskSizeLimit = 100 * 1024 * 1024;  // Disk cache size 100MB
    private var diskCacheSize:Int{
        get {
            return UserDefaults.standard.integer(forKey: "diskCacheSize")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "diskCacheSize")
            UserDefaults.standard.synchronize()
        }
    }
    
    private init(){
        cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 20 * 1024 * 1024;   // Memory cache size 10MB
        diskQueue = DispatchQueue(label: "ImageCache Queue")
        diskCacheURL = FileManager.default.temporaryDirectory.appendingPathComponent("ImageCache-moments")
        try? FileManager.default.createDirectory(at: diskCacheURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    func fetch(url:URL,completion:@escaping(UIImage?)->Void){
        // try memory cache
        if let image = cache.object(forKey: url.absoluteString.MD5 as NSString) {
            print("memory cache hit:\(url.absoluteString)")
            DispatchQueue.main.async {
                completion(image)
            }
            return
        } else {
            diskQueue.async {
                // try disk cache
                let fullURL = self.diskCacheURL.appendingPathComponent(url.absoluteString.MD5)
                if let image = UIImage(contentsOfFile: fullURL.path){
                    print("disk cache hit:\(url.absoluteString)")
                    // save it to memory
                    if let attr = try? FileManager.default.attributesOfItem(atPath: fullURL.path),let fileSize = attr[FileAttributeKey.size] as? Int  {
                        self.cache.setObject(image, forKey: url.absoluteString.MD5 as NSString, cost: fileSize)
                    } else {
                        print("save to memory failed.")
                    }
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    // try network
                    print("fetch form network")
                    Networking.shared.send(ImageRequest(url: url)) { [weak self](data) in
                        guard let `self` = self else {return}
                        if let data = data,let image = UIImage(data: data) {
                            self.cache(image: image, data: data, url: url)
                            DispatchQueue.main.async {
                                completion(image)
                            }
                        }else {
                            print("something wrong with image fetching.")
                            DispatchQueue.main.async {
                                completion(nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func cache(image:UIImage,data:Data,url:URL){
        diskQueue.async {
            self.cache.setObject(image, forKey: url.absoluteString.MD5 as NSString, cost: data.count)
            if self.diskCacheSize > self.diskSizeLimit {
                try? FileManager.default.removeItem(at: self.diskCacheURL)
                print("purge disk cache")
                self.diskCacheSize = 0
            }
            do {
                try data.write(to: self.diskCacheURL.appendingPathComponent(url.absoluteString.MD5))
                self.diskCacheSize += data.count
                print("save disk cache:\(data.count/1024/1024) MB")
            } catch{
                print("save disk cache failed.")
            }
        }
    }
}
