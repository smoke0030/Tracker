//
//  ViewController.swift
//  Tracker
//
//  Created by Сергей on 24.11.2023.
//

import UIKit

class TrackerViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        searchBar.delegate = self
        addSubviews()
        setupContraints()
        setupNavBar()
    }
    
    private let addTask: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "add_tracker"),
            style: .plain, target: self,
            action: #selector(addButtonTapped))
        button.tintColor = .black
        return button
    }()

    private let datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
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
    
    @objc func addButtonTapped() {
        
    }
    
    private func setupContraints() {
        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            questionLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 8),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
       
    }
    
    private func addSubviews() {
        view.addSubview(mainImageView)
        view.addSubview(questionLabel)
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = addTask
        navigationItem.searchController = searchController
        let customBarItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = customBarItem
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension TrackerViewController: UISearchBarDelegate {
    
}
