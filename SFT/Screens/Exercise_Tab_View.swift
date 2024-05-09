//
//  Table_Test_Tab_View.swift
//  SFT
//
//  Created by Kyle Parato on 3/4/24.
//

import SwiftUI

// holds single exercise view in a tab format, allows swipping
struct Exercise_Tab_View: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch all exercises and store to exercises
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercises.name, ascending: true)],
        animation: .default)
    private var exercises: FetchedResults<Exercises>
    
    // control vars
    @State var workout_name : String
    @State var current_exercise_name: String
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    // controls text color
    var color_Text: Color {
        if isDarkMode == true { return .white
        } else { return .black
        }
    }
    
    var body: some View {
        VStack{
            // Tab view
            TabView(selection: $current_exercise_name){
                // Generate views with name as tag
                ForEach(exercises){ exercise in
                    if(exercise.workout_name == workout_name){
                        if(exercise.type == 0){
                            Single_Exercise_View_Static(current_exercise_name: exercise.name!).tag(exercise.name!)
                        }
                        if(exercise.type == 1){
                            Single_Exercise_View_Time(current_exercise_name: exercise.name!).tag(exercise.name!)
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .never))
        }
    }
}
