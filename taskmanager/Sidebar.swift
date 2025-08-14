//
//  Sidebar.swift
//  taskmanager
//
//  Created by Balogun Kayode on 11/08/2025.
//

import SwiftUI

struct Sidebar: View {
    @Binding var userCreatedGroups: [TaskGroup]
    @Binding var selection:  TaskSection
    var body: some View {
        List(selection: $selection){
            Section("Favorites") {
                ForEach(TaskSection.allCases) {section in
                    Label(section.displayName, systemImage: section.iconName).tag(selection)}
            }
            
            Section("Your Groups") {
                ForEach($userCreatedGroups) {
                    $group in
                    HStack{
                        Image(systemName: "folder")
                        TextField("New Group", text: $group.title)
                    }
                    .tag(TaskSection.list((group))
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                if let index =  userCreatedGroups.firstIndex(where: {$0.id == group.id}) {
                                    userCreatedGroups.remove(at: index)
                                }
                            }
                        }
                    )
                }
            }
        } .safeAreaInset(edge: .bottom) {
            Button(action: {
                let newGroup =  TaskGroup(title: "New Group")
                userCreatedGroups.append(newGroup)
            }, label: {
                Label("Add Group", systemImage: "plus.circle")
            })
            .buttonStyle(.borderless)
            .foregroundStyle(.blue)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
        }   }
}

#Preview {
    @Previewable @State var previewSelection = TaskSection.all
        @Previewable @State var previewGroups = TaskGroup.examples()
        return Sidebar(userCreatedGroups: $previewGroups, selection: $previewSelection)}
