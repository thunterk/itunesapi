//
//  ImageDownloader.swift
//  itunesapi
//
//  Created by Sunhaeng Heo on 2018. 5. 27..
//  Copyright © 2018년 Kyung-gak Nam. All rights reserved.
//

import UIKit

class ImageDownloader: NSObject {
    class func load(urlString: String, completionHandler handler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            handler(nil)
            return
        }
        if let cached = ImageCache.load(urlString) {
            handler(cached)
        } else {
            HTTP.imageRequest(url: url) { (image, error) in
                if image != nil && error == nil {
                    ImageCache.save(image!, forKey: urlString)
                }
                handler(image)
            }
        }
    }
    
    class func cancel(urlString: String) {
        
    }
}

class ImageCache: NSObject {
    private static let cache = NSCache<NSString, UIImage>()
    
    class func load(_ key: String) -> UIImage? {
//        cache.countLimit
//        cache.totalCostLimit
        let cached = cache.object(forKey: key as NSString)
        return cached
    }
    
    class func save(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
