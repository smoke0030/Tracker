//
//  TrackerRecordCoreData+CoreDataProperties.swift
//  Tracker
//
//  Created by Сергей on 14.02.2024.
//
//

import Foundation
import CoreData

@objc(TrackerRecordCoreData)
public class TrackerRecordCoreData: NSManagedObject {

}

extension TrackerRecordCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        return NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID

}

extension TrackerRecordCoreData : Identifiable {

}
