//
//  SearchResultsViewController.swift
//  Cooky
//
//  Created by Aslan Murat on 30.07.2022.
//

import UIKit


protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ recipe: Recipe)
}

class SearchResultsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var searchResults: [Recipe] = []
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 7,
                bottom: 2,
                trailing: 7
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(150)),
                subitem: item,
                count: 2
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 0,
                bottom: 10,
                trailing: 0
            )
            
            return NSCollectionLayoutSection(group: group)
        })
    )
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No results found"
        label.textColor = .accentGreen
        label.isHidden = true
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpCollectionView()
        setUpNoResultsLabel()
    }
    
    private func setUpCollectionView(){
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.frame = view.bounds
    }
    
    private func setUpNoResultsLabel(){
        view.addSubview(noResultsLabel)
        
        let constraints = [
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func update(with results: [Recipe]) {
        searchResults = results
        collectionView.reloadData()
        collectionView.isHidden = results.isEmpty
        noResultsLabel.isHidden = !results.isEmpty
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let recipe = searchResults[indexPath.row]
        delegate?.didTapResult(recipe)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath) as? SearchResultsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let recipe = searchResults[indexPath.row]
        let foodName = recipe.name
        let cookingDuration = recipe.totalTimeMinutes ?? recipe.prepTimeMinutes ?? recipe.cookTimeMinutes
        let imageURL = recipe.thumbnailURL
        cell.configure(with: SearchResultsCollectionViewCellViewModel(foodName: foodName, cookingDuration: cookingDuration, imageURL: imageURL))
        return cell
    }
    
}
