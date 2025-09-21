//
//  CDTaskGroup+helper.swift
//  taskmanager
//
//  Created by Balogun Kayode on 02/09/2025.
//

import Foundation
import CoreData

extension CDTaskGroup {
    var uuid: UUID {
        #if DEBUG
        uuid_!
        #else
        uuid_ ?? UUID()
        #endif
    }
    
    var title: String {
        get { title_ ?? "" }
        set { title_ = newValue }
    }
    
    var creationDate: Date {
        creationDate_ ?? Date()
    }
    
    // Non-conflicting accessor bridging the Core Data relationship "tasks" to a Swift Set.
    // Uses KVC to avoid symbol overlap with the generated relationship property.
    var tasksSet: Set<CDTask> {
        get {
            (self.value(forKey: "tasks") as? NSSet)?
                .compactMap { $0 as? CDTask }
                .reduce(into: Set<CDTask>()) { $0.insert($1) } ?? []
        }
        set {
            // Bridge Set<CDTask> back to NSSet and assign via KVC to the "tasks" relationship
            self.setValue(NSSet(set: newValue), forKey: "tasks")
        }
    }
    
    // Optional alias if you prefer this name elsewhere in your code.
    var taskCD: Set<CDTask> { tasksSet }
    
    convenience init(title: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.uuid_ = UUID()
        self.creationDate_ = Date()
    }
    
    static func delete(taskGroup: CDTaskGroup) {
        guard let context = taskGroup.managedObjectContext else { return }
        context.delete(taskGroup)
    }
    
    static func fetch(_ predicate: NSPredicate = .all) -> NSFetchRequest<CDTaskGroup> {
        let request = CDTaskGroup.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CDTaskGroup.title_, ascending: true),
            NSSortDescriptor(keyPath: \CDTaskGroup.creationDate_, ascending: true)
        ]
        request.predicate = predicate
        return request
    }

    // MARK: - SwiftUI preview helper
    static var example: CDTaskGroup {
        let context  = PersistenceController.preview.container.viewContext
        let taskGroup = CDTaskGroup(title: "Groceries", context: context)
        // Use the Swift Set bridge to mutate the relationship
        var set = taskGroup.tasksSet
        set.insert(CDTask.example)
        taskGroup.tasksSet = set
        return taskGroup
    }
}
