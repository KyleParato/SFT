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
    
    let workoutList = [
        "Workout 1",
        "Workout 2",
        "Workout 3",
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack{
                    HStack{
                        Image("Search_LM")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.vertical, 30)
                        
                        Image("In_App_Icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .cornerRadius(6)
                            .padding(.horizontal, 70)
                        
                        Image("Settings_LM")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40, alignment: .trailing)
                            .padding(.vertical, 30)
                    }
                    .frame(width: 350, height: 100)
                    .cornerRadius(20)
                    .padding(.vertical, 10)
                    
                    List {
                        ForEach(workoutList, id: \.self){ workout in
                            NavigationLink(destination: Text(workout)){
                                Text(workout)
                            }.padding(.vertical, 5)
                        }
                    }
                    
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
                                TextField("Username", text: $workout)

                                Button("Add workout", action: {})
                                Button("Cancel", role: .cancel, action: {})
                            }, message: {
                                Text("New workout has been added.")
                            })
                    
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}

