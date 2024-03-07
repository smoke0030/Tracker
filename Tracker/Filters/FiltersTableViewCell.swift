//
//  TableViewCell.swift
//  Tracker
//
//  Created by Сергей on 06.03.2024.
//

import UIKit

class FiltersTableViewCell: UITableViewCell {
    
    private let filters: [String] = [
        NSLocalizedString("All trackers", comment: ""),
        NSLocalizedString("Trackers for today", comment: ""),
        NSLocalizedString("CompletedTrackers", comment: ""),
        NSLocalizedString("Not completed trackers", comment: "")
    ]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with indexPath: IndexPath) {
        textLabel?.text = filters[indexPath.row]
        backgroundColor = Colors.shared.dark
        
    }
}
