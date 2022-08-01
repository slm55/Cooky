//
//  RecipeDetailsViewController.swift
//  Cooky
//
//  Created by Aslan Murat on 28.07.2022.
//

import UIKit
import AVFoundation
import AVKit

class RecipeDetailsViewController: UIViewController {
    private let recipe: Recipe
    private var nutritients = [Nutritient]()
    private let initialFavoriteStatus: Bool
    private var isFavorite: Bool
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "play.circle.fill")?.withTintColor(.blue), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        textView.textContainer.maximumNumberOfLines = 1
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
    
    private let ingredientsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfItemsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Instructions"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let ingredientsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 16
        return sv
    }()
    
    private let instructionsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 16
        return sv
    }()
    
    init(recipe: Recipe){
        self.recipe = recipe
        self.initialFavoriteStatus = PersistenceManager.shared.isFavoriteRecipe(recipe: recipe)
        self.isFavorite = PersistenceManager.shared.isFavoriteRecipe(recipe: recipe)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        
        if let url = URL(string: recipe.thumbnailURL) {
            recipeImageView.load(url: url)
        }
        
        view.backgroundColor = .init(red: 251/255, green: 252/255, blue: 254/255, alpha: 1)
        
        title = "Recipe"
        navigationItem.titleView?.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        if isFavorite {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
        navigationItem.rightBarButtonItem?.tintColor = .black
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
        
        
        let mainContentView = UIView()
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        
        mainContentView.addSubview(recipeImageView)
        
        if let videoURL = recipe.videoURL {
            recipeImageView.addSubview(playButton)
            playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
            mainContentView.addSubview(playButton)
            playButton.centerXAnchor.constraint(equalTo: recipeImageView.centerXAnchor).isActive = true
            playButton.centerYAnchor.constraint(equalTo: recipeImageView.centerYAnchor).isActive = true
            playButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
            playButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
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
        
        mainContentView.addSubview(ingredientsTitleLabel)
        mainContentView.addSubview(numberOfItemsLabel)
        numberOfItemsLabel.text = "\(recipe.sections?[0].components!.count ?? 0) items"
        
        mainContentView.addSubview(instructionsTitleLabel)
        
        setUpIngredientsStackView()
        mainContentView.addSubview(ingredientsStackView)
        
        setUpInstructionsStackView()
        mainContentView.addSubview(instructionsStackView)
        
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
            ingredientsTitleLabel.topAnchor.constraint(equalTo: nutritionCollectionView.bottomAnchor, constant: 8),
            ingredientsTitleLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            numberOfItemsLabel.topAnchor.constraint(equalTo: ingredientsTitleLabel.bottomAnchor, constant: 8),
            numberOfItemsLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            ingredientsStackView.topAnchor.constraint(equalTo: numberOfItemsLabel.bottomAnchor, constant: 8),
            ingredientsStackView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            ingredientsStackView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            instructionsTitleLabel.topAnchor.constraint(equalTo: ingredientsStackView.bottomAnchor, constant: 8),
            instructionsTitleLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            instructionsStackView.topAnchor.constraint(equalTo: instructionsTitleLabel.bottomAnchor, constant: 8),
            instructionsStackView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            instructionsStackView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            instructionsStackView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        if isFavorite != initialFavoriteStatus {
            if isFavorite {
                PersistenceManager.shared.addFavoriteRecipe(recipe: recipe)
            } else {
                PersistenceManager.shared.deleteFavoriteRecipe(recipe: recipe)
            }
        }
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapFavoriteButton() {
        isFavorite.toggle()
        if isFavorite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
        }
    }
    
    @objc private func didTapPlay () {
        if let urlString = recipe.videoURL {
        if let url = URL(string: urlString) {
            let player = AVPlayer(url: url)
            let vc = AVPlayerViewController()
            vc.player = player
            present(vc, animated: true) {
                player.play()
            }
        }
        }
    }
    
    
    @objc func didTapShowMoreLessDescriptionButton() {
        if showMoreLessDescriptionButton.title(for: .normal) == "more" {
        recipeDescriptionTextView.textContainer.maximumNumberOfLines = 0
        recipeDescriptionTextView.invalidateIntrinsicContentSize()
            showMoreLessDescriptionButton.setTitle("less", for: .normal)
        } else {
            recipeDescriptionTextView.textContainer.maximumNumberOfLines = 1
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
    
    func setUpIngredientsStackView() {
        guard recipe.sections != nil else {
            return
        }
        for s in recipe.sections! {
            let innerStackView = UIStackView()
            innerStackView.spacing = 8
            innerStackView.axis = .vertical
            
            if let name = s.name {
                let titleLabel = UILabel()
                titleLabel.font = .systemFont(ofSize: 20)
                titleLabel.text = name
                innerStackView.addArrangedSubview(titleLabel)
            }
            
            for i in s.components! {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: 0))
                label.numberOfLines = 0
                label.font = .systemFont(ofSize: 16)
                label.lineBreakMode = .byWordWrapping
                label.text = i.rawText
                label.sizeToFit()
                innerStackView.addArrangedSubview(label)
            }
            ingredientsStackView.addArrangedSubview(innerStackView)
        }
    }
    
    func setUpInstructionsStackView() {
        guard recipe.instructions != nil else {
            return
        }
        for i in recipe.instructions! {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: 0))
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 16)
            label.lineBreakMode = .byWordWrapping
            label.text = i.displayText
            label.sizeToFit()
            instructionsStackView.addArrangedSubview(label)
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
