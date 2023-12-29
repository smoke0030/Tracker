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
    
    lazy private var emptyView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "mockImage")
        return view
    }()
    
    var allCategories: [TrackerCategory] = []
    
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
        
        if allCategories.isEmpty {
            view.addSubview(emptyView)
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
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
        view.addSubview(collectionView)
        view.backgroundColor = .white
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
        let selectTrackerTypeController = SelectTrackerTypeController()
        selectTrackerTypeController.delegate = self
        self.present(selectTrackerTypeController, animated: true)
        
    }
}

extension TrackerViewController: UISearchBarDelegate {
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trackers = allCategories.first?.trackers else { return Int()}
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
        let objects = allCategories[indexPath.section].trackers[indexPath.row]
        cell.set(object: objects)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cellView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackerHeaderCell", for: indexPath) as? TrackerHeaderCell else {
            return UICollectionReusableView()
        }
        
        let text = allCategories[indexPath.section].title
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

extension TrackerViewController: HabitCreateViewControllerDelegate {
    func createButtonTap(_ tracker: Tracker, category: String) {
        if let index = allCategories.firstIndex(where: { $0.title == category }) {
            allCategories[index].trackers.append(tracker)
        } else {
            self.allCategories.append(TrackerCategory(title: category, trackers: [tracker]))
        }
        emptyView.isHidden = true
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
