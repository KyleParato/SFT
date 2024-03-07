//
//  Exercise_List_View.swift
//  SFT
//
//  Created by Kyle Parato on 2/22/24.
//

import SwiftUI

struct Exercise_List_View: View {
    var body: some View {
        NavigationStack{
            List{
                NavigationLink(destination: tab_view(tag:1)){
                    Image(systemName: "dumbbell.fill")
                    Text("Squat")
                }
                NavigationLink(destination: tab_view(tag:2)){
                    Image(systemName: "dumbbell.fill")
                    Text("Bench")
                }
                NavigationLink(destination: tab_view(tag:3)){
                    Image(systemName: "dumbbell.fill")
                    Text("Deadlift")
                }
            }
                .navigationTitle("Exercises")
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
    private func search_exercises(){
        
    }
    private func hamburger_menu(){
        
    }
}

#Preview {
    Exercise_List_View()
}
