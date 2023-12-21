//
//  ViewController.swift
//  Tracker
//
//  Created by Сергей on 24.11.2023.
//

import UIKit

class TrackerViewController: UIViewController {
    
    static let shared = TrackerViewController()
    
    lazy private var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collection.register(TrackerHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackerHeaderCell")
        return collection
    }()
    
    var categories: [TrackerCategory] = [
        TrackerCategory(title: "Бытовые дела",
                        trackers: [
                            Tracker(id: UUID(), name: "Поливать растения", color: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), emoji: "💐", schedule: [Date()]),
                            Tracker(id: UUID(), name: "Учиться iOS разработке", color: #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), emoji: "🗿", schedule: [Date()]),
                            Tracker(id: UUID(), name: "работать работу", color: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), emoji: "🥲", schedule: [Date()]),
                        ]),
        TrackerCategory(title: "Другие дела",
                        trackers: [
                            Tracker(id: UUID(), name: "Гулять", color: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), emoji: "😌", schedule: [Date()]),
                            Tracker(id: UUID(), name: "Играть на гитаре", color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), emoji: "🤓", schedule: [Date()]),
                            Tracker(id: UUID(), name: "Тупить", color: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), emoji: "😱", schedule: [Date()]),
                        ])
    ]
    
    var completedTrackers: [TrackerRecord] = []
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
       
        return datePicker
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()
        setupNavBar()
        datePicker.addTarget(self, action: #selector(dateChanged(_ :)), for: .valueChanged)
    }
    
    private func setupContraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    private func setupNavBar() {
        navigationController?.hidesBarsOnSwipe = true
        guard let navBar = navigationController?.navigationBar else { return }
        let addTaskButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addTaskButton.tintColor = .black
        navBar.topItem?.setLeftBarButton(addTaskButton, animated: false)
        navigationItem.searchController = searchController
        let customBarItem = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.setRightBarButton(customBarItem, animated: false)
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate  = dateFormatter.string(from: selectedDate)
        print(formattedDate)
    }
    
    @objc private func addButtonTapped() {
        let vc = SelectTrackerTypeController()
        self.present(vc, animated: true)
        
    }
}

extension TrackerViewController: UISearchBarDelegate {
    
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trackers = categories.first?.trackers else { return Int()}
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
        cell.trackerView.widthAnchor.constraint(equalToConstant: (collectionView.bounds.width - 45) / 2).isActive = true
        let object = categories[indexPath.section].trackers[indexPath.row]
        
        cell.set(object: object)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cellView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackerHeaderCell", for: indexPath) as? TrackerHeaderCell else {
            return UICollectionReusableView()
        }
        
        let text = categories[indexPath.section].title
        cellView.title.text = text
        cellView.title.font = .systemFont(ofSize: 19, weight: .bold)
        
        return cellView
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 45) / 2, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView,viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: 20),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}
