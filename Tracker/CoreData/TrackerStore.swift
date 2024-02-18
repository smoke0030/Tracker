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

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching results: \(error)")
        }

        return fetchedResultsController
    }()

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
        newTracker.schedule = tracker.schedule.compactMap {
            $0.rawValue
        }

        let fetchedCategory = TrackerCategoryStore.shared.fetchCategoryWithTitle(title: category.title)
        newTracker.category = fetchedCategory

        appDelegate.saveContext()
    }
    
    func deleteTracker(with name: String) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "name == %@", name)
        do {
            let object = try context.fetch(request)
            context.delete(object[0])
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        appDelegate.saveContext()
        
    }

    func fetchTrackers() {
        do {
            try fetchedResultsController.performFetch()
            fetchedResultsController.fetchedObjects?.forEach { tracker in
                let object = convertToTracker(coreDataTracker: tracker)
            }
        } catch {
            print("Error fetching results: \(error)")
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
