//
//  ViewController.swift
//  Cooky
//
//  Created by Aslan Murat on 15.07.2022.
//

import UIKit

enum Category: Int, CaseIterable {
    case Popular = 0
    case Breakfast
    case Lunch
    case Dinner
    case Snacks
    case Appetizers
    case Desserts
    case Drinks
}

class MainViewController: UIViewController {
    private var sectionsDataSource = [RecipesCollectionViewSectionViewModel]()
    
    private let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Dish, ingredient or drink"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let recipesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                return MainViewController.createSectionLayout(section: sectionIndex)
            }
        )
        collectionView.register(RecipesCollectionViewCell.self, forCellWithReuseIdentifier: RecipesCollectionViewCell.identifier)
        collectionView.register(
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier
        )
        return collectionView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let errorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isHidden = true
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .accentGreen
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Find best recipes"
        setUpSearchController()
        setUpCollectionView()
        setUpSpinner()
        setUpErrorStackView()
        fetchData()
    }
    
    private func setUpSearchController(){
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    private func setUpCollectionView(){
        view.addSubview(recipesCollectionView)
        recipesCollectionView.frame = view.bounds
        recipesCollectionView.delegate = self
        recipesCollectionView.dataSource = self
        recipesCollectionView.isHidden = true
    }
    
    private func setUpErrorStackView(){
        let label = UILabel()
        label.text = "Error"
        label.textColor = .accentGreen
        label.sizeToFit()
        
        errorStackView.addArrangedSubview(label)
        errorStackView.addArrangedSubview(retryButton)
        view.addSubview(errorStackView)
        
        let constraints = [
            retryButton.widthAnchor.constraint(equalToConstant: 64),
            retryButton.heightAnchor.constraint(equalToConstant: 32),
            errorStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        retryButton.addTarget(self, action: #selector(didTapRetryButton), for: .touchUpInside)
    }
    
    private func setUpSpinner(){
        view.addSubview(spinner)
        spinner.center = view.center
        spinner.startAnimating()
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        
        for (i, c) in Category.allCases.enumerated() {
            // API limit: 5 requests/sec
            if i == 4 {
                sleep(2)
            }
            group.enter()
            APICaller.shared.getRecipesByCategory(category: c){
                [weak self] result in
                switch result {
                case .success(let recipes):
                    self?.sectionsDataSource.append(RecipesCollectionViewSectionViewModel(category: c, recipes: recipes.shuffled()))
                case .failure(let error):
                    print(error)
                }
                
                defer {
                    group.leave()
                }
            }
            
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.handleFetchedData()
        }
    }
    
    private func handleFetchedData(){
        sectionsDataSource.sort(by: {$0.category.rawValue < $1.category.rawValue})
        if sectionsDataSource.count < 4 {
            errorStackView.isHidden = false
        } else {
            recipesCollectionView.reloadData()
            recipesCollectionView.isHidden = false
        }
        spinner.stopAnimating()
    }
    
    @objc
    private func didTapRetryButton(){
        errorStackView.isHidden = true
        spinner.startAnimating()
        // spinner animates for 0.1 seconds before retrying to fetch data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: fetchData)
    }
    
}

// MARK: - CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let recipe = sectionsDataSource[indexPath.section].recipes[indexPath.row]
        if recipe.recipes != nil {
            let vc = RecipesCollectionViewController(recipe: recipe)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = RecipeDetailsViewController(recipe: recipe)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(UIWindow().frame.width * 0.9 * 0.75)
            ),
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = supplementaryViews
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionsDataSource[section].recipes.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipe = sectionsDataSource[indexPath.section].recipes[indexPath.row]
        let credits = recipe.credits[0]
        let ratings = recipe.userRatings
        let foodName = recipe.name
        let cookingDuration = recipe.totalTimeMinutes ?? recipe.prepTimeMinutes ?? recipe.cookTimeMinutes
        let imageURL = recipe.thumbnailURL
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipesCollectionViewCell.identifier, for: indexPath) as? RecipesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: RecipesCollectionViewCellViewModel(credits: credits, rating: ratings, foodName: foodName, cookingDuration: cookingDuration, imageURL: imageURL))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let category = sectionsDataSource[section].category
        let title = "\(category)"
        header.configure(with: title)
        return header
    }
}

// MARK: - Search
extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  return
              }
        resultsController.delegate = self
        
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    resultsController.update(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  return
              }
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    resultsController.update(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Delegate
extension MainViewController: SearchResultsViewControllerDelegate {
    func didTapResult(_ recipe: Recipe) {
        if recipe.recipes != nil {
            let vc = RecipesCollectionViewController(recipe: recipe)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = RecipeDetailsViewController(recipe: recipe)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
