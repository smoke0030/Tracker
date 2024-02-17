
import UIKit
import CoreData


protocol TrackerStoreDelegate: AnyObject {
    func didUpdate() -> Void
}

final class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    
    let colorMarshalling = UIColorMarshalling()
    weak var delegate: TrackerStoreDelegate?
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    
    func convertToTracker(coreDataTracker: TrackerCoreData) -> Tracker {
        let id = coreDataTracker.id!
        let name = coreDataTracker.name!
        let color = colorMarshalling.color(from: coreDataTracker.color!)!
        let emoji = coreDataTracker.emoji!
        let schedule = coreDataTracker.schedule!
        let scheduleString = schedule.compactMap {
            WeekDay(rawValue: $0)
        }
        let tracker = Tracker(id: id, name: name, color: color, emoji: emoji, schedule: scheduleString)
        return tracker
    }
    
    func addTracker(tracker: Tracker, category: TrackerCategory) {
        let newTracker = TrackerCoreData(context: context)
        
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.color = colorMarshalling.hexString(from: tracker.color)
        newTracker.schedule = tracker.schedule.compactMap{
            $0.rawValue
        }
        
        let fetchedCategory = TrackerCategoryStore.shared.fetchCategoryWithTitle(title: category.title)
        newTracker.category = fetchedCategory
        
        appDelegate.saveContext()
        
    }
    
    func fetchTrackers() {
        let request = TrackerCoreData.fetchRequest()
        do {
            let trackers = try context.fetch(request)
            trackers.forEach { tracker in
               let object = convertToTracker(coreDataTracker: tracker)
                print(object)
            }
        } catch {
            print("error")
        }
    }
    
    public func log() {
        if let url = appDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print(url)
        }
    }
    
    
    
    
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}

