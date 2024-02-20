//
//  ViewController.swift
//  Tracker
//
//  Created by Сергей on 24.11.2023.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    private let dateFormatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yy"
        return dateformatter
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collection.register(TrackerHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackerHeaderCell")
        return collection
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var emptyView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private lazy var datePicker: UIDatePicker = {
            let datePicker = UIDatePicker()
            datePicker.preferredDatePickerStyle = .compact
            datePicker.datePickerMode = .date
            datePicker.tintColor = .ypBlue
            datePicker.locale = Locale(identifier: "ru_RU")
            datePicker.calendar.firstWeekday = 2
            datePicker.clipsToBounds = true
            datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
            return datePicker
        }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Поиск"
        textField.delegate = self
        return textField
    }()
    
    private var categories: [TrackerCategory] = []
    
    private var visibleCategories: [TrackerCategory] = []
    
    private var completedTrackers: [TrackerRecord] = []
    
   
    
    var currentDate = Date()
    
    var formattedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TrackerCategoryStore.shared.delegate = self
        setupViews()
        setupContraints()
        setupNavBar()
        datePicker.date = currentDate
        fetchTrackers()
        fetchRecords()
        createGesture()
        setupEmptyViews()
        
    }
    
    private func fetchTrackers() {
        let coreDataCats = TrackerCategoryStore.shared.fetchCoreDataCategory()
        let objects = TrackerCategoryStore.shared.convertToCategory(coreDataCats)
        categories = objects
        reloadVisibleCategories()
    }
    
    private func fetchRecords() {
        let coreDataRecords = TrackerRecordStore.shared.fetchRecords()
        let records = TrackerRecordStore.shared.convertRecord(records: coreDataRecords)
        completedTrackers = records
        reloadVisibleCategories()
        
    }
    
    private func setupEmptyViews() {
        [emptyView, emptyLabel].forEach {
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 8),
            
        ])
        
        if visibleCategories.isEmpty {
            emptyView.isHidden = false
            emptyLabel.isHidden = false
            emptyView.image = UIImage(named: "mockImage")
            emptyLabel.text = "Что будем отслеживать?"
        }
    }
    
    private func setupContraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 35),
        ])
        
    }
    
    private func createGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    private func setupViews() {
        [collectionView, searchTextField, titleLabel].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .white
    }
    
    private func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.shadowImage = UIImage()
        navBar.barTintColor = view.backgroundColor
        let addTaskButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addTaskButton.tintColor = .black
        navBar.topItem?.setLeftBarButton(addTaskButton, animated: false)
        let customBarItem = UIBarButtonItem(customView: datePicker)
        customBarItem.customView?.widthAnchor.constraint(equalToConstant: 120).isActive = true
        navBar.topItem?.setRightBarButton(customBarItem, animated: false)
    }
    
    private func configureEmptyVIew() {
        
        if  categories.isEmpty && visibleCategories.isEmpty {
            
            emptyView.isHidden = false
            emptyLabel.isHidden = false
            emptyView.image = UIImage(named: "mockImage")
            emptyView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            emptyView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            emptyLabel.text = "Что будем отслеживать?"
            
        } else if visibleCategories.isEmpty {
            emptyView.isHidden = false
            emptyLabel.isHidden = false
            emptyView.image = UIImage(named: "notFound")
            emptyView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            emptyView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            emptyLabel.text = "Ничего не найдено"
    
        } else {
            emptyView.isHidden = true
            emptyLabel.isHidden = true
        }
    }
    
    private func reloadVisibleCategories() {
        let selectedDate = datePicker.date
        let calendar = Calendar.current
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let weekDaySymbols  = dateFormatter.shortWeekdaySymbols
        let filterWeekDay = calendar.component(.weekday, from: selectedDate)
        let filterText = (searchTextField.text ?? "").lowercased()
        let weekDayName = weekDaySymbols?[filterWeekDay - 1]
        guard let day = weekDayName else { return }
        visibleCategories = categories.compactMap { category in
            
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.name.lowercased().contains(filterText)
                
                let dayCondition = tracker.schedule.contains { weekDay in
                    weekDay.shortTitle == day
                }
                
                return textCondition && dayCondition
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(title: category.title,
                                   trackers: trackers)
        }
        
        configureEmptyVIew()
        collectionView.reloadData()
        
    }
    
    private func isTrackerComletedToday(id: UUID)  -> Bool {
        completedTrackers.contains { tracker in
            let isSameDay = Calendar.current.isDate(tracker.date, inSameDayAs: datePicker.date)
            return tracker.id == id && isSameDay
        }
    }
    
    private func isDateGreaterThanCurrent(cell: TrackerCell) {
        let dateisGreater = datePicker.date <= currentDate ? true : false
        
        if dateisGreater {
            cell.plusButton.isEnabled = true
        } else {
            cell.plusButton.isEnabled = false
        }
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        reloadVisibleCategories()
        
    }
    
    @objc private func addButtonTapped() {
        let selectTrackerTypeController = SelectTrackerTypeController()
        selectTrackerTypeController.habitCreateViewControllerDelegate = self
        selectTrackerTypeController.irregularViewControllerDelegate = self
        self.present(selectTrackerTypeController, animated: true)
        
    }
    
    @objc func hideKeyboard() {
        reloadVisibleCategories()
        searchTextField.resignFirstResponder()
    }
}

//MARK: - UITextFieldDelegate

extension TrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadVisibleCategories()
        
        return true
    }
}

//MARK: - UICollectionViewDataSource

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = visibleCategories[section].trackers
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
        cell.delegate = self
        isDateGreaterThanCurrent(cell: cell)
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let isComletedToday = isTrackerComletedToday(id: tracker.id)
        let comletedDays = completedTrackers.filter { $0.id ==
            tracker.id
        }.count
        cell.set(object: tracker, isComleted: isComletedToday, completedDays: comletedDays, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cellView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackerHeaderCell", for: indexPath) as? TrackerHeaderCell else {
            return UICollectionReusableView()
        }
        
        let text = visibleCategories[indexPath.section].title
        cellView.title.text = text
        cellView.title.font = .systemFont(ofSize: 19, weight: .bold)
        
        return cellView
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

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


//MARK: - HabitCreateViewControllerDelegate

extension TrackerViewController: HabitCreateViewControllerDelegate {
    func createButtonTap(_ tracker: Tracker, category: String) {
        if let index = categories.firstIndex(where: { $0.title == category }) {
            var updatedTrackers = categories[index].trackers
            updatedTrackers.append(tracker)
            let updatedCategory =  TrackerCategory(title: category, trackers: updatedTrackers)
            categories[index] = updatedCategory
        } else {
            let newCategory =  TrackerCategory(title: category, trackers: [tracker])
            categories.append(newCategory)
        }
        emptyView.isHidden = true
        emptyLabel.isHidden = true
        reloadData()
    }
    
    func reloadData() {
        reloadVisibleCategories()
    }
}


extension TrackerViewController: IrregularEventViewControllerDelegate {
    func createButtonTapped(_ tracker: Tracker, category: String) {
        if let index = categories.firstIndex(where: { $0.title == category }) {
            var updatedTrackers = categories[index].trackers
            updatedTrackers.append(tracker)
            let updatedCategory =  TrackerCategory(title: category, trackers: updatedTrackers)
            categories[index] = updatedCategory
        } else {
            let newCategory =  TrackerCategory(title: category, trackers: [tracker])
            categories.append(newCategory)
        }
        emptyView.isHidden = true
        emptyLabel.isHidden = true
        reloadData()
    }
    
    func reloadTrackersData() {
        reloadVisibleCategories()
    }
    
    
}

//MARK: - TrackerCellDelegate

extension TrackerViewController: TrackerCellDelegate {
    func comletedTracker(id: UUID, indexPath: IndexPath) {
        
        
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        TrackerRecordStore.shared.addRecord(tracker: trackerRecord)
        completedTrackers.append(trackerRecord)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncomletedTracker(id: UUID, indexPath: IndexPath) {
        
        completedTrackers.removeAll { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            TrackerRecordStore.shared.deleteRecord(id: trackerRecord.id)
            return trackerRecord.id == id && isSameDay
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

extension TrackerViewController: TrackerCategoryStoreDelegate {
    func trackerCategoryUpdate(title: String) {
        categories.removeAll { category in
            category.title == title
        }
        reloadVisibleCategories()
    }
}
