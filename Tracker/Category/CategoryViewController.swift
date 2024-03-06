//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Сергей on 29.12.2023.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func didSelectCategory(category: String)
    func categoryRemoved()
}

final class CategoryViewController: UIViewController {
    
    var categoryViewModel: CategoryViewModel!
    
    weak var delegate: CategoryViewControllerDelegate?
    
    private lazy var categoryTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("categotyTitle", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.allowsMultipleSelection = false
        
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = NSLocalizedString("categoryCreateButton", comment: "")
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addCategoryButtonTapped(_ :)), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var emptyView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            bind()
            setupViews()
            setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryViewModel.getCategories()
        updateEmptyView()
    }
    
    private func bind() {
        categoryViewModel = CategoryViewModel()
        categoryViewModel.changed = { [weak self] in
            guard let self = self else { return }
                self.updateEmptyView()
                self.categoryTableView.reloadData()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(categoryTitle)
        view.addSubview(categoryTableView)
        view.addSubview(addCategoryButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            categoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryTableView.topAnchor.constraint(equalTo: categoryTitle.bottomAnchor, constant: 40),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -47),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateEmptyView() {
        guard let categoryViewModel = categoryViewModel else { return }
        
        if categoryViewModel.categories.isEmpty {
            [emptyView, emptyLabel].forEach {
                view.addSubview($0)
            }
            NSLayoutConstraint.activate([
                emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 8),
                
            ])
            
            emptyView.isHidden = false
            emptyLabel.isHidden = false
            emptyView.image = UIImage(named: "mockImage")
            emptyLabel.text = NSLocalizedString("categoriesEmptyLabel", comment: "")
        } else {
            emptyView.isHidden = true
            emptyLabel.isHidden = true
            
        }
    }
    
    @objc func addCategoryButtonTapped(_ sender: UIAction) {
        let addCategoryVC = AddCategoryViewController()
        addCategoryVC.delegate = self
        present(addCategoryVC, animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  categoryViewModel.numberOfRows()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.selectionStyle = .none
        let object = categoryViewModel.categories[indexPath.row]
        cell.set(cell: cell, categories: categoryViewModel.categories, object: object, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastCell = indexPath.row == categoryViewModel.categories.count - 1
        if lastCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CategoryCell
        guard let title = cell.titleLabel.text else { return }
        delegate?.didSelectCategory(category: title)
        cell.doneImageView.isHidden = false
        dismiss(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! CategoryCell
        return UIContextMenuConfiguration(actionProvider:  { actions in
            return UIMenu(children: [
                UIAction(title: "Удалить", handler: { _ in
                    guard let text = cell.titleLabel.text else { return }
                    self.categoryViewModel.deleteCategory(with: text)
                    self.delegate?.categoryRemoved()
                })
            ])
        })
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! CategoryCell
        if !cell.isSelected {
            cell.doneImageView.isHidden = true
            
        }
    }
}

extension CategoryViewController: AddCategoryVCDelegate {
    func categoryAdded(category: String) {
        categoryViewModel.updateCategory(category: category)
    }
}
