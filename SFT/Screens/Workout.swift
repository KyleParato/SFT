//
//  Table_Tests.swift
//  SFT
//
//  Created by Kyle Parato on 2/25/24.
//

import SwiftUI

struct Workout: View {
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
    @State private var searchItem = ""
    
    
    // Workout View
    var body: some View {
        // Stores names of workouts for search function
        let workout_name_list = generate_workout_list(workouts:workouts)
        
        NavigationStack {
            ZStack {
                VStack{
                    //List view for workouts
                   NavigationView {
                        List {
                            // Displays filtered workout names
                            ForEach(filteredSearch, id: \.self){ workout in
                                // Navigate to exercise page, must pass workout name as string
                                NavigationLink(destination: Exercise_List(workout_name: workout)){
                                    Image(systemName: "scalemass")
                                    Text(workout)
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
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: hamburger_menu){
                            Label("Menu", systemImage: "sidebar.right")
                        }
                    }
                }
            }
        }
        // creates search bar at top of screen
        .searchable(text: $searchItem, placement: .navigationBarDrawer, prompt: "Search Workouts")
        
        // filters through workout names
        var filteredSearch: [String] {
            if searchItem.isEmpty {
                //returns original array if search is empty
                return workout_name_list
            } else {
                return workout_name_list.filter { $0.localizedCaseInsensitiveContains(searchItem)}
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
    
    // gathers all names and stores them into an array
    func generate_workout_list(workouts : FetchedResults<Workouts>) -> [String]{
        var returnarr :[String] = []
        for workout in workouts{
            returnarr.append(workout.name!)
        }
        return returnarr
    }
    
    private func hamburger_menu(){
        
    }
}

