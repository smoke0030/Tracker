//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Сергей on 29.12.2023.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func didSelectCategory(category: String)
}

final class CategoryViewController: UIViewController {
    
    
    weak var delegate: CategoryViewControllerDelegate?
    
    private let addCategoryVC = AddCategoryViewController()
    
    var categories: [String] = []
    
    private var newCategory = ""
    
    private lazy var categoryTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категории"
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
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addCategoryButtonTapped(_ :)), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCategories()
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
    
    private func getCategories() {
        let dataObjects = TrackerCategoryStore.shared.fetchCoreDataCategory()
        let fetchedCats = TrackerCategoryStore.shared.convertToCategory(dataObjects)
        for cat in fetchedCats {
            categories.append(cat.title)
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
        return  categories.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.selectionStyle = .none
        let object = categories[indexPath.row]
        cell.set(cell: cell, categories: categories, object: object, indexPath: indexPath)
        cell.layer.cornerRadius = 16
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastCell = indexPath.row == categories.count - 1
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
        if let text = cell.titleLabel.text {
                delegate?.didSelectCategory(category: text)
                cell.doneImageView.isHidden = false
            }
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
        categories.append(category)
        categoryTableView.reloadData()
        
    }
    
    
}
