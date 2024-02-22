//
//  test_homescreen.swift
//  SFT
//
//  Created by Kyle Parato on 2/18/24.
//

import SwiftUI

struct test_homescreen: View {
    @State var tag: Int = 0
    var body: some View {
        NavigationStack{
            VStack{
                TabView(selection:$tag) {
                    Demo_View_Squat().tag(1)
                    Demo_View_Bench().tag(2)
                    Demo_View_Deadlift().tag(3)
                    Spacer()
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .never))
                Spacer()
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
            Spacer()
        }
    }
    private func search_exercises(){
        
    }
    private func hamburger_menu(){
        
    }
}

#Preview {
    test_homescreen()
}
