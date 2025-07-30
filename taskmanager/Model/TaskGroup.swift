//
//  TaskGroup.swift
//  taskmanager
//
//  Created by Balogun Kayode on 30/07/2025.
//

import Foundation


struct TaskGroup: Identifiable, Hashable {
    let id =  UUID()
    var title : String
    let creationDate: Date
    var tasks: [Task]
    
    init(title: String, creationDate: Date, tasks: [Task] = []) {
        self.title = title
        self.creationDate = Date()
        self.tasks = tasks
    }
    
    static func example() -> TaskGroup {
        let task1 =  Task(title: "Buy groceries")
        let task2 =  Task(title: "Pay bills")
        let task3 =  Task(title: "Exercise")
        
        var group =  TaskGroup(title: "Personal", creationDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!)
        group.tasks =  [task1, task2, task3]
        return group
        
        
    }
    
    static func examples() -> [TaskGroup] {
        let group1 =  TaskGroup.example()
        let group2 = TaskGroup(title: "New List", creationDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!)
        return [group1, group2]
    }
}
