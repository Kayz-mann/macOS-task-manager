//
//  CDTask+helper.swift
//  taskmanager
//
//  Created by Balogun Kayode on 02/09/2025.
//

// This pattern is common in Core Data apps where the generated NSManagedObject properties are optional (marked with _),
// but you want to work with non-optional values in your app logic. The extension acts as a bridge, providing cleaner,
// safer access to the underlying Core Data properties

import Foundation
import CoreData

extension CDTask {
    
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
    
    var dueDate: Date {
        get { dueDate_ ?? Date() }
        set { dueDate_ = newValue }
    }
    
    // NOTE:
    // Remove the computed bridge for isCompleted because the model already
    // exposes `@NSManaged public var isCompleted: Bool` (no underscore).
    // Keeping a computed property named `isCompleted` causes a redeclaration error.
    // Also, `isCompleted_` does not exist in the generated class, which caused
    // the "Cannot find 'isCompleted_' in scope" error.
    
    // If your model defines a to-one relationship named "subTask" (generated as subTask_ : CDTask?),
    // expose it as an optional CDTask here.
    // If your model does NOT have this to-one, you can remove this property.
    var subTask: CDTask? {
        get { subTask_ }
        set { subTask_ = newValue }
    }
    
    // If your model defines a to-many relationship named "subTasks" (generated as NSSet?),
    // bridge it to a Swift Set via KVC to avoid symbol overlap and type mismatch.
    // Update the key "subTasks" to match your actual relationship name in the .xcdatamodeld.
    var subTasksSet: Set<CDTask> {
        get {
            (self.value(forKey: "subTasks") as? NSSet)?
                .compactMap { $0 as? CDTask }
                .reduce(into: Set<CDTask>()) { $0.insert($1) } ?? []
        }
        set {
            self.setValue(NSSet(set: newValue), forKey: "subTasks")
        }
    }
    
    convenience init(title: String, dueDate: Date, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.dueDate = dueDate
        // Provide sensible defaults on creation
        // Use the generated `isCompleted` property directly.
        self.isCompleted = false
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.uuid_ = UUID()
    }
    
    static func delete(task: CDTask) {
        guard let context = task.managedObjectContext else { return }
        context.delete(task)
    }
    
    static func fetch(_ predicate: NSPredicate = .all) -> NSFetchRequest<CDTask> {
        let request = CDTask.fetchRequest()
        // Sort on the stored attributes, not computed properties
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CDTask.dueDate_, ascending: true),
            NSSortDescriptor(keyPath: \CDTask.title_, ascending: true)
        ]
        request.predicate = predicate
        return request
    }
    
    //    MARK: - SwiftUI preview helper
    static var example: CDTask {
        let context  = PersistenceController.preview.container.viewContext
        let task = CDTask(title: "Example Task", dueDate: Date(), context: context)
        let sub1 =  CDTask(title: "Sub Task 1", dueDate: Date(), context: context)
        let sub2 =  CDTask(title: "Sub Task 2", dueDate: Date(), context: context)
        let sub3 =  CDTask(title: "Sub Task 3", dueDate: Date(), context: context)
        
        task.subTasksSet.formUnion([sub1, sub2, sub3])

        return task
    }
    

}

extension CDTask: Comparable {
    public static func < (lhs: CDTask, rhs: CDTask) -> Bool {
        lhs.title < rhs.title_ ?? ""
    }
}
