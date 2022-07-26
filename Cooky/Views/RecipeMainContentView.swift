//
//  RecipeMainContentView.swift
//  Cooky
//
//  Created by Aslan Murat on 23.07.2022.
//

import UIKit

class RecipeMainContentView: UIView {
    private let recipe: Recipe
    private var nutritients = [Nutritient]()
    
    private let topLabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var recipeCreditsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    private lazy var recipePrepTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    private lazy var recipeRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    private let recipeDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isPagingEnabled = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.textContainer.maximumNumberOfLines = 2
        textView.font = .systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isHidden = true
        return textView
    }()
    
    private let showMoreLessDescriptionButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.sizeToFit()
        button.heightAnchor.constraint(equalToConstant: button.titleLabel!.frame.height).isActive = true
        return button
    }()
    
    private let nutritionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NutritientsCollectionViewCell.self, forCellWithReuseIdentifier: NutritientsCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false
        collectionView.isUserInteractionEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemGray5
        stackView.layer.cornerRadius = 8
        stackView.clipsToBounds = true
        return stackView
    }()
    
    private let ingredientsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ingredients", for: .normal)
        button.heightAnchor.constraint(equalToConstant: button.titleLabel!.frame.height + 16).isActive = true
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    private let instructionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Instructions", for: .normal)
        button.heightAnchor.constraint(equalToConstant: button.titleLabel!.frame.height + 16).isActive = true
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let selectedButtonlabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private let ingredientsView: IngredientsView
    private let instructionsView: InstructionsView
    
    required init(recipe: Recipe) {
        self.recipe = recipe
        self.ingredientsView = IngredientsView(ingredients: recipe.sections![0].components!)
        self.instructionsView = InstructionsView(instructions: recipe.instructions!)
        super.init(frame: .zero)
    
        addSubview(topLabelsStackView)
        topLabelsStackView.addArrangedSubview(recipeCreditsLabel)
        topLabelsStackView.addArrangedSubview(recipePrepTimeLabel)
        topLabelsStackView.addArrangedSubview(recipeRatingLabel)
        
        addSubview(recipeNameLabel)
        addSubview(recipeDescriptionTextView)
        addSubview(showMoreLessDescriptionButton)
        showMoreLessDescriptionButton.addTarget(self, action: #selector(didTapShowMoreLessDescriptionButton), for: .touchUpInside)
        
        setNutritients()
        
        addSubview(nutritionCollectionView)
        nutritionCollectionView.delegate = self
        nutritionCollectionView.dataSource = self
        
        addSubview(buttonsStackView)
        buttonsStackView.addSubview(selectedButtonlabel)
        buttonsStackView.addArrangedSubview(ingredientsButton)
        buttonsStackView.addArrangedSubview(instructionsButton)
        
        ingredientsButton.addTarget(self, action: #selector(didTapIngredientsButton), for: .touchUpInside)
        instructionsButton.addTarget(self, action: #selector(didTapInstructionsButton), for: .touchUpInside)
        
        addSubview(scrollView)
        scrollView.addSubview(ingredientsView)
        scrollView.addSubview(instructionsView)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        if let credits = recipe.credits.first {
            recipeCreditsLabel.text = credits.name
            recipeCreditsLabel.isHidden = false
        }
        
        if let prepTime = recipe.totalTimeMinutes {
            let filteredTimeString = prepTime < 90 ? "  \(prepTime) mins" : "  \(prepTime/60) hrs"
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "timer")?.withTintColor(.black)

            let fullString = NSMutableAttributedString(string: "")
            fullString.append(NSAttributedString(attachment: imageAttachment))
            fullString.append(NSAttributedString(string: filteredTimeString))
            
            recipePrepTimeLabel.attributedText = fullString
            recipePrepTimeLabel.isHidden = false
        }
        
        if let rating = recipe.userRatings?.score {
            
            let twoDecimalRating = String(format: "  %.1f", rating * 5.0)
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "star")?.withTintColor(.black)

            let fullString = NSMutableAttributedString(string: "")
            fullString.append(NSAttributedString(attachment: imageAttachment))
            fullString.append(NSAttributedString(string: twoDecimalRating))
            
            recipeRatingLabel.attributedText = fullString
            recipeRatingLabel.isHidden = false
        }
        
        recipeCreditsLabel.sizeToFit()
        recipePrepTimeLabel.sizeToFit()
        recipeRatingLabel.sizeToFit()
        
        recipeCreditsLabel.layoutIfNeeded()
        recipePrepTimeLabel.layoutIfNeeded()
        recipeRatingLabel.layoutIfNeeded()
        
        recipeNameLabel.text = recipe.name
        
        if let description = recipe.resultDescription, !description.isEmpty {
            recipeDescriptionTextView.text = description
            recipeDescriptionTextView.isHidden = false
            showMoreLessDescriptionButton.isHidden = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let constraints = [
            topLabelsStackView.topAnchor.constraint(equalTo: topAnchor),
            topLabelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLabelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeNameLabel.topAnchor.constraint(equalTo: topLabelsStackView.bottomAnchor, constant: 8),
            recipeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeNameLabel.widthAnchor.constraint(equalTo: widthAnchor),
            recipeDescriptionTextView.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 8),
            recipeDescriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeDescriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            showMoreLessDescriptionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            showMoreLessDescriptionButton.topAnchor.constraint(equalTo: recipeDescriptionTextView.bottomAnchor),
            nutritionCollectionView.topAnchor.constraint(equalTo: showMoreLessDescriptionButton.isHidden ? recipeNameLabel.bottomAnchor : showMoreLessDescriptionButton.bottomAnchor, constant: 8),
            nutritionCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nutritionCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nutritionCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(Int(ceil(Double(nutritients.count)/2.0))) * 64),
            buttonsStackView.topAnchor.constraint(equalTo: !nutritionCollectionView.isHidden ? nutritionCollectionView.bottomAnchor : (!showMoreLessDescriptionButton.isHidden ? showMoreLessDescriptionButton.bottomAnchor : recipeNameLabel.bottomAnchor), constant: 8),
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            scrollView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 300),
            ingredientsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            ingredientsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            ingredientsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ingredientsView.widthAnchor.constraint(equalTo: widthAnchor),
            instructionsView.leadingAnchor.constraint(equalTo: ingredientsView.trailingAnchor),
            instructionsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            instructionsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        selectedButtonlabel.frame = instructionsButton.bounds
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width*2, height: ingredientsView.frame.maxY)
    }
    
    @objc func didTapShowMoreLessDescriptionButton() {
        if showMoreLessDescriptionButton.title(for: .normal) == "more" {
        recipeDescriptionTextView.textContainer.maximumNumberOfLines = 0
        recipeDescriptionTextView.invalidateIntrinsicContentSize()
            showMoreLessDescriptionButton.setTitle("less", for: .normal)
        } else {
            recipeDescriptionTextView.textContainer.maximumNumberOfLines = 2
            recipeDescriptionTextView.invalidateIntrinsicContentSize()
            showMoreLessDescriptionButton.setTitle("more", for: .normal)
        }
    }
    
    private func setNutritients() {
        if let carbs = recipe.nutrition?.carbohydrates {
            nutritients.append(.carbs(carbs))
        }
        if let proteins = recipe.nutrition?.protein {
            nutritients.append(.proteins(proteins))
        }
        if let calories =  recipe.nutrition?.calories {
            nutritients.append(.calories(calories))
        }
        if let fats = recipe.nutrition?.fat {
            nutritients.append(.fats(fats))
        }
    }
    
    @objc func didTapIngredientsButton() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.selectedButtonlabel.frame = (self?.ingredientsButton.frame)!
            self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } completion: { [weak self] completed in
            if completed {
                self?.ingredientsButton.setTitleColor(.white, for: .normal)
                self?.instructionsButton.setTitleColor(.systemGray, for: .normal)
            }
        }
    }
    
    @objc func didTapInstructionsButton() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.selectedButtonlabel.frame = (self?.instructionsButton.frame)!
            self?.scrollView.setContentOffset(CGPoint(x: self?.frame.width ?? 0, y: 0), animated: true)
        } completion: { [weak self] completed in
            if completed {
                self?.instructionsButton.setTitleColor(.white, for: .normal)
                self?.ingredientsButton.setTitleColor(.systemGray, for: .normal)
            }
        }
    }
}

extension RecipeMainContentView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nutritients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = nutritionCollectionView.dequeueReusableCell(withReuseIdentifier: NutritientsCollectionViewCell.identifier, for: indexPath) as? NutritientsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: nutritients[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2, height: 60)
    }
}
