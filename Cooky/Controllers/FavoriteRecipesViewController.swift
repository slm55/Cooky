//
//  FavoriteRecipesViewController.swift
//  Cooky
//
//  Created by Aslan Murat on 31.07.2022.
//

import UIKit

class FavoriteRecipesViewController: UIViewController {
    private var favoriteRecipes = [Recipe]()
    
    private let tableView = UITableView()
    
    private let noRecipesLabel: UILabel = {
        let label = UILabel()
        label.text = "You do not have favorite recipes yet"
        label.textColor = .accentGreen
        label.isHidden = true
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Favorite recipes"
        
        setUpTableView()
        setUpNoRecipesLabel()
    }
    
    private func setUpNoRecipesLabel(){
        view.addSubview(noRecipesLabel)
        
        let constraints = [
            noRecipesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noRecipesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteRecipes = PersistenceManager.shared.favoriteRecipes
        tableView.reloadData()
        noRecipesLabel.isHidden = !favoriteRecipes.isEmpty
    }
    
    private func setUpTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteRecipesTableViewCell.self, forCellReuseIdentifier: FavoriteRecipesTableViewCell.identfier)
    }
}

extension FavoriteRecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = favoriteRecipes[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteRecipesTableViewCell.identfier, for: indexPath) as? FavoriteRecipesTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: FavoriteRecipesTableViewCellViewModel(foodName: recipe.name, imageURL: recipe.thumbnailURL))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipe = favoriteRecipes[indexPath.row]
        if recipe.recipes != nil {
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
