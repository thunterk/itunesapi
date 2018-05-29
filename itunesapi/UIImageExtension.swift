//
//  UIImageExtension.swift
//  itunesapi
//
//  Created by Sunhaeng Heo on 2018. 5. 27..
//  Copyright © 2018년 Kyung-gak Nam. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(urlString: String) {
        ImageDownloader.load(urlString: urlString) { [weak self] (image) in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
    
    func cancel() {
        
    }
}

