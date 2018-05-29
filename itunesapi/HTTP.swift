//
//  HTTP.swift
//  itunesapi
//
//  Created by Sunhaeng Heo on 2018. 5. 27..
//  Copyright © 2018년 Kyung-gak Nam. All rights reserved.
//

import UIKit

class HTTP: NSObject {
    class func request(url: URL, completionHandler handler: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            handler(data, error)
        }
        task.resume()
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
    
    
}
