//
//  TrackerCreateViewController.swift
//  Tracker
//
//  Created by Сергей on 11.12.2023.
//

import UIKit

final class SelectTrackerTypeController: UIViewController {
    
    weak var habitCreateViewControllerDelegate: TrackerCreateViewControllerDelegate?
//    weak var irregularViewControllerDelegate: IrregularEventViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
       
    }
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("selectViewTitle", comment: "")
        title.font = .systemFont(ofSize: 16, weight: .medium)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(habitButoonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        let title = NSLocalizedString("selectHabitTitle", comment: "")
        button.setTitle(title, for: .normal)
        button.backgroundColor = Colors.shared.buttonsBackground
        button.setTitleColor(Colors.shared.buttonTextColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        let title = NSLocalizedString("selectIrregularEventTitle", comment: "")
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = Colors.shared.buttonsBackground
        button.setTitleColor(Colors.shared.buttonTextColor, for: .normal)
        return button
    }()
    
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    
    @objc func habitButoonTapped() {
        
        let vc = TrackerCreateViewControlelr()
        vc.createHabitViewControllerDelegate = habitCreateViewControllerDelegate
        vc.isHabit = true
        present(vc, animated: true)
    }
    
    @objc func irregularEventButtonTapped() {
        let vc = TrackerCreateViewControlelr()
        vc.createHabitViewControllerDelegate = habitCreateViewControllerDelegate
        vc.isHabit = false
        present(vc, animated: true)
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(buttonsStackView)
        view.addSubview(titleLabel)
        buttonsStackView.addArrangedSubview(habitButton)
        buttonsStackView.addArrangedSubview(irregularEventButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 140),
            
        ])
    }
}




