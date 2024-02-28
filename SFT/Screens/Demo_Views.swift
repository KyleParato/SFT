//
//  Demo_Views.swift
//  SFT
//
//  Created by Kyle Parato on 2/18/24.
//

import SwiftUI

struct Demo_View_Deadlift: View {
    @Environment(\.managedObjectContext) private var DLContext
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Deadlift.timestamp,ascending:true)],animation: .default)
    
    var body: some View {
        NavigationStack{
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
                Button(action:addItem){
                    Label("Add New Entry", systemImage: "plus")
                }
                .buttonStyle(.bordered)
            }
            Spacer()
        }
        
    }
    private func addItem(){
        withAnimation{
            //let newItem = Deadlift(context: DLContext)
            
            
        }
    }
}

struct Demo_View_Bench: View {
    @Environment(\.managedObjectContext) private var BContext
    var body: some View {
        NavigationStack{
            VStack{
                Text("Bench")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("Demo_Graph_2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action:addItem){
                    Label("Add New Entry", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
            
    }
    private func addItem(){
        withAnimation{
            //let newItem = Bench(context: BContext)
            
            
        }
    }
}
struct Demo_View_Squat: View {
    @Environment(\.managedObjectContext) private var SContext
    var body: some View {
        NavigationStack{
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
                Button(action:addItem){
                    Label("Add New Entry", systemImage: "plus")
                }
                .buttonStyle(.bordered)
            }
            Spacer()
        }
        
        
    }
    private func addItem(){
        withAnimation{
            //let newItem = Squat(context: SContext)
            
            
        }
    }
}



#Preview {
    Demo_View_Squat()
}
