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
    var body: some View {
        NavigationSplitView{
            Sidebar(userCreatedGroups: $userCreatedGroups, selection: $selection, )
        }detail: {
            switch selection {
            case .all:
                TaskListView(title: "All", tasks: allTasks)
            case.done:
                TaskListView(title: "All", tasks: allTasks.filter({ $0.isCompleted}))

            case.upcoming:
                TaskListView(title: "All", tasks: allTasks.filter({ !$0.isCompleted}))

                
            case .list(let taskGroup):
                TaskListView(title: taskGroup.title, tasks: taskGroup.tasks)
            }
        }
    }
}

#Preview {
    ContentView()
}
