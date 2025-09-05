//
//  PersistenceController.swift
//  taskmanager
//
//  Created by Balogun Kayode on 02/09/2025.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared =  PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "TaskManager")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url =  URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores {description, error in
            if let error = error as NSError? {
                fatalError("Error loading container: \(error), \(error.userInfo)")
            }}
    }
    
//    MARK: - SwiftUI preview helper
    static var preview: PersistenceController =  {
        let controller =  PersistenceController(inMemory: true)
        let context =  controller.container.viewContext
        
        for index in 0..<10 {
            let task =  CDTask(title: "new task \(index)", dueDate: Date(), context: context)
        }
        return controller
    }()
}
