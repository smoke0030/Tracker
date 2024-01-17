//
//  TrackerHeaderCell.swift
//  Tracker
//
//  Created by Сергей on 15.12.2023.
//

import UIKit

class HabitCollectionEmojiHeaderCell: UICollectionReusableView {
    
    var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 19, weight: .bold)
        title.textColor = .black
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        
        NSLayoutConstraint.activate([title.topAnchor.constraint(equalTo: topAnchor),
                                     title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18)
                                    ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
