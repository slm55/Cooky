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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let topLabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let bottomLabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        return stackView
    }()
    
    private let recipeCreditsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let recipeRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let recipeDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        setUpBackground()
        
        contentView.addSubview(topLabelsStackView)
        contentView.addSubview(bottomLabelsStackView)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setUpBackground() {
        contentView.addSubview(backgroundImageView)
        
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        tintView.frame = contentView.bounds
        contentView.addSubview(tintView)
        
        contentView.sendSubviewToBack(backgroundImageView)
    }
    
    func setUpConstraints() {
        
        backgroundImageView.frame = contentView.bounds
        
        let constraints = [
            topLabelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            topLabelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topLabelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bottomLabelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            bottomLabelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bottomLabelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeCreditsLabel.text = nil
        recipeRatingLabel.text = nil
        recipeNameLabel.text = nil
        recipeDurationLabel.text = nil
        backgroundImageView.image = nil
    }
    
    func configure(with recipe: RecipesCollectionViewCellViewModel){
        if let url = URL(string: recipe.imageURL) {
            backgroundImageView.load(url: url)
        }
        
        if let credits = recipe.credits {
            recipeCreditsLabel.text = credits.name
            recipeCreditsLabel.isHidden = false
        }
        
        if let ratingScore = recipe.rating?.score, ratingScore > 0 {
            recipeRatingLabel.setAttributedRatingString(for: ratingScore, with: .white)
            recipeRatingLabel.isHidden = false
        }
        
        topLabelsStackView.addArrangedSubview(recipeCreditsLabel)
        topLabelsStackView.addArrangedSubview(recipeRatingLabel)
        
        
        if let cookingDuration = recipe.cookingDuration {
            recipeDurationLabel.setAttributedRecipeDurationString(for: cookingDuration, with: .white)
            recipeDurationLabel.isHidden = false
        }
        
        recipeNameLabel.text = recipe.foodName
        
        bottomLabelsStackView.addArrangedSubview(recipeNameLabel)
        bottomLabelsStackView.addArrangedSubview(recipeDurationLabel)
    }
}
