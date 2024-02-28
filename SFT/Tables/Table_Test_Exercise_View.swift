//
//  Table_Test_Exercise_View.swift
//  SFT
//
//  Created by Kyle Parato on 2/25/24.
//

import SwiftUI

struct Table_Test_Exercise_View: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
   
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise_Static.timestamp, ascending: true)],
        animation: .default)
    private var current_data : FetchedResults<Exercise_Static>
    
    
    @State var current_exercise_name :String
    var body: some View {
        NavigationStack{
            VStack{
                Text(current_exercise_name)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Image("Demo_Graph_1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Button(action:{addEntry(weight:Float.random(in: 100..<200),reps:Int16.random(in: 1..<10))}){
                    Label("Add New Entry", systemImage: "plus")
                }
                .buttonStyle(.bordered)
            }
            Spacer()
        }
    }
    
    func addEntry(weight: Float,reps: Int16){
        withAnimation{
            let newEntry = Exercise_Static(context: viewContext)
            newEntry.exercise_name = current_exercise_name
            newEntry.weight = weight
            newEntry.reps = reps
            newEntry.timestamp = Date()
            do{
                try viewContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
    
}

//#Preview {
//    Table_Test_Exercise_View()
//}
