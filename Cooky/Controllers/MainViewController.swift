//
//  ViewController.swift
//  Cooky
//
//  Created by Aslan Murat on 15.07.2022.
//

import UIKit

class MainViewController: UIViewController {
    private let recipeCategories = ["Popular", "Breakfast", "Lunch", "Dinner", "Snacks", "Appetizers", "Desserts", "Drinks"]
    private var sectionsDataSource = [[Recipe]].init(repeating: [], count: 8)
    
    let searchController: UISearchController = {
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
        collectionView.register(PopularRecipesCollectionViewCell.self, forCellWithReuseIdentifier: PopularRecipesCollectionViewCell.identifier)
        collectionView.register(
                   TitleHeaderCollectionReusableView.self,
                   forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                   withReuseIdentifier: TitleHeaderCollectionReusableView.identifier
               )
        return collectionView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .black
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(red: 251/255, green: 252/255, blue: 254/255, alpha: 1)
        
        title = "Find best recipes"
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        view.addSubview(recipesCollectionView)
        recipesCollectionView.frame = view.bounds
        recipesCollectionView.delegate = self
        recipesCollectionView.dataSource = self
        recipesCollectionView.isHidden = true
        
        view.addSubview(spinner)
        spinner.center = view.center
        spinner.startAnimating()
        
        fetchData()
        
    }
    
    func fetchData() {
        let group = DispatchGroup()
        
        for i in 0...7 {
            if i == 4 {
                sleep(2)
            }
            group.enter()
            APICaller.shared.getRecipesByCategory(category: recipeCategories[i]){
                [weak self] result in
                switch result {
                case .success(let recipes):
                    self?.sectionsDataSource[i] = recipes.shuffled()
                case .failure(let error):
                    print(error)
                }
                
                defer {
                    group.leave()
                }
            }
            
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.recipesCollectionView.reloadData()
            self?.spinner.stopAnimating()
            self?.recipesCollectionView.isHidden = false
        }
    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let recipe = sectionsDataSource[indexPath.section][indexPath.row]
            if let recipes = recipe.recipes {
                let vc = RecipesCollectionViewController(recipe: recipe)
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = RecipeDetailsViewController(recipe: recipe)
                navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        if section == 0 {
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
                // Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )

                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

                // Vertical group in horizontal group
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(UIWindow().frame.width * 0.9 * 0.5 * 2)
                    ),
                    subitem: item,
                    count: 2
                )

                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.9),
                        heightDimension: .absolute(UIWindow().frame.width * 0.9 * 0.5 * 2)
                    ),
                    subitem: verticalGroup,
                    count: 1
                )

                // Section
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = supplementaryViews
                return section
        } else {
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
                // Item
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

                // Section
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = supplementaryViews
                return section
        }
            }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionsDataSource[section].count
       }

       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return recipeCategories.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if indexPath.section == 0 {
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularRecipesCollectionViewCell.identifier, for: indexPath) as? PopularRecipesCollectionViewCell else {
                   return UICollectionViewCell()
               }
               let recipe = sectionsDataSource[indexPath.section][indexPath.row]
               let foodName = recipe.name
               let cookingDuration = recipe.totalTimeMinutes ?? recipe.prepTimeMinutes ?? recipe.cookTimeMinutes
               let imageURL = recipe.thumbnailURL
               cell.configure(with: PopularRecipesCollectionViewCellViewModel(foodName: foodName, cookingDuration: cookingDuration, imageURL: imageURL))
               return cell
           } else {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipesCollectionViewCell.identifier, for: indexPath) as? RecipesCollectionViewCell else {
               return UICollectionViewCell()
           }
               let recipe = sectionsDataSource[indexPath.section][indexPath.row]
           let credits = recipe.credits[0]
           let ratings = recipe.userRatings
           let foodName = recipe.name
           let cookingDuration = recipe.totalTimeMinutes ?? recipe.prepTimeMinutes ?? recipe.cookTimeMinutes
           let imageURL = recipe.thumbnailURL
           cell.configure(with: RecipesCollectionViewCellViewModel(credits: credits, rating: ratings, foodName: foodName, cookingDuration: cookingDuration, imageURL: imageURL))
           return cell
           }
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
        let title = recipeCategories[section]
        header.configure(with: title)
        return header
    }
}

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

extension MainViewController: SearchResultsViewControllerDelegate {
    func didTapResult(_ recipe: Recipe) {
        if let recipes = recipe.recipes {
            let vc = RecipesCollectionViewController(recipe: recipe)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = RecipeDetailsViewController(recipe: recipe)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
