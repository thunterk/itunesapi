//
//  TableViewCell.swift
//  itunesapi
//
//  Created by sunhaeng Heo on 2018. 5. 29..
//  Copyright © 2018년 Kyung-gak Nam. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnail: CustomImageView?
    
    @IBOutlet weak var rankLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    
    @IBOutlet weak var rankMinWidth: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnail?.layer.borderWidth = 1 / UIScreen.main.scale
        self.thumbnail?.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setRank(_ number: Int) {
        func countDigit(number: Int) -> Int {
            if number < 10 {
                return 1
            } else {
                return 1 + countDigit(number: number/10)
            }
        }
        
        self.rankLabel?.text = "\(number)"
        
        rankMinWidth?.constant = CGFloat(countDigit(number: number)) * 12
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnail?.cancel()
    }

}
