//
//  AddCategoryViewController.swift
//  Tracker
//
//  Created by Сергей on 16.02.2024.
//

import UIKit

protocol AddCategoryVCDelegate: AnyObject {
    func categoryAdded(category: String)
}

final class AddCategoryViewController: UIViewController {
    
    weak var delegate: AddCategoryVCDelegate?
    
    private lazy var categoryTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("newCategoryTitle", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("addCategoryButton", comment: ""), for: .normal)
        button.setTitleColor(Colors.shared.buttonTextColor, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped(_ :)), for: .touchUpInside)
        button.backgroundColor = Colors.shared.buttonsBackground
        button.layer.cornerRadius = 16
        button.isEnabled = false
        return button
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
    
    private var textFieldView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = Colors.shared.dark
        return view
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("newCategoryTFPlaceholder", comment: "")
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.addTarget(self, action: #selector(didChangeTF), for: .editingChanged)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        createGesture()
        
    }
    
    private func createGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        [categoryTitle, doneButton, textFieldView].forEach {
            view.addSubview($0)
        }
        [textField, clearTextFieldButton].forEach {
            textFieldView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            categoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldView.topAnchor.constraint(equalTo: categoryTitle.bottomAnchor, constant: 30),
            textFieldView.heightAnchor.constraint(equalToConstant: 75),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            clearTextFieldButton.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor),
            clearTextFieldButton.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            clearTextFieldButton.widthAnchor.constraint(equalTo: clearTextFieldButton.heightAnchor),
            textField.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: clearTextFieldButton.leadingAnchor, constant: -12),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    private func addCategoryToDB() {
        guard let text = textField.text else { return }
        let category = TrackerCategory(title: text, trackers: [])
        TrackerCategoryStore.shared.addCategory(category: category)
    }
    
    @objc func didChangeTF() {
        guard let text = textField.text else { return }
        if text.isEmpty {
            doneButton.isEnabled = false
            doneButton.backgroundColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
            clearTextFieldButton.isHidden = true
        } else {
            doneButton.isEnabled = true
            doneButton.backgroundColor = .black
            clearTextFieldButton.isHidden = false
        }
    }
    
    @objc func doneButtonTapped(_ sender: UIAction) {
        guard let text = textField.text else { return }
        addCategoryToDB()
        delegate?.categoryAdded(category: text)
        dismiss(animated: true)
        
    }
    
    @objc func clearTextFieldButtonTapped() {
        textField.text = ""
        doneButton.isEnabled = false
        doneButton.backgroundColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
        
    }
    
    @objc private func hideKeyboard() {
        textField.resignFirstResponder()
    }
}
