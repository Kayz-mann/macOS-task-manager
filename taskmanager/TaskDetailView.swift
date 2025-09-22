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
                   isOn: $task.isCompleted)
            
            DatePicker("Due Date", selection: $task.dueDate, displayedComponents: [.date])
            
            Divider()
            
            Section("Sub Tasks") {
                ForEach(task.subTasksSet.sorted(by: <), id: \.uuid) { subtask in
                    TaskRow(task: subtask,
                            selectedTask: .constant(nil),
                            inspectorIsShown: .constant(false),
                            showMoreButton: false)
                    .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 10))
                }
                
                Button(action: {
                    let subTask = CDTask(title: "", dueDate: Date(), context: context)
                    // Add to the parent's subTasksSet
                    var current = task.subTasksSet
                    current.insert(subTask)
                    task.subTasksSet = current
                    // If you also have a to-one parent relationship, set it here:
                    // subTask.parentTask = task
                    
                    try? context.save()
                }, label: {
                    Label("New Sub Task", systemImage: "plus.circle")
                })
                .buttonStyle(.borderless)
                .foregroundColor(.highlight)
                .listRowInsets(.init(top: 15, leading: 20, bottom: 5, trailing: 10))
            }
        }
        .listStyle(.sidebar)
    }
}

#Preview {
    TaskDetailView(task: CDTask.example)
}

