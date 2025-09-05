//
//  TaskRow.swift
//  taskmanager
//
//  Created by Balogun Kayode on 02/09/2025.
//

import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: CDTask
    var body: some View {
    HStack {
            Image(systemName: task.isCompleted ? "large.circle.fill" : "circle")
            .onTapGesture {
                task.isCompleted.toggle()
            }
        TextField("New Task", text: $task.title)
            .textFieldStyle(.plain)
        
        Button(action: {
            
        }, label: {
            Text("More")
        })
        }
    }
}

#Preview {
    TaskRow(task: CDTask.example).padding()
}
