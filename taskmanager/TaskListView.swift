//
//  TaskListView.swift
//  taskmanager
//
//  Created by Balogun Kayode on 11/08/2025.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    let title: String
    @FetchRequest(fetchRequest: CDTask.fetch(), animation: .bouncy) var tasks
    @State private var inspectorIsShown: Bool = false
    @State private var selectedTask: CDTask? = nil
    @Environment(\.managedObjectContext) var context
    
    // Keep the currently selected group (if any)
    private let selectedGroup: CDTaskGroup?
    
    init(title: String, selection: TaskSection?, searchTerm: String? ) {
        self.title = title
        
        var request = CDTask.fetch()
        if searchTerm!.isEmpty {
            switch selection {
            case .all:
                request.predicate = nil
            case .done:
                request.predicate = NSPredicate(format: "isCompleted == true")
            case .upcoming:
                request.predicate = NSPredicate(format: "isCompleted == false")
            case .list(let group):
                // Compare against the relationship object
                request.predicate = NSPredicate(format: "group == %@", group)
            case nil:
                request.predicate = nil
            }

            
        } else {
            request.predicate = NSPredicate(format: "%K CONTAINS[cd] %@",
                                            "title_", searchTerm! as CVarArg)
        }
    
        
        switch selection {
        case .all, .done, .upcoming:
            self.selectedGroup = nil
        case .list(let group):
            self.selectedGroup = group
        case nil:
            self.selectedGroup = nil
        }
        
        self._tasks = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        List(tasks) { task in
            TaskRow(task: task, selectedTask: $selectedTask, inspectorIsShown: $inspectorIsShown)
                .foregroundColor(selectedTask == task ? .accentColor : .gray)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedTask = task
                }
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    let task =  CDTask(title: "New", dueDate: Date(), context: context)
                    task.group = selectedGroup
                    PersistenceController.shared.save()
                } label: {
                    Label("Add New Task", systemImage: "plus")
                }
                
                Button {
                    inspectorIsShown.toggle()
                } label: {
                    Label("Add inspector", systemImage: "sidebar.right")
                }
            }
        }
        .inspector(isPresented: $inspectorIsShown) {
            if let selectedTask {
TaskDetailView(task: selectedTask)
            } else {
              ContentUnavailableView("Please select a task", systemImage: "circle.inset.filled")
            }
        }
        .frame(minWidth: 100, maxWidth: .infinity)
    }
}

#Preview {
    TaskListView(title: "All", selection: .list(CDTaskGroup.example), searchTerm: "")
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
