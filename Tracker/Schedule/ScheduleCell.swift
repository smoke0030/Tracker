//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Сергей on 20.12.2023.
//

import UIKit

class ScheduleCell: UITableViewCell {
    
    let cellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellLabel)
        
        NSLayoutConstraint.activate([
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSwitch(at indexPath: IndexPath) {
        let switchView = UISwitch()
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        self.accessoryView = switchView
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("On")
        } else {
            print("Off")
        }
        
        
    }
}
