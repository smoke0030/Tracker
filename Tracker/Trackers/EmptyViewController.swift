//
//  EmptyViewController.swift
//  Tracker
//
//  Created by Сергей on 20.12.2023.
//

import UIKit

class EmptyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupContraints()
        setupNavBar()
        datePicker.addTarget(self, action: #selector(dateChanged(_ :)), for: .valueChanged)
    }
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        return datePicker
    }()
    
    private var mainImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "mockImage"))
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        return searchController
    }()
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate  = dateFormatter.string(from: selectedDate)
        print(formattedDate)
    }
    
    @objc func addButtonTapped() {
        let selectTrackerTypeController = SelectTrackerTypeController()
        let trackerVC = TrackerViewController()
        selectTrackerTypeController.delegate = trackerVC
        self.present(selectTrackerTypeController, animated: true)
        
    }
    
    private func setupContraints() {
        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            questionLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 8),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    private func addSubviews() {
        view.addSubview(mainImageView)
        view.addSubview(questionLabel)
    }
    
    private func setupNavBar() {
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
}

