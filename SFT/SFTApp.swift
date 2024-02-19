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
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            test_homescreen()
        }
    }
}
