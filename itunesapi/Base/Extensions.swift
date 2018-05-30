//
//  Extensions.swift
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

extension Int {
    func roughFormat() -> String {
        if self >= 10000 {
            return "\(Double(self / 100) / 100)만"
        } else if self >= 1000 {
            return "\(Double(self / 10) / 100)천"
        } else {
            return "\(self)"
        }
    }
    
    func byteFormat() -> String {
        if self >= 1000 * 1000 * 1000 {
            return "\(round(Double(self) / (1000 * 1000 * 100)) / 10) GB"
        } else if self >= 1000 * 1000 {
            return "\(round(Double(self) / (1000 * 100)) / 10) MB"
        } else if self >= 1000 {
            return "\(round(Double(self) / 100) / 10) KB"
        } else {
            return "\(self) \(self == 1 ? "Byte" : "Bytes")"
        }
    }
}

extension String {
    func removeWhiteLine() -> String {
        let comp = self.components(separatedBy: CharacterSet.newlines)
        return comp.filter({ !$0.isEmpty }).joined(separator: "\n")
    }
    
    func attributedString(font: UIFont, lineSpacing: CGFloat, alignment: NSTextAlignment = .left) -> NSAttributedString! {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        paragraphStyle.paragraphSpacing = 0
        return NSAttributedString(string: self, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paragraphStyle])
    }
    
    var dateValue: Date? {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self)
    }
    
}

extension Date {
    func sinceNowString() -> String {
        
        let interval = Int(self.timeIntervalSinceNow) * (-1)
        
        if interval >= (60 * 60 * 24 * 365) {
            return "\(interval / (60 * 60 * 24 * 365))년 전"
        } else if interval >= (60 * 60 * 24 * 30) {
            return "\(interval / (60 * 60 * 24 * 30))달 전"
        } else if interval >= (60 * 60 * 24) {
            return "\(interval / (60 * 60 * 24))일 전"
        } else if interval >= (60 * 60) {
            return "\(interval / (60 * 60))시간 전"
        } else if interval >= 60 {
            return "\(interval / 60)분 전"
        } else {
            return "\(interval)초 전"
        }
    }
}
