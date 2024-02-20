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
            Text("Deadlift")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Image("Demo_Graph_1")
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            Label("Add New Entry", systemImage: "plus")
        }
    }
}

struct Demo_View_Bench: View {
    var body: some View {
        VStack{
            Text("Bench")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Image("Demo_Graph_2")
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            Label("Add New Entry", systemImage: "plus")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}
struct Demo_View_Squat: View {
    var body: some View {
        VStack{
            Text("Squat")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Image("Demo_Graph_3")
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            Label("Add New Entry", systemImage: "plus")
        }
    }
}

#Preview {
    Demo_View_Deadlift()
}
