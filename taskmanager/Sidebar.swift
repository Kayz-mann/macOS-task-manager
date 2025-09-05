//
//  Sidebar.swift
//  taskmanager
//
//  Created by Balogun Kayode on 11/08/2025.
//

import SwiftUI
import CoreData

struct Sidebar: View {
    @FetchRequest(fetchRequest: CDTaskGroup.fetch(), animation: .bouncy)
    var taskGroups: FetchedResults<CDTaskGroup>

    
    @Binding var selection: TaskSection
    
    var body: some View {
        List(selection: $selection) {
            Section("Favorites") {
                ForEach(TaskSection.allCases) { section in
                    Label(section.displayName, systemImage: section.iconName)
                        .tag(section)
                }
            }
            
            Section("Your Groups") {
                       ForEach(taskGroups) { group in
                           TaskGroupRow(taskGroup: group)
                               .tag(TaskSection.list(group))
                               .contextMenu {
                                   Button("Delete", role: .destructive) {
                                       CDTaskGroup.delete(taskGroup: group)
                                   }
                               }
                       }
                   }
               }        .safeAreaInset(edge: .bottom) {
            Button(action: {
                let newGroup = CDTaskGroup(title: "New Group", context: PersistenceController.shared.container.viewContext)
                // Save the context after creating the new group
                try? PersistenceController.shared.container.viewContext.save()
            }) {
                Label("Add Group", systemImage: "plus.circle")
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.blue)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
        }
    }
}

#Preview {
    @Previewable @State var previewSelection = TaskSection.all
    
    return Sidebar(selection: $previewSelection)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
