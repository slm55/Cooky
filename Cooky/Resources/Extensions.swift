//
//  Extensions.swift
//  Cooky
//
//  Created by Aslan Murat on 04.08.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIColor {
    static var accentGreen: UIColor {
        UIColor.init(red: 15/255, green: 92/255, blue: 100/255, alpha: 1)
    }
}

extension UILabel {
    func setAttributedRecipeDurationString(for time: Int, with color: UIColor) {
        let filteredTimeString = time < 120 ? "  \(time) mins" : "  \(time/60) hrs"
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "timer")?.withTintColor(color)
        
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: filteredTimeString))
        
        self.attributedText = fullString
    }
    
    func setAttributedRatingString(for rating: Double, with color: UIColor) {
        // rating score needs to be fomatted for 5-star system with 2 floating decimals
        let twoDecimalRating = String(format: "  %.1f", rating * 5.0)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "star")?.withTintColor(color)
        
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: twoDecimalRating))
        
        self.attributedText = fullString
    }
}
