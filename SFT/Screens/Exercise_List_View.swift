//
//  Exercise_List_View.swift
//  SFT
//
//  Created by Kyle Parato on 2/22/24.
//

import SwiftUI

struct Exercise_List_View: View {
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: test_homescreen()){
                    Image(systemName: "dumbbell.fill")
                    Text("Squat")
                }
                NavigationLink(destination: Demo_View_Bench()){
                    Image(systemName: "dumbbell.fill")
                    Text("Bench")
                }
                NavigationLink(destination: Demo_View_Deadlift()){
                    Image(systemName: "dumbbell.fill")
                    Text("Deadlift")
                }
            }.padding()
                .navigationTitle("Exercises")
        }
    }
}

#Preview {
    Exercise_List_View()
}
