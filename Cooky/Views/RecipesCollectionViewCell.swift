//
//  RecipesCollectionViewCell.swift
//  Cooky
//
//  Created by Aslan Murat on 18.07.2022.
//

import UIKit

class RecipesCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecipesCollectionViewCell"
    
    private let backgroundImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let recipeDurationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let addToFavoritesButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
        addSubview(addToFavoritesButton)
        addSubview(recipeNameLabel)
        addSubview(recipeDurationLabel)
        layer.borderWidth = 1
        layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        backgroundImageView.frame = contentView.bounds
        addToFavoritesButton.frame = CGRect(x: contentView.frame.width - 56, y: 16, width: 40, height: 32)
        let constraints = [
            recipeDurationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeDurationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            recipeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeNameLabel.bottomAnchor.constraint(equalTo: recipeDurationLabel.topAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with category: String){
    }
}
