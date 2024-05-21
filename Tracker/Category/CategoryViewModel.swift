//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Сергей on 26.02.2024.
//

import Foundation

class CategoryViewModel{
    
    private(set) var categories: [String] = []  {
        didSet {
            changed?()
        }
    }
    var selectedCategory: String = ""
    var changed: (() -> Void)?

    func getCategories() {
       
        let cats = TrackerCategoryStore.shared.fetchCategories()
        for category in cats {
            categories.append(category.title)
        }
    }
    
    func numberOfRows() -> Int {
        categories.count
    }
    
    func deleteCategory(with title: String) {
        TrackerCategoryStore.shared.deleteCategory(with: title)
        categories.removeAll { category in
            category == title
        }
    }
    
    func updateCategory(category: String) {
        categories.append(category)
    }
}
