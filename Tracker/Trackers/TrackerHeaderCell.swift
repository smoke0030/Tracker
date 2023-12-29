//
//  TrackerHeaderCell.swift
//  Tracker
//
//  Created by Сергей on 15.12.2023.
//

import UIKit

class TrackerHeaderCell: UICollectionReusableView {
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([title.topAnchor.constraint(equalTo: topAnchor),
                                     title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
                                    ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
