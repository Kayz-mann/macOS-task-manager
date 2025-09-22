//
//  TaskListView.swift
//  taskmanager
//
//  Created by Balogun Kayode on 11/08/2025.
//

import SwiftUI

struct ArchiveTaskListView: View {
    let title: String
    let tasks: [Task]
    var body: some View {
        List(tasks) { task in
            HStack {
                Image(systemName: task.isCompleted ? "largecircle.fill.circle" : "circle")
                Text(task.title)
            }
        }
    }
}

#Preview {
    ArchiveTaskListView(title: "All", tasks: Task.examples())
}
