//
//  RecipeViewController.swift
//  Cooky
//
//  Created by Aslan Murat on 22.07.2022.
//

import UIKit

class RecipeViewController: UIViewController {
    private let recipe: Recipe
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let mainContentView: RecipeMainContentView
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    init(recipe: Recipe){
        self.recipe = recipe
        mainContentView = RecipeMainContentView(recipe: recipe)
        
        if let url = URL(string: recipe.thumbnailURL) {
            recipeImageView.load(url: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "Recipe"
        navigationItem.titleView?.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationController?.navigationBar.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(recipeImageView)
        scrollView.addSubview(mainContentView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        recipeImageView.frame = CGRect(x: 16, y: 16, width: view.frame.width - 32, height: (view.frame.width - 32) * 0.75)
        
        mainContentView.frame = CGRect(x: 16, y: recipeImageView.frame.maxY + 16, width: view.frame.width - 32, height: mainContentView.subviews.last?.frame.maxY ?? 1000)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: mainContentView.frame.maxY)
        
        print(mainContentView.frame.maxY)
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapFavoriteButton() {
    }
    
    
}
