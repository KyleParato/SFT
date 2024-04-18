//
//  Table_Test_Exercise.swift
//  SFT
//
//  Created by Kyle Parato on 2/25/24.
//

import SwiftUI

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
    @State private var showAlert = false
    @State private var exercise = ""
    @State private var searchItem = ""
    
    // variables for showing bottom sheets
    @State private var showingExerciseView = false
    @State private var isSelected = false
    @State private var isSelected2 = false
    
    @State private var exerciseType: Int16 = 0
    
    // Exercise View
    var body: some View {
        
        //Stores names of exercises and their workout name
        let exercise_name_list = generate_exercise_list(exercises:exercises)
        
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
                                        Image(systemName: "dumbbell.fill")
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
                        showingExerciseView.toggle()
                    }label: {
                        Text("Add Exercise")
                            .font(.system(size: 18).weight(.bold))
                            .padding(.horizontal, 85)
                            .padding(.vertical,15)
                            .foregroundColor(.white)
                            .background(.black)
                            .cornerRadius(20)
                    }
                    .sheet(isPresented: $showingExerciseView, content: {
                        VStack(content: {
                            HStack(content: {
                                SelectButton(isSelected: $isSelected, color: .gray, text: "Weight")
                                    .onTapGesture{
                                        isSelected = true
                                        if isSelected{
                                            isSelected2 = false
                                            exerciseType = 0
                                            
                                        }
                                    }
                
                                SelectButton(isSelected: $isSelected2, color: .gray, text: "Time")
                                    .onTapGesture{
                                        isSelected2 = true
                                        if isSelected2{
                                            isSelected = false
                                            exerciseType = 1
                                        }
                                    }
                            })
                            
                            Divider()
//                                .padding(.horizontal, 30)
                                .frame(height:10)
                            
                            TextField("Exercise", text: $exercise)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 75)
                            
                            Divider()
                                .padding(.horizontal, 30)
                                                    
                            Button("Add new exercise"){
                                addExercise(exercise_name: exercise, exercise_type: exerciseType, workout_name: workout_name)
                                showingExerciseView.toggle()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .foregroundColor(.white)
                            .background(.black, in: RoundedRectangle(cornerRadius: 10))
                            
                            Divider()
                                .padding(.horizontal, 30)
                            
                            Button("Cancel"){
                                showingExerciseView.toggle()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .foregroundColor(.white)
                            .background(.red, in: RoundedRectangle(cornerRadius: 10))
                            
                            Divider()
                                .padding(.horizontal, 30)
                            
                        })
                            .presentationDetents([.medium])
                    })
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: hamburger_menu){
                        Label("Menu", systemImage: "sidebar.right")
                    }
                }
            }
        }
        
        .searchable(text: $searchItem, placement: .navigationBarDrawer, prompt: "Search Exercises")
        // filters through workout names
        var filteredSearch: [exercise_filter] {
            if searchItem.isEmpty {
                //returns original array if search is empty
                return exercise_name_list
            } else {
                return exercise_name_list.filter { $0.name.localizedCaseInsensitiveContains(searchItem)}
            }
        }
    }
    // function for ceating exercise in data base
    private func addExercise(exercise_name: String, exercise_type: Int16, workout_name: String){
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
    
    //func that appends names of exercises into array for searching
    func generate_exercise_list(exercises : FetchedResults<Exercises>) -> [exercise_filter]{
        var returnarr : [exercise_filter] = []
        for exercise in exercises{
            if(exercise.workout_name == workout_name){
                returnarr.append(exercise_filter(name:exercise.name!,workout_name: exercise.workout_name!))
            }
        }
        return returnarr
    }
    
    struct exercise_filter{
        var name : String
        var workout_name: String
        
        var hashVale: Int{
            return name.hashValue
        }
    }
    
    private func hamburger_menu(){
        
    }
    
}

struct SelectButton: View {
    @Binding var isSelected: Bool
    @State var color: Color
    @State var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 120, height: 35)
                .foregroundColor(isSelected ? color : .black)
            Text(text)
                .foregroundColor(.white)
        }
    }
}

