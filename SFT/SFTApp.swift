//
//  SFTApp.swift
//  SFT
//
//  Created by Kyle Parato on 2/15/24.
//

import SwiftUI

@main
struct SFTApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            // Old demo view
//            HomeScreen()
            
            // Current App screens
            Workout().environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}


/*
 
TO-DO

- Work on add new entry button, should have text field that takes in double for weight and int for
inputs, pass it through to the add entry function
- Update searchbar with a custom search bar
- settings
    - clear all data
    - change weight metric
    - type of graph
    - Color accurate text for dark mode
- Add different workouts
- Add cascade deleting
- Add custom swipe action on Exercise List - Ask Kyle

*/


