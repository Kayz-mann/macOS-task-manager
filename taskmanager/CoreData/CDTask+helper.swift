//
//  CDTask+helper.swift
//  taskmanager
//
//  Created by Balogun Kayode on 02/09/2025.
//

//This pattern is common in Core Data apps where the generated NSManagedObject properties are optional (marked with _), but you want to work with non-optional values in your app logic. The extension acts as a bridge, providing cleaner, safer access to the underlying Core Data properties

import Foundation
import CoreData

extension CDTask {
    
    var uuid: UUID {
        #if DEBUG
        uuid_!
        #else
        uuide_ ?? UUID()
        #endif
    }
    var title: String {
        get {title_ ?? ""}
        set {title_ = newValue }
    }
    
    var dueDate: Date {
        get {dueDate_ ?? Date()}
        set{ dueDate_ = newValue}
    }
    
    convenience init(title: String, dueDate: Date, context:NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.dueDate = dueDate
    }
    
    public override func awakeFromInsert() {
        self.uuid_ = UUID()
    }
    
    static func delete(task: CDTask) {
        guard let context =  task.managedObjectContext else {return}
        
        context.delete(task)
    }
    
    static func fetch(_ predicate: NSPredicate =  .all) -> NSFetchRequest<CDTask> {
        let request =  CDTask.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDTask.dueDate_, ascending: true ), NSSortDescriptor(keyPath: \CDTask.title, ascending: true)]
        
        request.predicate = predicate
        
        return request
    }
    
    //    MARK: - SwiftUI preview helper
    static var example: CDTask {
        let context  =  PersistenceController.preview.container.viewContext
        let task =  CDTask(title: "Example Task", dueDate: Date(), context: context)
        
        return task
    }

}
