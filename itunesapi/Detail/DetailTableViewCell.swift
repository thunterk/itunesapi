//
//  DetailTableViewCell.swift
//  itunesapi
//
//  Created by sunhaeng Heo on 2018. 5. 30..
//  Copyright © 2018년 Kyung-gak Nam. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet var labels: [UILabel]?
    @IBOutlet weak var expandButton: UIButton?
    
    @IBAction func expand(_ sender: UIButton) {
        expandAction?(sender)
    }
    
    var expandAction: ((UIButton) -> Void)?
}

class DetailTableViewInfoCell: DetailTableViewCell {
    @IBOutlet weak var webButton: UIButton?
    
    @IBAction func click(_ sender: UIButton) {
        guard let urlString = webLink, let url = URL(string: urlString) else {
            return
        }
        clickAction?(url)
        
    }
    
    var clickAction: ((URL) -> Void)?
    
    var webLink: String? {
        didSet {
            webButton?.isHidden = webLink == nil
        }
    }
}

class ScreenshotCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: CustomImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView?.layer.borderWidth = 1 / UIScreen.main.scale
        self.imageView?.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.cancel()
    }
}
