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
    func trackerWasDeleted(name: String, id: UUID)
    func editTracker(with id: UUID, completedDays: Int)
    func pinTracker(with tracker: Tracker)
}

final class TrackerCell: UICollectionViewCell {
    
    private let analiticService = AnaliticService()
    private var isCompleted: Bool = false
    private var trackerID: UUID?
    private var indexPath: IndexPath?
    private var completedDays: Int?
    
    weak var delegate: TrackerCellDelegate?
    
    
    private var emoji = UILabel()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    private var emojiView: UIView = {
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
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    @objc func plusButtonTapped() {
        guard let trackerID = trackerID, let indexPath = indexPath else {
            assertionFailure("no tracker id")
            return
        }
        
        if isCompleted {
            delegate?.uncomletedTracker(id: trackerID, indexPath: indexPath)
        } else {
            delegate?.comletedTracker(id: trackerID, indexPath: indexPath)
            AnaliticService.report(event: "track", params: ["screen" : "Main", "item" : "track"])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setInteraction()
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setInteraction() {
        let interaction = UIContextMenuInteraction(delegate: self)
        trackerView.addInteraction(interaction)
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
            
            label.topAnchor.constraint(equalTo: emojiView.bottomAnchor,constant: 5),
            label.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12),
            
            emoji.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            emojiView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func set(object: Tracker,
             isCompleted: Bool,
             completedDays: Int,
             indexPath: IndexPath
    ) {
        
        lazy var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        
        self.indexPath = indexPath
        self.isCompleted = isCompleted
        self.trackerID = object.id
        self.completedDays = completedDays
        
        self.trackerView.backgroundColor = object.color
        if !isCompleted {
            self.plusButton.backgroundColor = object.color
            self.plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        } else {
            self.plusButton.backgroundColor = object.color.withAlphaComponent(0.5)
            self.plusButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
        self.trackerView.layer.cornerRadius = 16
        
        let selectedWordDay = getCompletedCount(count: completedDays)
        countLabel.text = "\(selectedWordDay)"
        
        self.label.attributedText = NSMutableAttributedString(string: object.name, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        self.label.textColor  = .white
        
        self.emojiView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        self.emojiView.layer.cornerRadius = 13
        
        self.emoji.text = object.emoji
        self.emoji.textAlignment = .center
        self.emoji.font = .systemFont(ofSize: 12)
        
        self.layer.cornerRadius = 16
    }
    
    func getCompletedCount(count: Int) -> String {
        let formatString: String = NSLocalizedString("completedDaysCount", comment: "")
        let resultString: String = String.localizedStringWithFormat(formatString, count)
        return resultString
    }
    
}

extension TrackerCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let tracker = TrackerStore.shared.convertToTracker(coreDataTracker: TrackerStore.shared.fetchTracker(with: self.trackerID ?? UUID()))
            let title = tracker.isPinned ? NSLocalizedString("Unpin", comment: "") : NSLocalizedString("Pin", comment: "")
            let pinAction = UIAction(title: title) { action in
                
                self.delegate?.pinTracker(with: tracker)
            }
            
            let editAction = UIAction(title: NSLocalizedString("Edit Title", comment: "")) { action in
                AnaliticService.report(event: "click", params: ["screen" : "Main", "item" : "edit"])
                guard let trackerID = self.trackerID,
                      let completedDays = self.completedDays else { return }
                
                self.delegate?.editTracker(with: trackerID, completedDays: completedDays)
            }
            
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""), attributes: .destructive ) { _ in
                AnaliticService.report(event: "click", params: ["screen" : "Main", "item" : "delete"])
                guard let name = self.label.text,
                      let trackerID = self.trackerID else {
                    return
                }
                
                self.delegate?.trackerWasDeleted(name: name, id: trackerID)
               
            }
            
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
        
        return configuration
    }
}
