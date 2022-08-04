//
//  NutritientsCollectionViewCell.swift
//  Cooky
//
//  Created by Aslan Murat on 25.07.2022.
//

import UIKit

enum Nutritient {
    case carbs(Int)
    case proteins(Int)
    case calories(Int)
    case fats(Int)
}

class NutritientsCollectionViewCell: UICollectionViewCell {
    static let identifier = "NutritientsCollectionViewCell"
    
    private let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGray5
        button.tintColor = UIColor.init(red: 15/255, green: 92/255, blue: 100/255, alpha: 1)
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(button)
        contentView.addSubview(label)
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 8, y: 8, width: contentView.frame.height - 8, height: contentView.frame.height - 8)
        label.frame = CGRect(x: button.frame.maxX + 8, y: 0, width: contentView.frame.width - label.frame.minY, height: contentView.frame.height)
    }
    
    func configure(with nutritient: Nutritient) {
        switch nutritient {
        case .carbs(let value):
            button.setImage(UIImage(systemName: "leaf"), for: .normal)
            label.text = "\(value)g carbs"
        case .proteins(let value):
            button.setImage(UIImage(named: "avocado")?.withTintColor(UIColor.init(red: 15/255, green: 92/255, blue: 100/255, alpha: 1)), for: .normal)
            label.text = "\(value)g proteins"
        case .calories(let value):
            button.setImage(UIImage(systemName: "flame"), for: .normal)
            label.text = "\(value) Kcal"
        case .fats(let value):
            button.setImage(UIImage(named: "pizza")?.withTintColor(UIColor.init(red: 15/255, green: 92/255, blue: 100/255, alpha: 1)), for: .normal)
            label.text = "\(value)g fats"
        }
    }
    
}
