//
//  SearchResultTableViewCell.swift
//  Cooky
//
//  Created by Aslan Murat on 30.07.2022.
//

import UIKit

class FavoriteRecipesTableViewCell: UITableViewCell {
    static let identfier = "FavoriteRecipesTableViewCell"

    private let label: UILabel = {
            let label = UILabel()
            label.numberOfLines = 3
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private let iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.layer.cornerRadius = 8
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(label)
            contentView.addSubview(iconImageView)
            
            setConstraints()
        }

        required init?(coder: NSCoder) {
            fatalError()
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            iconImageView.image = nil
            label.text = nil
        }
    
    func setConstraints(){
        let constraints = [
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            label.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            label.heightAnchor.constraint(equalTo: iconImageView.heightAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

        func configure(with viewModel: FavoriteRecipesTableViewCellViewModel) {
            label.text = viewModel.foodName
            if let url = URL(string: viewModel.imageURL) {
                iconImageView.load(url: url)
            }
        }
}
