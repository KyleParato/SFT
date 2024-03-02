//
//  Table_Tests.swift
//  SFT
//
//  Created by Kyle Parato on 2/25/24.
//

import SwiftUI

struct Table_Tests: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch all workouts and store in workouts var
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workouts.name, ascending: true)],
        animation: .default)
    private var workouts: FetchedResults<Workouts>
    
    // variables used to control popup menu
    @State private var showAlert = false
    @State private var workout = ""
    
    // Workout View
    var body: some View {
        NavigationStack {
            ZStack {
                VStack{
                    //List view for workouts
                   NavigationView {
                        List {
                            // Display all workouts
                            ForEach(workouts){ workout in
                                // Navigate to exercise page, must pass workout name as string
                                NavigationLink(destination: Table_Test_Exercise(workout_name: workout.name!)){
                                    Image(systemName: "scalemass")
                                    Text(workout.name!)
                                }.padding(.vertical, 5)
                            }
                            .onDelete(perform: delete)
                        }
                    }
                    .navigationTitle("Workouts")
                    
                    //Button for adding workouts
                    Button {
                        showAlert = true
                    }label: {
                        Text("Add Workout")
                            .font(.system(size: 18).weight(.bold))
                            .padding(.horizontal, 85)
                            .padding(.vertical,15)
                            .foregroundColor(.white)
                            .background(.black)
                            .cornerRadius(20)
                    }
                    .alert("Enter new workout", isPresented: $showAlert, actions: {
                                TextField("Workout", text: $workout)

                        Button("Add new workout", action: {addWorkout(workout_name: workout)})
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
        }
}
    // function for ceating workout in data base
    private func addWorkout(workout_name: String){
        withAnimation{
            // Store new workout
            let newWorkout = Workouts(context: viewContext)
            newWorkout.name = workout_name
            // Reset popup text box
            workout = ""
            // Save workout to db
            do{
                try viewContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //func for deleting list items
    func delete(indexSet: IndexSet){
        indexSet.map { workouts[$0]}.forEach(viewContext.delete)
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
