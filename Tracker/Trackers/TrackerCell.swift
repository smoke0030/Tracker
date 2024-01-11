//
//  TrackerCell.swift
//  Tracker
//
//  Created by Сергей on 14.12.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func comletedTracker(id: UUID, indexPath: IndexPath)
    func uncomletedTracker(id: UUID, indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    
    private var isComleted: Bool = false
    private var trackerID: UUID?
    private var indexPath: IndexPath?
    
    
    weak var delegate: TrackerCellDelegate?
    
    let label = UILabel()
    var emoji = UILabel()
    var emojiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let trackerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    @objc func plusButtonTapped() {
        guard let trackerID = trackerID, let indexPath = indexPath else {
            assertionFailure("no tracker id")
            return
        }
        
        if isComleted {
            delegate?.uncomletedTracker(id: trackerID, indexPath: indexPath)
        } else {
            delegate?.comletedTracker(id: trackerID, indexPath: indexPath)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [countLabel, trackerView, plusButton].forEach {
            contentView.addSubview($0)
        }
        trackerView.addSubview(label)
        trackerView.addSubview(emojiView)
        emojiView.addSubview(emoji)
    }
    
    private func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 12),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            plusButton.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            
            trackerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            
            label.topAnchor.constraint(equalTo: emojiView.bottomAnchor,constant: 8),
            label.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            label.heightAnchor.constraint(equalToConstant: 34),
            
            emoji.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            emojiView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    func set(object: Tracker, 
             isComleted: Bool,
             completedDays: Int,
             indexPath: IndexPath
        ) {
        
        self.indexPath = indexPath
        self.isComleted = isComleted
        self.trackerID = object.id
        
        self.trackerView.backgroundColor = object.color
        if !isComleted {
            self.plusButton.backgroundColor = object.color
            self.plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        } else {
            self.plusButton.backgroundColor = object.color.withAlphaComponent(0.5)
            self.plusButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
        self.trackerView.layer.cornerRadius = 16
        
        let wordDay = convertCompletedDays(completedDays)
        countLabel.text = "\(wordDay)"
        
        self.label.text = object.name
        self.label.textColor  = .white
        self.label.font = .systemFont(ofSize: 12)
        
        self.emojiView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        self.emojiView.layer.cornerRadius = 13
        
        self.emoji.text = object.emoji
        self.emoji.textAlignment = .center
        self.emoji.font = .systemFont(ofSize: 12)
        
        self.layer.cornerRadius = 16
    }
    
    private func convertCompletedDays(_ completedDays: Int) -> String {
        let number = completedDays % 10
        let lastTwoNumbers = completedDays % 100
        if lastTwoNumbers >= 11 && lastTwoNumbers <= 19 {
            return "\(completedDays) дней"
        }

        switch number {
        case 1:
            return "\(completedDays) день"
        case 2, 3, 4:
            return "\(completedDays) дня"
        default:
            return "\(completedDays) дней"
        }
    }
}
