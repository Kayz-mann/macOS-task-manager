//
//  ContentView.swift
//  taskmanager
//
//  Created by Balogun Kayode on 30/07/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selection =  TaskSection.all
    @State private var userCreatedGroups: [TaskGroup] = TaskGroup.examples()
    @State private var allTasks =  Task.examples()
    @State private var searchTerm: String = ""
    
    var body: some View {
           NavigationSplitView {
               Sidebar(userCreatedGroups: $userCreatedGroups, selection: $selection)
                   .navigationTitle("Your Tasks")
           } detail: {
               if searchTerm.isEmpty {
                   switch selection {
                   case .all:
                       TaskListView(title: "All", tasks: $allTasks)
                   case .done:
                       ArchiveTaskListView(title: "Done", tasks: allTasks.filter { $0.isCompleted })
                   case .upcoming:
                       ArchiveTaskListView(title: "Upcoming", tasks: allTasks.filter { !$0.isCompleted })
                   case .list(let taskGroup):
//                       ArchiveTaskListView(title: taskGroup.title, tasks: taskGroup.tasks)
                       Text("placeholder")
                   }
               } else {
                   ArchiveTaskListView(title: "Search Results", tasks: allTasks.filter { $0.title.contains(searchTerm) })
               }
           }
           .searchable(text: $searchTerm)
       }}


#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}


