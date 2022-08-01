//
//  FavoriteRecipesViewController.swift
//  Cooky
//
//  Created by Aslan Murat on 31.07.2022.
//

import UIKit

class FavoriteRecipesViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var favoriteRecipes = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(red: 251/255, green: 252/255, blue: 254/255, alpha: 1)
        title = "Favorite recipes"
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteRecipesTableViewCell.self, forCellReuseIdentifier: FavoriteRecipesTableViewCell.identfier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteRecipes = PersistenceManager.shared.favoriteRecipes
        tableView.reloadData()
    }
}

extension FavoriteRecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteRecipesTableViewCell.identfier, for: indexPath) as? FavoriteRecipesTableViewCell else {
            return UITableViewCell()
        }
        let recipe = favoriteRecipes[indexPath.row]
        cell.configure(with: PopularRecipesCollectionViewCellViewModel(foodName: recipe.name, imageURL: recipe.thumbnailURL))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipe = favoriteRecipes[indexPath.row]
            if let recipes = recipe.recipes {
                let vc = RecipesCollectionViewController(recipe: recipe)
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = RecipeDetailsViewController(recipe: recipe)
                navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
