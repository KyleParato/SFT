//
//  HomeScreen.swift
//  SFT
//
//  Created by Roy Joacquin Masepequena on 2/15/24.
//

import SwiftUI

struct HomeScreen: View {
    
    @State private var showAlert = false
    @State private var workout = ""
    
    @State var workoutList: [String] = [
        "Workout 1", "Workout 2", "Workout 3"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack{
                    //List view for workouts
                   // NavigationView {
                        List {
                            //Loop to create list with nav links to different pages
                            ForEach(workoutList, id: \.self){ workout in
                                NavigationLink(destination: Exercise_List_View()){
                                    Image(systemName: "scalemass")
                                    Text(workout)
                                }.padding(.vertical, 5)
                            }
                            .onDelete(perform: delete)
                        }
                    //}
                    .navigationTitle("Workouts")
                    /*.navigationBarItems(
                        leading: Button(action: search_exercises){
                            Label("Search", systemImage: "magnifyingglass")
                        },
                        trailing: Button(action: hamburger_menu){
                            Label("Menu", systemImage: "sidebar.right")
                        })*/
                    
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

                        Button("Add new workout", action: {workoutList.append(workout)})
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
    
    //func for deleting list items
    func delete(indexSet: IndexSet){
        workoutList.remove(atOffsets: indexSet)
    }
    
    private func search_exercises(){
        
    }
    private func hamburger_menu(){
        
    }
    
}

#Preview {
    HomeScreen()
}

