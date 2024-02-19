

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func trackerCategoryUpdate(title: String)
}

final class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    
    private override init() {
        super.init()
    }
    
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
            assertionFailure("No category")
            return nil
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
                assertionFailure("no Trackers")
                return [TrackerCategory(title: "", trackers: [])]
            }
            
            for tracker in allTrackers {
                guard let trackerID = tracker.id,
                      let trackerName = tracker.name,
                      let trackerColor = tracker.color,
                      let trackerEmoji = tracker.emoji,
                      let trackerSchedule = tracker.schedule
                else {
                    continue
            }
                let newSchedule = trackerSchedule.compactMap() {
                    WeekDay(rawValue: $0)
                }
                let newTracker = Tracker(
                    id: trackerID,
                    name: trackerName,
                    color: UIColorMarshalling.color(from: trackerColor) ?? UIColor(),
                    emoji: trackerEmoji,
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
    
    func deleteCategory(with title: String) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "title == %@", title)
        do {
            let object = try context.fetch(request)
            context.delete(object[0])
            delegate?.trackerCategoryUpdate(title: title)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        appDelegate.saveContext()
    }
    
    //метод для отображение пути к базе
    
    public func log() {
        if let url = appDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print(url)
        }
    }
}


