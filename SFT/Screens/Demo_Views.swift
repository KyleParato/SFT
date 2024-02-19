//
//  Demo_Views.swift
//  SFT
//
//  Created by Kyle Parato on 2/18/24.
//

import SwiftUI

struct Demo_View_Deadlift: View {
    var body: some View {
        VStack{
            Image("Demo_Graph_1")
                .resizable()
                    .aspectRatio(contentMode: .fit)
            Text("Deadlift")
                .font(.title)
        }
    }
}
struct Demo_View_Bench: View {
    var body: some View {
        VStack{
            Image("Demo_Graph_2")
                .resizable()
                    .aspectRatio(contentMode: .fit)
            Text("Bench")
                .font(.title)
        }
    }
}
struct Demo_View_Squat: View {
    var body: some View {
        VStack{
            Image("Demo_Graph_3")
                .resizable()
                    .aspectRatio(contentMode: .fit)
            Text("Squat")
                .font(.title)
        }
    }
}

#Preview {
    Demo_View_Deadlift()
}
