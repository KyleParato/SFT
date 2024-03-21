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
- Rename files, go to file go to the struct at the top right click, click refractor, and rename
should rename every instance of it evne in other files
- Work on search function, figure out how to implement search
- Work on sidebar menu
    - settings
        - clear all data
    - change weight metric
    - type of graph
    - themes (dark/light mode)
- Add cascade deleting

*/


