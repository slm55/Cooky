//
//  CategoryCollectionViewCell.swift
//  Cooky
//
//  Created by Aslan Murat on 16.07.2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    var selectedCategory = false
    
    let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitleColor(.systemGray, for: .normal)
        button.backgroundColor = .systemGray5
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        button.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with category: String){
        button.setTitle(category, for: .normal)
        button.sizeToFit()
    }
    
    func didSelect() {
        selectedCategory.toggle()
        if selectedCategory {
            button.backgroundColor = .init(_colorLiteralRed: 57/255, green: 189/255, blue: 105/255, alpha: 1.0)
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .systemGray5
            button.setTitleColor(.systemGray, for: .normal)
        }
    }
}
