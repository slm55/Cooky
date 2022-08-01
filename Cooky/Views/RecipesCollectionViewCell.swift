//
//  RecipesCollectionViewCell.swift
//  Cooky
//
//  Created by Aslan Murat on 18.07.2022.
//

import UIKit

struct RecipesCollectionViewCellViewModel {
    var credits: Credit?
    var rating: UserRatings?
    var foodName: String
    var cookingDuration: Int?
    var imageURL: String
}


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
        stackView.spacing = 16
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
        
        contentView.frame = bounds
        contentView.addSubview(backgroundImageView)
        
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        tintView.frame = contentView.bounds
        contentView.addSubview(tintView)
        
        contentView.sendSubviewToBack(backgroundImageView)
        
        contentView.addSubview(topLabelsStackView)
        contentView.addSubview(bottomLabelsStackView)
        
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        
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
        
        if let credits = recipe.credits {
            recipeCreditsLabel.text = credits.name
            recipeCreditsLabel.isHidden = false
        }
        
        if let ratingScore = recipe.rating?.score {
            let twoDecimalRating = String(format: "  %.1f", ratingScore * 5.0)
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "star")?.withTintColor(.white)

            let fullString = NSMutableAttributedString(string: "")
            fullString.append(NSAttributedString(attachment: imageAttachment))
            fullString.append(NSAttributedString(string: twoDecimalRating))
            
            recipeRatingLabel.attributedText = fullString
            recipeRatingLabel.isHidden = false
        }
        
        recipeCreditsLabel.sizeToFit()
        recipeRatingLabel.sizeToFit()
        
        topLabelsStackView.addArrangedSubview(recipeCreditsLabel)
        topLabelsStackView.addArrangedSubview(recipeRatingLabel)
        
        
        if let prepTime = recipe.cookingDuration {
            let filteredTimeString = prepTime < 90 ? "  \(prepTime) mins" : "  \(prepTime/60) hrs"
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "timer")?.withTintColor(.white)

            let fullString = NSMutableAttributedString(string: "")
            fullString.append(NSAttributedString(attachment: imageAttachment))
            fullString.append(NSAttributedString(string: filteredTimeString))
            
            recipeDurationLabel.attributedText = fullString
            recipeDurationLabel.isHidden = false
        }
        
        
        recipeNameLabel.frame = CGRect(x: 0, y: 0, width: contentView.frame.width - 32, height: 0)
        recipeNameLabel.text = recipe.foodName
        
        
        recipeDurationLabel.sizeToFit()
        recipeNameLabel.sizeToFit()
        
        bottomLabelsStackView.addArrangedSubview(recipeNameLabel)
        bottomLabelsStackView.addArrangedSubview(recipeDurationLabel)
        
        if let url = URL(string: recipe.imageURL) {
            backgroundImageView.load(url: url)
        }
    }
}

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
