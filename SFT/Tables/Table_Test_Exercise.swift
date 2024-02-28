//
//  Table_Test_Exercise.swift
//  SFT
//
//  Created by Kyle Parato on 2/25/24.
//

import SwiftUI

struct Table_Test_Exercise: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    
//    @FetchRequest(sortDescriptors:[NSSortDescriptor(\Exercises.)],predicate: NSPredicate(format: "name == %@", workout_name))
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercises.name, ascending: true)],
        animation: .default)
    private var exercises: FetchedResults<Exercises>
    
    @State var parent_workout: Workouts
    @State var workout_name: String
    
    // variables used to control popup menu
    @State private var showAlert = false
    @State private var exercise = ""
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(exercises){ exercise in
                    if(exercise.workout_name == workout_name){
                        NavigationLink(destination: Table_Test_Exercise_View( current_exercise_name: exercise.name!)){
                            Image(systemName: "dumbbell.fill")
                            Text(exercise.name!)
                            }   .padding(.vertical, 5)
                        
                        }
                    
                    }
                .onDelete(perform: delete)
                }
            .navigationTitle(workout_name)
            //Button for adding Exercises
            Button {
                showAlert = true
            }label: {
                Text("Add Exercise")
                    .font(.system(size: 18).weight(.bold))
                    .padding(.horizontal, 85)
                    .padding(.vertical,15)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(20)
            }
            .alert("Enter new exercise", isPresented: $showAlert, actions: {
                        TextField("Exercise", text: $exercise)

                Button("Add new exercise", action: {addExercise(exercise_name: exercise, exercise_type: 0, workout_name: workout_name)})
                Button("Cancel", role: .cancel, action: {})
                    }, message: {
            })
        }
        .toolbar{
            #if os(iOS)
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: search_exercises){
                    Label("Search", systemImage: "magnifyingglass")
                }
            }
            #endif
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: hamburger_menu){
                    Label("Menu", systemImage: "sidebar.right")
                }
            }
        }
    }
    // function for ceating exercise in data base
    private func addExercise(exercise_name: String, exercise_type: Int16, workout_name: String){
        withAnimation{
            let newExercise = Exercises(context: viewContext)
            newExercise.name = exercise_name
            newExercise.type = exercise_type
            newExercise.workout_name = workout_name
            exercise = ""
            do{
                try viewContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func delete(indexSet:IndexSet){
        indexSet.map { exercises[$0]}.forEach(viewContext.delete)
        do{
            try viewContext.save()
        }catch{
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    private func search_exercises(){
        
    }
    private func hamburger_menu(){
        
    }
}

//#Preview {
//    Table_Test_Exercise()
//}
