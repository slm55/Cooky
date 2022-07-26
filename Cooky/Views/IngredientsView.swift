//
//  UIIngredientsView.swift
//  Cooky
//
//  Created by Aslan Murat on 26.07.2022.
//

import UIKit

class IngredientsView: UIView {
    private let ingredients: [Component]
    
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
    
    private var ingredientsTableView: UITableView =  {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.backgroundColor = .systemPink
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(IngredientsTableViewCell.self, forCellReuseIdentifier: IngredientsTableViewCell.identifier)
        return tableView
    }()
    
    required init(ingredients: [Component]) {
        self.ingredients = ingredients
        numberOfItemsLabel.text = "\(ingredients.count) items"

        super.init(frame: .zero)
        
        addSubview(ingredientsTitleLabel)
        addSubview(numberOfItemsLabel)
        addSubview(ingredientsTableView)
        
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .cyan
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let constraints = [
            ingredientsTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            ingredientsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            numberOfItemsLabel.topAnchor.constraint(equalTo: ingredientsTitleLabel.bottomAnchor, constant: 8),
            numberOfItemsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ingredientsTableView.topAnchor.constraint(equalTo: numberOfItemsLabel.bottomAnchor, constant: 8),
            ingredientsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ingredientsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ingredientsTableView.heightAnchor.constraint(equalToConstant: ingredientsTableView.contentSize.height)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension IngredientsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: IngredientsTableViewCell.identifier, for: indexPath) as? IngredientsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: ingredients[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

