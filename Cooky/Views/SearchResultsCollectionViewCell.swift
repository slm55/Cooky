//
//  RecipesCollectionViewCell.swift
//  Cooky
//
//  Created by Aslan Murat on 18.07.2022.
//

import UIKit

class SearchResultsCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchResultsCollectionViewCell"
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 16, weight: .bold)
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
        setUpBackground()
        
        contentView.addSubview(recipeNameLabel)
        contentView.addSubview(recipeDurationLabel)
        
        setConstraints()
        
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeNameLabel.text = nil
        recipeDurationLabel.text = nil
        backgroundImageView.image = nil
    }
    
    func setUpBackground(){
        contentView.addSubview(backgroundImageView)
        
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        tintView.frame = contentView.bounds
        contentView.addSubview(tintView)
        
        contentView.sendSubviewToBack(backgroundImageView)
        
        backgroundImageView.frame = contentView.bounds
    }
    
    func setConstraints(){
        let constraints = [
            recipeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            recipeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            recipeDurationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeDurationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            recipeDurationLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with recipe: SearchResultsCollectionViewCellViewModel){
        if let url = URL(string: recipe.imageURL) {
        backgroundImageView.load(url: url)
    }
        
        if let cookingDuration = recipe.cookingDuration {
            recipeDurationLabel.attributedText = getAttributedRecipeDurationString(with: cookingDuration)
            recipeDurationLabel.isHidden = false
            recipeDurationLabel.sizeToFit()
        }
        
        
        recipeNameLabel.frame = CGRect(x: 0, y: 0, width: contentView.frame.width - 32, height: 0)
        recipeNameLabel.text = recipe.foodName
        recipeNameLabel.sizeToFit()
    }
    
    func getAttributedRecipeDurationString(with time: Int) -> NSMutableAttributedString {
        let filteredTimeString = time < 120 ? "  \(time) mins" : "  \(time/60) hrs"
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "timer")?.withTintColor(.white)

        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: filteredTimeString))
        return fullString
    }
}


