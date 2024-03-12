//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Сергей on 06.03.2024.
//

import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func didSelectFilter(filter: String)
}

final class FiltersViewController: UIViewController {
    
    weak var delegate: FiltersViewControllerDelegate?
    
    public var selectedFilter: String = String()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = NSLocalizedString("Filters", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
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
        tableView.register(FiltersTableViewCell.self, forCellReuseIdentifier: "FiltersTableViewCell")
        tableView.layer.cornerRadius = 16
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        let defaultString = UserDefaults.standard.string(forKey: "trackers") ?? ""
        selectedFilter = NSLocalizedString("\(defaultString)", comment: "")
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 75 * 4)
        ])
    }
}


extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersTableViewCell", for: indexPath) as! FiltersTableViewCell
        cell.selectionStyle = .none
        cell.set(with: indexPath)
        if selectedFilter == cell.filters[indexPath.row] {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            cell.accessoryType = .checkmark
            cell.isSelected = true
        } 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FiltersTableViewCell
        cell.accessoryType = .checkmark
        
        guard let filter = cell.textLabel?.text else { return }
        self.dismiss(animated: true)
        delegate?.didSelectFilter(filter: filter)
    }
}
