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
    @State private var showingWorkoutSheet = false
    @State private var workout = ""
    @State private var searchItem = ""
    @State private var showSettings = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    // variables for alerts
    @State private var showAlert = false
    @State var alertTitle = ""
    
    var color_Text: Color {
        if isDarkMode == true { return .white
        } else { return .black
        }
    }
        
    
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
                            NavigationLink(destination: Exercise_List(workout_name: "All Exercises")){
                                Image(systemName: "magnifyingglass.circle.fill")
                                Text("All Exercises")
                            }
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
                        showingWorkoutSheet = true
                    }label: {
                        Text("Add Workout")
                            .font(.system(size: 18).weight(.bold))
                            .padding(.horizontal, 85)
                            .padding(.vertical,15)
                            .foregroundColor(.white)
                            .background(.black)
                            .cornerRadius(20)
                    }
                    
                    //sheet popup for adding workout
                    .sheet(isPresented: $showingWorkoutSheet, content: {
                        VStack(content: {
                            
                            Text("Add New Workout")
                                .font(.system(size: 20).weight(.bold))
                                .padding()

                            TextField("Workout", text: $workout)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 75)
                                  
                            Button{
                                if (workout == "") {
                                    alertTitle = "You did not enter a name"
                                    showAlert.toggle()
                                } else {
                                    addWorkout(workout_name: workout)
                                    showingWorkoutSheet.toggle()
                                    workout = ""
                                }

                            } label: {
                                Text("Add New Workout")
                                .padding(.horizontal, 58)
                                .padding(.vertical, 15)
                                .foregroundColor(.white)
                                .background(.black, in: RoundedRectangle(cornerRadius: 10))
                            }
                        
                            Button{
                                showingWorkoutSheet.toggle()
                                workout = ""

                            } label: {
                                Text("Cancel")
                                    .padding(.horizontal, 100)
                                    .padding(.vertical, 15)
                                    .foregroundColor(.white)
                                    .background(.red, in: RoundedRectangle(cornerRadius: 10))
                            }
                            .alert(isPresented: $showAlert, content: {
                                getAlert()
                            })
                            
                            .frame(alignment: .bottom)
                            
                        })
                        .presentationDetents([.fraction(0.40)])
                    })
                    
                }
                
                
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: Settings_button){
                            Label("Settings", systemImage: "gearshape.fill")
                                .foregroundStyle(self.color_Text, .black)
                                .font(.system(size: 42.0))
                                
                                .sheet(isPresented: $showSettings) {
                                    Settings_view()
                                        .presentationDragIndicator(.visible)
                                    Button{
                                        showSettings = false
                                    } label: {
                                        Text("Done")
                                            .padding(.horizontal, 100)
                                            .padding(.vertical, 15)
                                            .foregroundColor(.white)
                                            .background(.red, in: RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            
                        }
                    }
                }
                
                
                
                
            }
        }
        // creates search bar at top of screen
        .searchable(text: $searchItem, placement: .navigationBarDrawer, prompt: "Search Workouts")
        .preferredColorScheme(isDarkMode ? .dark : .light)
        
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
        for workout in workouts {
            if workout_name == workout.name!{
                return
            }
        }
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
    
    private func Settings_button() {
        showSettings = true
        
    }
    
    func getAlert() -> Alert {
        return Alert(
            title: Text(alertTitle),
            dismissButton: .default(Text("Ok, got it!"))
        )
    }
}
