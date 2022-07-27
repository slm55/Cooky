//
//  RecipeDetailsViewController.swift
//  Cooky
//
//  Created by Aslan Murat on 28.07.2022.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    private let recipe: Recipe
    private var nutritients = [Nutritient]()
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let topLabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()
    
    init(recipe: Recipe){
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        title = "Recipe"
        navigationItem.titleView?.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationController?.navigationBar.backgroundColor = .white
        
        let mainContentView = UIView()
        mainContentView.backgroundColor = .red
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        
        if let url = URL(string: recipe.thumbnailURL) {
            recipeImageView.load(url: url)
        }
        mainContentView.addSubview(recipeImageView)
        
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
        
        mainContentView.addSubview(topLabelsStackView)
        topLabelsStackView.addArrangedSubview(recipeCreditsLabel)
        topLabelsStackView.addArrangedSubview(recipePrepTimeLabel)
        topLabelsStackView.addArrangedSubview(recipeRatingLabel)
        
        recipeNameLabel.text = recipe.name
        mainContentView.addSubview(recipeNameLabel)
        
        if let description = recipe.resultDescription, !description.isEmpty {
            recipeDescriptionTextView.text = description
            recipeDescriptionTextView.isHidden = false
            showMoreLessDescriptionButton.isHidden = false
        }
        
        mainContentView.addSubview(recipeDescriptionTextView)
        mainContentView.addSubview(showMoreLessDescriptionButton)
        showMoreLessDescriptionButton.addTarget(self, action: #selector(didTapShowMoreLessDescriptionButton), for: .touchUpInside)
        
        
        setNutritients()
        
        mainContentView.addSubview(nutritionCollectionView)
        nutritionCollectionView.delegate = self
        nutritionCollectionView.dataSource = self
        
        mainContentView.addSubview(buttonsStackView)
        buttonsStackView.addSubview(selectedButtonlabel)
        buttonsStackView.addArrangedSubview(ingredientsButton)
        buttonsStackView.addArrangedSubview(instructionsButton)
        
        ingredientsButton.addTarget(self, action: #selector(didTapIngredientsButton), for: .touchUpInside)
        instructionsButton.addTarget(self, action: #selector(didTapInstructionsButton), for: .touchUpInside)
        
        
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        let someView = UIView()
        someView.translatesAutoresizingMaskIntoConstraints = false
        someView.backgroundColor = .systemYellow
        
        sv.addSubview(someView)
        
        NSLayoutConstraint.activate([
            someView.topAnchor.constraint(equalTo: sv.topAnchor),
            someView.leadingAnchor.constraint(equalTo: sv.leadingAnchor),
            someView.trailingAnchor.constraint(equalTo: sv.trailingAnchor),
            someView.widthAnchor.constraint(equalTo: sv.widthAnchor),
            someView.bottomAnchor.constraint(equalTo: sv.bottomAnchor),
            someView.heightAnchor.constraint(equalToConstant: 1500)
        ])
        
        let widthCon = NSLayoutConstraint(item: someView, attribute: .width, relatedBy: .equal, toItem: sv, attribute: .width, multiplier: 1.0, constant: 0)
        widthCon.isActive = true
        
        let heightCon = NSLayoutConstraint(item: someView, attribute: .height, relatedBy: .equal, toItem: sv, attribute: .height, multiplier: 1.0, constant: 0)
        heightCon.isActive = true
        heightCon.priority = .defaultLow
        
        mainContentView.addSubview(sv)
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(mainContentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            mainContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            mainContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            recipeImageView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 16),
            recipeImageView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: recipeImageView.widthAnchor, multiplier: 0.75),
            topLabelsStackView.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 16),
            topLabelsStackView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            topLabelsStackView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            recipeNameLabel.topAnchor.constraint(equalTo: topLabelsStackView.bottomAnchor, constant: 8),
            recipeNameLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            recipeNameLabel.widthAnchor.constraint(equalTo: mainContentView.widthAnchor),
            recipeDescriptionTextView.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 8),
            recipeDescriptionTextView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            recipeDescriptionTextView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            showMoreLessDescriptionButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            showMoreLessDescriptionButton.topAnchor.constraint(equalTo: recipeDescriptionTextView.bottomAnchor),
            nutritionCollectionView.topAnchor.constraint(equalTo: showMoreLessDescriptionButton.isHidden ? recipeNameLabel.bottomAnchor : showMoreLessDescriptionButton.bottomAnchor, constant: 8),
            nutritionCollectionView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            nutritionCollectionView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            nutritionCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(Int(ceil(Double(nutritients.count)/2.0))) * 64),
            buttonsStackView.topAnchor.constraint(equalTo: !nutritionCollectionView.isHidden ? nutritionCollectionView.bottomAnchor : (!showMoreLessDescriptionButton.isHidden ? showMoreLessDescriptionButton.bottomAnchor : recipeNameLabel.bottomAnchor), constant: 8),
            buttonsStackView.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: mainContentView.widthAnchor, multiplier: 0.8),
            selectedButtonlabel.topAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: 1),
            selectedButtonlabel.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor, constant: 1),
            selectedButtonlabel.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: -1),
            selectedButtonlabel.widthAnchor.constraint(equalTo: instructionsButton.widthAnchor, constant: -2),
            sv.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 16),
            sv.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -16)
        ])
        
        let widthConstraint = NSLayoutConstraint(item: mainContentView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: -32)
        widthConstraint.isActive = true
        
        let heightConstraint = NSLayoutConstraint(item: mainContentView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0)
        heightConstraint.isActive = true
        heightConstraint.priority = .defaultLow
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapFavoriteButton() {
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
            var frame = (self?.ingredientsButton.frame)!
            self?.selectedButtonlabel.frame = CGRect(x: frame.minX + 1, y: frame.minY + 1, width: frame.width - 2, height: frame.height - 2)
//            self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } completion: { [weak self] completed in
            if completed {
                self?.ingredientsButton.setTitleColor(.white, for: .normal)
                self?.instructionsButton.setTitleColor(.systemGray, for: .normal)
            }
        }
    }
    
    @objc func didTapInstructionsButton() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            var frame = (self?.instructionsButton.frame)!
            self?.selectedButtonlabel.frame = CGRect(x: frame.minX + 1, y: frame.minY + 1, width: frame.width - 2, height: frame.height - 2)
//            self?.scrollView.setContentOffset(CGPoint(x: self?.frame.width ?? 0, y: 0), animated: true)
        } completion: { [weak self] completed in
            if completed {
                self?.instructionsButton.setTitleColor(.white, for: .normal)
                self?.ingredientsButton.setTitleColor(.systemGray, for: .normal)
            }
        }
    }
}

extension RecipeDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        return CGSize(width: (view.frame.width - 32)/2, height: 60)
    }
}
