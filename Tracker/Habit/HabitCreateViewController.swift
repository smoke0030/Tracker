//
//  HabitTableViewController.swift
//  Tracker
//
//  Created by Сергей on 19.12.2023.
//

import UIKit

protocol HabitCreateViewControllerDelegate: AnyObject {
    func createButtonTap(_ tracker: Tracker, category: String)
    func reloadData()
}

class HabitCreateViewController: UIViewController {
    
    weak var createHabitViewControllerDelegate: HabitCreateViewControllerDelegate?
    
    private var trackers: [Tracker] = []
    private lazy var category: String = "Домашние дела"
    private var selectedDays: [String] = []
    
    private var habitTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая привычка"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var clearTextFieldButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.addTarget(self, action: #selector(clearTextFieldButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.tintColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HabitCell.self, forCellReuseIdentifier: "HabitCell")
        tableView.layer.cornerRadius = 16
        
        return tableView
    }()
    
    private var textFieldView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9098039216, blue: 0.9215686275, alpha: 0.7017367534)
        return view
    }()
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        return textField
    }()
    
    private var cancelButton: UIButton = {
        var button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    
    private var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = #colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        textField.delegate = self
    }
    
    
    @objc private func cancelButtonTapped() {
        print("cancel")
        dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        
        guard let trackerTitle = textField.text, !trackerTitle.isEmpty else {
            return
        }
        
        let object = Tracker(id: UUID(), name: trackerTitle, color: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1  ), emoji: "🫡", schedule: [])
        createHabitViewControllerDelegate?.createButtonTap(object, category: category)
        createHabitViewControllerDelegate?.reloadData()
        
        view.window?.rootViewController?.dismiss(animated: true)
        
    }
    
    @objc private func clearTextFieldButtonTapped() {
        textField.text = ""
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            habitTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            habitTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldView.topAnchor.constraint(equalTo: habitTitleLabel.bottomAnchor, constant: 40),
            textFieldView.heightAnchor.constraint(equalToConstant: 75),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: clearTextFieldButton.leadingAnchor, constant: -12),
            clearTextFieldButton.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor),
            clearTextFieldButton.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonsStackView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            tableView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    private func setupViews() {
        view.addSubview(habitTitleLabel)
        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        textFieldView.addSubview(clearTextFieldButton)
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(doneButton)
    }
    
}

extension HabitCreateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as! HabitCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.titleLabel.text = "Категория"
            cell.descriptionLabel.text = "Важное"
        } else {
            cell.titleLabel.text = "Расписание"
            cell.descriptionLabel.text = selectedDays.joined(separator: ", ")
        }
        return cell
    }
}

extension HabitCreateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            print("category")
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            present(scheduleViewController, animated: true)
        }
    }
}

extension HabitCreateViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            clearTextFieldButton.isHidden = true
        } else {
            clearTextFieldButton.isHidden = false
        }
    }
}

extension HabitCreateViewController: ScheduleViewControllerDelegate {
    func didSelectScheduleDays(_ days: [String]) {
        selectedDays = days
        tableView.reloadData()
    }
    
}
