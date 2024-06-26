//
//  Table_Test_Exercise.swift
//  SFT
//
//  Created by Kyle Parato on 2/25/24.
//

import SwiftUI

// main view of a workout's exercises
struct Exercise_List: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch all exercises and store to exercises
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercises.name, ascending: true)],
        animation: .default)
    private var exercises: FetchedResults<Exercises>
    
    // parent workout name
    @State var workout_name: String
    
    // variables used to control popup menu
    @State private var exercise = ""
    @State private var searchItem = ""
    @State private var showSettings = false
    
    // variables for showing bottom sheets
    @State private var showingExerciseSheet = false
    @State private var isSelected = false
    @State private var isSelected2 = false
    
    //variables for showing alerts
    @State private var showAlert = false
    @State private var conflictAlert = false //var for exercise name conflict alert
    @State var alertTitle = ""
    
    @State private var exerciseType: Int16 = 0
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    // variables to control text color
    var color_Text: Color {
        if isDarkMode == true { return .white
        } else { return .black
        }
    }
    var color_Text2: Color {
        if isDarkMode == true { return .black
        } else { return .white
        }
    }
    
    // dark mode controller
    private var background_color: Color {
        if isDarkMode == true { return .gray
        } else { return .black
        }
    }

    // Exercise View
    var body: some View {
        
        //Stores names of exercises and their workout name
        let exercise_name_list = generate_exercise_list(exercises:exercises)

        // Keeps all views in root stack
        NavigationStack{
            ZStack{
                VStack{
                    NavigationView{
                        List{
                            // Display all workouts with parent workout name equal to
                            // the workout name passed into the view
                            ForEach(filteredSearch, id: \.name){ exercise in
                                if(exercise.workout_name == workout_name){
                                    // Navigate to tab view of exercises, tag is
                                    // current_exercise_name
                                    NavigationLink(destination: Exercise_Tab_View(workout_name: workout_name, current_exercise_name: exercise.name)){
                                        if(exercise.type==1){
                                            Image(systemName: "stopwatch.fill")
                                        }
                                        if(exercise.type==0){
                                            Image(systemName: "dumbbell.fill")
                                        }
                                        Text(exercise.name)
                                    }   .padding(.vertical, 5)
                                }
                                    
                            }
                            .onDelete(perform: delete)
                        }
                    }
                    .navigationTitle(workout_name)
                    
                    //Button for adding Exercises
                    Button {
                        showingExerciseSheet.toggle()
                    }label: {
                        Text("Add Exercise")
                            .font(.system(size: 18).weight(.bold))
                            .padding(.horizontal, 85)
                            .padding(.vertical,15)
                            .foregroundColor(color_Text2)
                            .background(background_color)
                            .cornerRadius(20)
                    }
                    //sheet popup for selecting workout type and adding new exercise
                    .sheet(isPresented:$showingExerciseSheet, content: {Exercise_form(workout_name: workout_name).presentationDetents([.medium])})
                }
            }
            // toolbar to hold settings button
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: Settings_button){
                        Label("Settings", systemImage: "gearshape.fill")
                            .foregroundStyle(self.color_Text, .black)
                            .font(.system(size: 42.0))
                            
                            .sheet(isPresented: $showSettings) {
                                Settings_view()
                                    .presentationDragIndicator(.visible)
                                Button("Cancel"){
                                    showSettings = false
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .foregroundColor(.white)
                                .background(.red, in: RoundedRectangle(cornerRadius: 10))
                            }
                    }
                }
            }
        }
        // searchbar
        .searchable(text: $searchItem, placement: .navigationBarDrawer, prompt: "Search Exercises")
        // filters through workout names, used in list and searchbar
        var filteredSearch: [exercise_filter] {
            if searchItem.isEmpty {
                //returns original array if search is empty
                return exercise_name_list
            } else {
                return exercise_name_list.filter { $0.name.localizedCaseInsensitiveContains(searchItem)}
            }
        }
    }
       
    // delete item from lsit
    func delete(indexSet:IndexSet){
        indexSet.map { exercises[$0]}.forEach(viewContext.delete)
        do{
            try viewContext.save()
        }catch{
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    //func that appends names of exercises into array for searching
    func generate_exercise_list(exercises : FetchedResults<Exercises>) -> [exercise_filter]{
        var returnarr : [exercise_filter] = []
        for exercise in exercises{
            if exercise.workout_name == workout_name{
                returnarr.append(exercise_filter(name:exercise.name!,workout_name: exercise.workout_name!,type:exercise.type))
            }
        }
        return returnarr
    }
    
    // created for search bar, name is hashed for easy search
    struct exercise_filter{
        var name : String
        var workout_name: String
        var type : Int16
        
        var hashVale: Int{
            return name.hashValue
        }
    }
    // settings button controler
    private func Settings_button() {
        showSettings = true
        
    }
    
    //function for showing alerts
    func getAlert() -> Alert {
        return Alert(
            title: Text(alertTitle),
            dismissButton: .default(Text("Ok, got it!"))
        )
    }
}

// button structure
struct SelectButton: View {
    @Binding var isSelected: Bool
    @State var color: Color
    @State var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 135, height: 40)
                .foregroundColor(isSelected ? color : .black)
            Text(text)
                .foregroundColor(.white)
        }
    }
    
}

// used to gather user input for creating new exercises
struct Exercise_form : View{
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Fetch all exercises and store to exercises
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercises.name, ascending: true)],
        animation: .default)
    private var exercises: FetchedResults<Exercises>
    
    // parent workout name
    @State var workout_name: String
    
    // variables used to control popup menu
    @State private var exercise = ""
    @State private var searchItem = ""
    @State private var showSettings = false
    
    // variables for showing bottom sheets
    @State private var showingExerciseSheet = false
    @State private var isSelected = false
    @State private var isSelected2 = false
    
    //variables for showing alerts
    @State private var showAlert = false
    @State private var conflictAlert = false //var for exercise name conflict alert
    @State var alertTitle = ""
    
    @State private var exerciseType: Int16 = 0
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    // used to control text color and background color
    var color_Text: Color {
        if isDarkMode == true { return .white
        } else { return .black
        }
    }
    var color_Text2: Color {
        if isDarkMode == true { return .black
        } else { return .white
        }
    }
    private var background_color: Color {
        if isDarkMode == true { return .gray
        } else { return .black
        }
    }
    
    var body : some View{
        VStack(content: {
            Text("Add New Exercise")
                .font(.system(size: 20).weight(.bold))
                .padding()
            
            HStack(content: {
                // gathers exercise type weight
                SelectButton(isSelected: $isSelected, color: .gray, text: "Weight")
                    .onTapGesture{
                        isSelected = true
                        if isSelected{
                            isSelected2 = false
                            exerciseType = 0
                        }
                    }
                // gathers exercise type time
                SelectButton(isSelected: $isSelected2, color: .gray, text: "Time")
                    .onTapGesture{
                        isSelected2 = true
                        if isSelected2{
                            isSelected = false
                            exerciseType = 1
                        }
                    }
            })
            
            TextField("Exercise", text: $exercise)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 75)
            // error checking and add exercise button
            Button{
                if (exercise == ""){
                    alertTitle = "You did not enter a name"
                    showAlert.toggle()
                } else if (isSelected == false && isSelected2 == false) {
                    alertTitle = "You did not choose an exercise type"
                    showAlert.toggle()
                } else{
                    let al:Bool = addExercise(exercise_name: exercise, exercise_type: exerciseType, workout_name: workout_name)
                    
                    if (al == true){
                        //                                        conflictAlert.toggle()
                        alertTitle = "Looks like this exercise name is already taken"
                        showAlert.toggle()
                        
                    }
                    if(al == false){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                // reset control vars
                isSelected = false
                isSelected2 = false
                exercise = ""
            } label: {
                Text("Add New Exercise")
                    .padding(.horizontal, 58)
                    .padding(.vertical, 15)
                    .foregroundColor(.white)
                    .background(background_color, in: RoundedRectangle(cornerRadius: 10))
            }
            .alert(isPresented: $showAlert, content: {
                getAlert()
            })

            // Cancel button
            Button{
                showingExerciseSheet.toggle()
                isSelected = false
                isSelected2 = false
                exercise = ""
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
                    .padding(.horizontal, 100)
                    .padding(.vertical, 15)
                    .foregroundColor(.white)
                    .background(.red, in: RoundedRectangle(cornerRadius: 10))
            }
            .frame(alignment: .bottom)
        })
        .presentationDetents([.fraction(0.40)])
    }
    //function for showing alerts
    func getAlert() -> Alert {
        return Alert(
            title: Text(alertTitle),
            dismissButton: .default(Text("Ok, got it!"))
        )
    }
    
    // function for ceating exercise in data base, returns true if name conflict
    private func addExercise(exercise_name: String, exercise_type: Int16, workout_name: String) -> Bool {
        for exercise in exercises{
            if (exercise.workout_name == workout_name && exercise.name ==  exercise_name){
                return true
            }
        }
        withAnimation{
            // Create new exercise object and assign data
            let newExercise = Exercises(context: viewContext)
            newExercise.name = exercise_name
            newExercise.type = exercise_type
            newExercise.workout_name = workout_name
            // Reset popup text field
            exercise = ""
            // Save exercise to db
            do{
                try viewContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        return false
    }
}
