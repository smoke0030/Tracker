

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func trackerCategoryUpdate() -> Void
}

final class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private let colorMarshalling = UIColorMarshalling()
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    //получение категорий из базы
    
    func fetchCoreDataCategory() -> [TrackerCategoryCoreData] {
        var categories: [TrackerCategoryCoreData] = []
        let request = TrackerCategoryCoreData.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
        return categories
    }
    
    func fetchCategoryWithTitle(title: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        var category: [TrackerCategoryCoreData] = []
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "title == %@", title)
        do {
            category = try context.fetch(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        guard let firstCat = category.first else {
            fatalError("fatal error")
        }
        if category.count > 0 {
            return firstCat
        } else {
            return nil
            
        }
    }
    
    //конвертация из данных базы в структуру
    
    func convertToCategory(_ categories: [TrackerCategoryCoreData]) -> [TrackerCategory] {
        var returnedCategories: [TrackerCategory] = []
        for category in categories {
            let title = category.title!
            let allTrackers = category.trackers?.allObjects as? [TrackerCoreData]
            var trackers: [Tracker] = []
            guard let allTrackers = allTrackers else {
                fatalError("error")
            }
            for tracker in allTrackers {
                let id = tracker.id!
                let name = tracker.name!
                let color = colorMarshalling.color(from: tracker.color!)!
                let emoji = tracker.emoji!
                let schedule = tracker.schedule!
                let newSchedule = schedule.compactMap() {
                    WeekDay(rawValue: $0)
                }
                let newTracker = Tracker(
                    id: id,
                    name: name,
                    color: color,
                    emoji: emoji,
                    schedule: newSchedule)
                trackers.append(newTracker)
            }
            let category = TrackerCategory(title: title, trackers: trackers)
            returnedCategories.append(category)
        }
        return returnedCategories
    }
    
    func ifCategoryAlreadyExist(category: TrackerCategory) -> Bool {
        var categories: [TrackerCategoryCoreData] = []
        
        let request = TrackerCategoryCoreData.fetchRequest()
        do {
            categories = try context.fetch(request)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if categories.contains(where: { $0.title == category.title }) {
            return true
        } else {
            return false
        }
    }
    
    func addCategory(category:  TrackerCategory) {
        
        let newCategory = TrackerCategoryCoreData(context: context)
        
        if !ifCategoryAlreadyExist(category: category) {
            newCategory.title = category.title
            appDelegate.saveContext()
        }
    }
    
    //метод для отображение пути к базе
    
    public func log() {
        if let url = appDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print(url)
        }
    }
}


