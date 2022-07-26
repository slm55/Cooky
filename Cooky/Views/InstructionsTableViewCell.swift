//
//  InstructionsTableViewCell.swift
//  Cooky
//
//  Created by Aslan Murat on 26.07.2022.
//

import UIKit

class InstructionsTableViewCell: UITableViewCell {
    static let identifier = "InstructionsTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let constraints = [
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with instruction: Instruction) {
        label.text = instruction.displayText
    }
}
