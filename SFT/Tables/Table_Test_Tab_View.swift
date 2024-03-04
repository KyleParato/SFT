//
//  Table_Test_Tab_View.swift
//  SFT
//
//  Created by Kyle Parato on 3/4/24.
//

import SwiftUI

struct Table_Test_Tab_View: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch all exercises and store to exercises
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercises.name, ascending: true)],
        animation: .default)
    private var exercises: FetchedResults<Exercises>
    
    @State var workout_name : String
    @State var current_exercise_name: String
    
    var body: some View {
        VStack{
            // Tab view
            TabView(selection: $current_exercise_name){
                // Generate views
                ForEach(exercises){ exercise in
                    if(exercise.workout_name == workout_name){
                        Table_Test_Exercise_View(current_exercise_name: exercise.name!).tag(exercise.name!)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .never))
        }
    }
}
