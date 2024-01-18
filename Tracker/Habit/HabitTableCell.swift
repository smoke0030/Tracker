//
//  HabitCell.swift
//  Tracker
//
//  Created by Сергей on 19.12.2023.
//

import UIKit

final class HabitTableCell: UITableViewCell {
    
    private lazy var detailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "chevron"), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [titleLabel, descriptionLabel, detailButton].forEach {
            contentView.addSubview($0)
        }
        contentView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9098039216, blue: 0.9215686275, alpha: 0.7017367534)
        
        NSLayoutConstraint.activate([
            detailButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -14),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -14),
            contentView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if descriptionLabel.text?.isEmpty ?? true {
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            descriptionLabel.isHidden = true
        } else {
            titleLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
            descriptionLabel.isHidden = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
