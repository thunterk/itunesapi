//
//  HTTP.swift
//  itunesapi
//
//  Created by Sunhaeng Heo on 2018. 5. 27..
//  Copyright © 2018년 Kyung-gak Nam. All rights reserved.
//

import UIKit

class HTTP: NSObject {
    
    fileprivate class func request(url: URL, completionHandler handler: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            handler(data, error)
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        task.resume()
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    class func imageRequest(url: URL, completionHandler handler: @escaping (UIImage?, Error?) -> Void) {
        request(url: url) { (data, error) in
            if let imageData = data, let image = UIImage(data: imageData) {
                handler(image, nil)
            } else {
                handler(nil, error)
            }
        }
    }
    
    class func listRequest(completionHandler handler: @escaping (ListData?, Error?) -> Void) {
        let genre = "6015"
        let limit = 50
        
        let url = URL(string: "https://itunes.apple.com/kr/rss/topfreeapplications/limit=\(limit)/genre=\(genre)/json")!
        
        request(url: url) { (data, error) in
            if let listData = data, let parsed = FeedData.parse(listData) {
                handler(parsed, error)
            } else {
                handler(nil, error)
            }
        }
    }
    
    class func detailRequest(appId: String, completionHandler handler: @escaping (AppData?, Error?) -> Void) {
        request(url: URL(string: "https://itunes.apple.com/lookup?id=\(appId)&country=kr")!) { (data, error) in
            if let detailData = data, let parsed = DetailData.parse(detailData) {
                handler(parsed, error)
            } else {
                handler(nil, error)
            }
        }
    }
}
