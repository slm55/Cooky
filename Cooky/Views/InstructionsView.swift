//
//  InstructionsView.swift
//  Cooky
//
//  Created by Aslan Murat on 26.07.2022.
//

import UIKit

class InstructionsView: UIView {
    private let instructions: [Instruction]
    
    private let instructionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Instructions"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var instructionsTableView: UITableView =  {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.backgroundColor = .systemPink
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(InstructionsTableViewCell.self, forCellReuseIdentifier: InstructionsTableViewCell.identifier)
        return tableView
    }()
    
    required init(instructions: [Instruction]) {
        self.instructions = instructions

        super.init(frame: .zero)
        
        addSubview(instructionsTitleLabel)
        addSubview(instructionsTableView)
        
        instructionsTableView.dataSource = self
        instructionsTableView.delegate = self
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let constraints = [
            instructionsTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            instructionsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            instructionsTableView.topAnchor.constraint(equalTo: instructionsTitleLabel.bottomAnchor, constant: 8),
            instructionsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            instructionsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            instructionsTableView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func updateConstraints() {
        instructionsTableView.heightAnchor.constraint(equalToConstant: instructionsTableView.contentSize.height).isActive = true
        
        super.updateConstraints()
    }
}

extension InstructionsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = instructionsTableView.dequeueReusableCell(withIdentifier: InstructionsTableViewCell.identifier, for: indexPath) as? InstructionsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: instructions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
