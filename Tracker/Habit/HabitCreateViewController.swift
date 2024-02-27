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

final class HabitCreateViewController: UIViewController {
    
    weak var createHabitViewControllerDelegate: HabitCreateViewControllerDelegate?
    
    private var selectedCategory: String = ""
    
    private var trackers: [Tracker] = []
    
    private var selectedDays: [WeekDay] = []
    
    private var colors = [#colorLiteral(red: 0.9921568627, green: 0.2980392157, blue: 0.2862745098, alpha: 1), #colorLiteral(red: 1, green: 0.5333333333, blue: 0.1176470588, alpha: 1), #colorLiteral(red: 0, green: 0.4823529412, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.2666666667, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2, green: 0.8117647059, blue: 0.4117647059, alpha: 1), #colorLiteral(red: 0.9019607843, green: 0.4274509804, blue: 0.831372549, alpha: 1),
                          #colorLiteral(red: 0.9840622544, green: 0.8660314083, blue: 0.8633159399, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.6549019608, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2745098039, green: 0.9019607843, blue: 0.6156862745, alpha: 1), #colorLiteral(red: 0.2078431373, green: 0.2039215686, blue: 0.4862745098, alpha: 1), #colorLiteral(red: 1, green: 0.4039215686, blue: 0.3019607843, alpha: 1), #colorLiteral(red: 1, green: 0.6, blue: 0.8, alpha: 1),
                          #colorLiteral(red: 0.9647058824, green: 0.768627451, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 0.4745098039, green: 0.5803921569, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.5137254902, green: 0.1725490196, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.6784313725, green: 0.337254902, blue: 0.8549019608, alpha: 1), #colorLiteral(red: 0.5529411765, green: 0.4470588235, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0.1843137255, green: 0.8156862745, blue: 0.3450980392, alpha: 1)]
    
    private let emojies = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                           "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                           "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    
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
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HabitTableCell.self, forCellReuseIdentifier: "HabitTableCell")
        tableView.layer.cornerRadius = 16
        
        return tableView
    }()
    
    private lazy var habitCollectionColorView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "habitCollectionColorView"
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate =  self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(HabitCollectionColorCell.self, forCellWithReuseIdentifier: "HabitCollectionColorCell")
        collectionView.register(HabitCollectionColorHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HabitCollectionColorHeaderCell")
        return collectionView
    }()
    
    private lazy var habitCollectionEmojiView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "habitCollectionEmojiView"
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate =  self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(HabitCollectionEmojiCell.self, forCellWithReuseIdentifier: "HabitCollectionEmojiCell")
        collectionView.register(HabitCollectionEmojiHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HabitCollectionEmojiHeaderCell")
        return collectionView
    }()
    
    private var textFieldView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9098039216, blue: 0.9215686275, alpha: 0.7017367534)
        return view
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.keyboardType = .default
        textField.addTarget(self, action: #selector(didChangeTF), for: .editingChanged)
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
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
    
    private lazy var doneButton: UIButton = {
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
        textField.delegate = self
        setupViews()
        setupConstraints()
        createGesture()
    }
    
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func didChangeTF() {
        guard let text = textField.text else { return }
        if text.isEmpty {
            clearTextFieldButton.isHidden = true
        } else {
            clearTextFieldButton.isHidden = false
        }
        updateCreateButtonState()
    }
    
    @objc private func doneButtonTapped() {
        
        guard let trackerTitle = textField.text, !trackerTitle.isEmpty else {
            return
        }
        
        
        let object = Tracker(id: UUID(), name: trackerTitle, color: selectedColor ?? UIColor(), emoji: selectedEmoji ?? "", schedule: self.selectedDays)
        
        TrackerStore.shared.addTracker(tracker: object, category: TrackerCategory(title: selectedCategory, trackers: []))
        TrackerStore.shared.log()
        createHabitViewControllerDelegate?.createButtonTap(object, category: selectedCategory)
        createHabitViewControllerDelegate?.reloadData()
        dismiss()
        
    }
    
    @objc private func clearTextFieldButtonTapped() {
        textField.text = ""
        updateCreateButtonState()
        clearTextFieldButton.isHidden = true
    }
    
    @objc private func hideKeyboard() {
        textField.resignFirstResponder()
    }
    
    private func dismiss() {
        view.window?.rootViewController?.dismiss(animated: true)
    }
    
    private func updateCreateButtonState() {
        guard let text = textField.text else { return }
        if selectedDays.isEmpty || selectedEmoji == nil ||
            text.isEmpty || selectedColor == nil || selectedCategory == "" {
            doneButton.isEnabled = false
            doneButton.backgroundColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
            
        } else {
            doneButton.isEnabled = true
            doneButton.backgroundColor = .black
        }
    }
    
    private func didSelectEmoji(_ emoji: String) {
        selectedEmoji = emoji
        updateCreateButtonState()
    }
    
    func didSelectColor(_ color: UIColor) {
        selectedColor = color
        updateCreateButtonState()
    }
    
    func didSelectCategory(_ category: String) {
        selectedCategory = category
        updateCreateButtonState()
    }
    
    func scheduleSelected(_ days: [WeekDay]) {
        selectedDays = days
        updateCreateButtonState()
    }
    
    private func createGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    private func generateRandomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    private func addRandomColors() {
        for _ in 1...18 {
            let color = generateRandomColor()
            colors.append(color)
        }
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            habitTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            habitTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldView.topAnchor.constraint(equalTo: habitTitleLabel.bottomAnchor, constant: 30),
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
            tableView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            habitCollectionEmojiView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 30),
            habitCollectionEmojiView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            habitCollectionEmojiView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            habitCollectionEmojiView.heightAnchor.constraint(equalToConstant: 210),
            habitCollectionColorView.topAnchor.constraint(equalTo: habitCollectionEmojiView.bottomAnchor, constant: 30),
            habitCollectionColorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            habitCollectionColorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            habitCollectionColorView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
        ])
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [habitTitleLabel, textFieldView, tableView, habitCollectionColorView, habitCollectionEmojiView, buttonsStackView].forEach {
            view.addSubview($0)
        }
        
        [textField, clearTextFieldButton].forEach {
            textFieldView.addSubview($0)
        }
        
        [cancelButton, doneButton].forEach {
            buttonsStackView.addArrangedSubview($0)
        }
    }
    
}

//MARK: - UITableViewDataSource

extension HabitCreateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitTableCell") as! HabitTableCell

        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.titleLabel.text = "Категория"
            cell.descriptionLabel.text = selectedCategory
        } else {
            cell.titleLabel.text = "Расписание"
            let schedule = selectedDays.isEmpty ? "" : selectedDays.map { $0.shortTitle }.joined(separator: ", ")
            cell.descriptionLabel.text = schedule        
        }
        return cell
    }
}

//MARK: - UITableViewDelegate

extension HabitCreateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let categoryVC = CategoryViewController()
            categoryVC.delegate = self
            present(categoryVC, animated: true)
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            present(scheduleViewController, animated: true)
        }
    }
}

//MARK: - UITextFieldDelegate

extension HabitCreateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - ScheduleViewControllerDelegate

extension HabitCreateViewController: ScheduleViewControllerDelegate {
    func didSelectScheduleDays(_ days: [WeekDay]) {
        scheduleSelected(days)
        tableView.reloadData()
    }
    
}

//MARK: - CategoryViewControllerDelegate

extension HabitCreateViewController: CategoryViewControllerDelegate {
    func didSelectCategory(category: String) {
        didSelectCategory(category)
        tableView.reloadData()
    }
    
    func categoryRemoved() {
        selectedCategory = ""
        tableView.reloadData()
    }
    
    
}

//MARK: - UICollectionViewDataSource

extension HabitCreateViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.accessibilityIdentifier == "habitCollectionColorView" {
            let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCollectionColorCell", for: indexPath) as! HabitCollectionColorCell
            colorCell.label.backgroundColor = colors[indexPath.row]
            return colorCell
        } else if collectionView.accessibilityIdentifier == "habitCollectionEmojiView" {
            let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCollectionEmojiCell", for: indexPath) as! HabitCollectionEmojiCell
            emojiCell.label.text = emojies[indexPath.row]
            return emojiCell
        }
        fatalError("No collection")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView.accessibilityIdentifier == "habitCollectionColorView" {
            let colorHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HabitCollectionColorHeaderCell", for: indexPath) as! HabitCollectionColorHeaderCell
            colorHeaderCell.title.text = "Цвет"
            return colorHeaderCell
        } else if collectionView.accessibilityIdentifier == "habitCollectionEmojiView" {
            let emojiHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HabitCollectionEmojiHeaderCell", for: indexPath) as! HabitCollectionEmojiHeaderCell
            emojiHeaderCell.title.text = "Emoji"
            return emojiHeaderCell
        }
        fatalError("No cells")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.accessibilityIdentifier == "habitCollectionColorView" {
            let colorCell = collectionView.cellForItem(at: indexPath) as! HabitCollectionColorCell
            guard let color = colorCell.label.backgroundColor else { return }
            didSelectColor(color)
            
            colorCell.layer.borderWidth = 3
            colorCell.layer.borderColor = colorCell.label.backgroundColor?.withAlphaComponent(0.3).cgColor
            colorCell.layer.cornerRadius = 12
            
        } else if collectionView.accessibilityIdentifier == "habitCollectionEmojiView" {
            let emojiCell = collectionView.cellForItem(at: indexPath) as! HabitCollectionEmojiCell
            guard let emoji = emojiCell.label.text else { return }
            didSelectEmoji(emoji)
            emojiCell.backgroundColor = #colorLiteral(red: 0.9212860465, green: 0.9279851317, blue: 0.9373531938, alpha: 1)
            emojiCell.layer.cornerRadius = 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.accessibilityIdentifier == "habitCollectionColorView" {
            let colorCell = collectionView.cellForItem(at: indexPath) as! HabitCollectionColorCell
            didSelectColor(UIColor())
            colorCell.layer.borderWidth = 3
            colorCell.layer.borderColor = UIColor.clear.cgColor
            colorCell.layer.cornerRadius = 12
            
        } else if collectionView.accessibilityIdentifier == "habitCollectionEmojiView" {
            let emojiCell = collectionView.cellForItem(at: indexPath) as! HabitCollectionEmojiCell
            didSelectEmoji("")
            emojiCell.backgroundColor = .clear
            emojiCell.layer.cornerRadius = 12
        }
    }
    
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension HabitCreateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView,viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: 20),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 55, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
}

extension HabitCreateViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view,
           view.isDescendant(of: habitCollectionColorView) ||
            view.isDescendant(of: tableView) ||
            view.isDescendant(of: habitCollectionEmojiView) {
            
            return false
        }
        return true
    }
}
