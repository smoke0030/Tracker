//
//  CategoryCell.swift
//  Tracker
//
//  Created by Сергей on 29.12.2023.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9098039216, blue: 0.9215686275, alpha: 0.7017367534)
        return view
    }()
    
    lazy var doneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .blue
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellView)
        
        [titleLabel, doneImageView].forEach {
            cellView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: doneImageView.leadingAnchor, constant: -10),
            doneImageView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16),
            doneImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cell: UITableViewCell, categories: [String], object: String, indexPath: IndexPath) {
            cell.layer.cornerRadius = 16
            contentView.backgroundColor = .clear
            titleLabel.layer.cornerRadius = 0
            titleLabel.textColor = .black
            titleLabel.text = object
            doneImageView.isHidden = true

            let cornerRadius: CGFloat = 16
            var maskPath = UIBezierPath(roundedRect: cell.bounds,
                                        byRoundingCorners: [],
                                        cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        if indexPath.row == 0 && categories.count == 1 {
            maskPath = UIBezierPath(roundedRect: cell.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight, .topRight, .topLeft],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        } else if indexPath.row == categories.count - 1 {
                maskPath = UIBezierPath(roundedRect: cell.bounds,
                                       byRoundingCorners: [.bottomLeft, .bottomRight],
                                       cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            } else if indexPath.row  == 0 {
                maskPath = UIBezierPath(roundedRect: cell.bounds,
                                        byRoundingCorners: [.topRight, .topLeft],
                                        cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            }

            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            cell.layer.mask = maskLayer
    }
}
