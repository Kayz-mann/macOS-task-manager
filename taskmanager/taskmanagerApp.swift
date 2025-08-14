//
//  taskmanagerApp.swift
//  taskmanager
//
//  Created by Balogun Kayode on 30/07/2025.
//

import SwiftUI

@main
struct taskmanagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandMenu("Task"){
                Button("Add new Task"){
                    
                }
                .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
            }
            
            CommandGroup(after: .newItem){
                Button("Add new Group"){
                    
                }
            }
            
        }
        
        WindowGroup("Special window") {
            Text("special window")
                .frame(minWidth: 200, idealWidth: 300, minHeight: 200)
        }
        .defaultPosition(.leading)
        
        
        Settings {
            Text("Setting")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        MenuBarExtra("Menu") {
            Button("Do something amazing") {
                
            }
        }
        
        
        

    }
}
