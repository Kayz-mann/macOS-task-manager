//
//  TaskListView.swift
//  taskmanager
//
//  Created by Balogun Kayode on 11/08/2025.
//

import SwiftUI

struct TaskListView: View {
    let title: String
    @Binding var tasks: [Task]
    @State private var inspectorIsShown: Bool = false
    @State private var selectedTask: Task? = nil
    
    var body: some View {
        List($tasks) { $task in
            TaskView(task: $task, selectedTask: $selectedTask, inspectorIsShown: $inspectorIsShown)
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    tasks.append(Task(title: "New Task"))
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
                Text(selectedTask.title).font(.title)
            }    else {
                Text("nothing selected")
                
            }
        }.frame(minWidth: 100, maxWidth: .infinity)
        
      
        
    }
}

#Preview {
    TaskListView(title: "All", tasks: .constant(Task.examples()))
}
