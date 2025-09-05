//
//  TaskGroupRow.swift
//  taskmanager
//
//  Created by Balogun Kayode on 05/09/2025.
//

import SwiftUI

struct TaskGroupRow: View {
    @ObservedObject var taskGroup: CDTaskGroup
    var body: some View {
        HStack {
            Image(systemName: "folder")
            TextField("New Group", text: $taskGroup.title)
        }
    }
}

#Preview {
    TaskGroupRow(taskGroup: CDTaskGroup.example)
}
