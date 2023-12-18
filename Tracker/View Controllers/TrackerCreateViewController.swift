//
//  TrackerCreateViewController.swift
//  Tracker
//
//  Created by Сергей on 11.12.2023.
//

import UIKit



class TrackerCreateViewController: UIViewController {
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        
    }
    
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Создание трекера"
        title.font = .systemFont(ofSize: 16)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let habitButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(habitButoonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    let irregularEventButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setTitle("Нерегулярное событие", for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    @objc func habitButoonTapped() {
        print("Habit")
    }
    
    @objc func irregularEventButtonTapped() {
        print("irregular")
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
        
        NSLayoutConstraint.activate([
                                     titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
                                     habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     habitButton.topAnchor.constraint(equalTo: view.centerYAnchor),
                                     habitButton.widthAnchor.constraint(equalToConstant: 300),
                                     habitButton.heightAnchor.constraint(equalToConstant: 60),
                                     irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
                                     irregularEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     irregularEventButton.widthAnchor.constraint(equalToConstant: 300),
                                     irregularEventButton.heightAnchor.constraint(equalToConstant: 60)
                                     
                                     
        ])
    }
}




