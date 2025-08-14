//
//  TaskView.swift
//  taskmanager
//
//  Created by Balogun Kayode on 14/08/2025.
//

import SwiftUI

struct TaskView: View {
    @Binding var task: Task
    @Binding  var selectedTask: Task?
    @Binding var inspectorIsShown: Bool
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "largecircle.fill.circle": "circle")
                .onTapGesture {
                    task.isCompleted.toggle()
                }
            
            TextField("New Task", text: $task.title)
                .textFieldStyle(.plain)
            
            Button (action: {
                inspectorIsShown =  true
                selectedTask =  task
            }, label: {
                Text("More")
            })
        }
    }
}

#Preview {
    TaskView(task: .constant(Task.example()), selectedTask: .constant(Task.example()), inspectorIsShown: .constant(false))
}
