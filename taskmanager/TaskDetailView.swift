//
//  TaskDetailView.swift
//  taskmanager
//
//  Created by Balogun Kayode on 21/09/2025.
//

import SwiftUI

struct TaskDetailView: View {
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var task: CDTask
    
    var body: some View {
        List {
            Text(task.title)
                .font(.title3)
                .bold()
            
            Toggle(task.isCompleted ? "Completed" : "Open",
                   isOn: Binding(
                    get: { task.isCompleted },
                    set: { newValue in
                        task.isCompleted = newValue
                        try? task.managedObjectContext?.save()
                    }
                   )
            )
            
            DatePicker("Due Date",
                       selection: Binding(
                        get: { task.dueDate },
                        set: { newDate in
                            task.dueDate = newDate
                            try? task.managedObjectContext?.save()
                        }
                       ),
                       displayedComponents: [.date]
            )
            
            Divider()
            
            Section("Sub Tasks") {
                ForEach(Array(task.subTasksSet).sorted()) { subtask in
                    TaskRow(task: subtask,
                            selectedTask: .constant(nil),
                            inspectorIsShown: .constant(false),
                            showMoreButton: false)
                    .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 10))
                }
                
                Button(action: {
                    let subTask = CDTask(title: "", dueDate: Date(), context: context)
                    // Add to the to-many relationship via the Set bridge
                    var set = task.subTasksSet
                    set.insert(subTask)
                    task.subTasksSet = set
                    try? context.save()
                }, label: {
                    Label("New Sub Task", systemImage: "plus.circle")
                })
                .buttonStyle(.borderless)
                .tint(.accentColor)
                .listRowInsets(.init(top: 15, leading: 20, bottom: 5, trailing: 10))
            }
        }
        .listStyle(.sidebar)
    }
}   

#Preview {
    TaskDetailView(task: CDTask.example)
}
