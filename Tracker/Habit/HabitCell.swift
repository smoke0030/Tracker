//
//  HabitCell.swift
//  Tracker
//
//  Created by Сергей on 19.12.2023.
//

import UIKit

class HabitCell: UITableViewCell {
    
    private lazy var detailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "chevron"), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailButton)
        contentView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9098039216, blue: 0.9215686275, alpha: 0.7017367534)
        
        NSLayoutConstraint.activate([
            detailButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
