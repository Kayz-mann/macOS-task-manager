//
//  TaskRow.swift
//  taskmanager
//
//  Created by Balogun Kayode on 05/09/2025.
//

import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: CDTask
    @Binding var selectedTask: CDTask?
    @Binding var inspectorIsShown: Bool
    
    let showMoreButton: Bool
    
    init(task: CDTask, selectedTask: Binding<CDTask?>, inspectorIsShown: Binding<Bool>, showMoreButton: Bool = true) {
        self.task = task
        self._selectedTask = selectedTask
        self._inspectorIsShown = inspectorIsShown
        self.showMoreButton = showMoreButton
    }

    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle") // Placeholder; hook up completion later if needed
                .foregroundStyle(.secondary)

            TextField("Task title", text: $task.title)
                .textFieldStyle(.plain)

            Spacer()

            Text(task.dueDate, style: .date)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TaskRow(
        task: CDTask.example,
        selectedTask: .constant(nil),
        inspectorIsShown: .constant(false),
        showMoreButton: true
    )
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
