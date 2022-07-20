//
//  ViewController.swift
//  Cooky
//
//  Created by Aslan Murat on 15.07.2022.
//

import UIKit

class MainViewController: UIViewController {
    private let recipes = Array.init(repeating: "Some recipe", count: 10)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Find Best Recipe For Cooking"
        label.font = .systemFont(ofSize: 34, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let searchBar: UISearchTextField = {
        let searchBar = UISearchTextField()
        searchBar.placeholder = "Search dish or ingredient"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
        searchBar.textColor = .systemGray
        searchBar.background = nil
        return searchBar
    }()
    
    private let searchSettingButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .init(red: 232/255, green: 245/255, blue: 239/255, alpha: 1.0)
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .init(_colorLiteralRed: 57/255, green: 189/255, blue: 105/255, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let recipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(RecipesCollectionViewCell.self, forCellWithReuseIdentifier: RecipesCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(red: 251/255, green: 252/255, blue: 254/255, alpha: 1)
        view.addSubview(scrollView)
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(searchBar)
        scrollView.addSubview(searchSettingButton)
        scrollView.addSubview(categoriesCollectionView)
        scrollView.addSubview(recipesCollectionView)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        recipesCollectionView.delegate = self
        recipesCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let constraints = [
            headerLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            headerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            searchBar.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            searchBar.trailingAnchor.constraint(equalTo: searchSettingButton.leadingAnchor, constant: -8),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -84),
            searchSettingButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            searchSettingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchSettingButton.heightAnchor.constraint(equalToConstant: 44),
            searchSettingButton.widthAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(constraints)
        scrollView.frame = view.bounds
        categoriesCollectionView.frame = CGRect(x: 0, y: searchBar.frame.maxY + 16, width: view.frame.width, height: 48)
        categoriesCollectionView.contentOffset = CGPoint(x: -16, y: 0)
        recipesCollectionView.frame = CGRect(x: 16, y: categoriesCollectionView.frame.maxY + 16, width: view.frame.width - 32, height: (recipesCollectionView.frame.width * 0.75 + 10) * CGFloat(recipes.count))
        scrollView.contentSize = CGSize(width: view.frame.width, height: recipesCollectionView.frame.maxY + 8)
    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: "some cate")
        return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipesCollectionViewCell.identifier, for: indexPath) as? RecipesCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollectionView {
        let label = UIButton(frame: CGRect.zero)
        label.setTitle("some cate", for: .normal)
        label.sizeToFit()
        return CGSize(width: label.frame.width + 16, height: label.frame.height + 16)
        } else {
            return CGSize(width: recipesCollectionView.frame.width, height: recipesCollectionView.frame.width * 0.75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == categoriesCollectionView {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else {
            return
        }
        cell.didSelect()
        }
    }
}

