//
//  RecipesCollectionViewController.swift
//  Cooky
//
//  Created by Aslan Murat on 29.07.2022.
//

import UIKit

class RecipesCollectionViewController: UIPageViewController {
    private let recipe: Recipe
    private var pages = [RecipeDetailsViewController]()
    private let pageControl = UIPageControl()
    private var initialPage = 0
    private var initialFavoriteStatus: Bool = false
    private var isFavorite: Bool = false
    
    init(recipe: Recipe){
        self.recipe = recipe
        self.initialFavoriteStatus = PersistenceManager.shared.isFavoriteRecipe(recipe: recipe)
        self.isFavorite = PersistenceManager.shared.isFavoriteRecipe(recipe: recipe)
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setUpNavigationController()
        
        title = "Recipes Collection"
        
        setUpNavigationItems()
        
        setUpController()
        setUpPageControl()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
    
    private func setUpNavigationController(){
        navigationController?.navigationBar.backgroundColor = .systemBackground
        let statusBarFrame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame
        let statusBarView = UIView(frame: statusBarFrame ?? CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(statusBarView)
        statusBarView.backgroundColor = .systemBackground
    }
    
    private func setUpNavigationItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .accentGreen
        
        if isFavorite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
        }
        navigationItem.rightBarButtonItem?.tintColor = .accentGreen
    }
    
    private func setUpController() {
        dataSource = self
        delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        
        for recipe in recipe.recipes! {
            pages.append(RecipeDetailsViewController(recipe: recipe))
        }
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    private func setUpPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .accentGreen
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        view.addSubview(pageControl)
    }
    
    private func setConstraints() {
        let constraints = [
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 1),
        ]
        NSLayoutConstraint.activate(constraints)
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
        navigationItem.rightBarButtonItem?.tintColor = .accentGreen
    }
    
}


// MARK: - Actions
extension RecipesCollectionViewController {
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: false, completion: nil)
    }
}

// MARK: - DataSources
extension RecipesCollectionViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController as! RecipeDetailsViewController) else { return nil }
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController as! RecipeDetailsViewController) else { return nil }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
}

// MARK: - Delegates
extension RecipesCollectionViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0] as! RecipeDetailsViewController) else { return }
        
        pageControl.currentPage = currentIndex
    }
}

