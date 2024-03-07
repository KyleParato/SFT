//
//  Table_View_Exercise_Entry_List.swift
//  SFT
//
//  Created by Kyle Parato on 3/7/24.
//

import SwiftUI
import Foundation

struct Table_View_Exercise_Entry_List: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch all static exercise data and store it to var enteries
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise_Static.timestamp, ascending: true)],
        animation: .default)
    private var enteries : FetchedResults<Exercise_Static>
    
    // parent exercise name
    @State var current_exercise_name :String
    
    var body: some View{
        NavigationStack{
            VStack{
                List{
                    ForEach(enteries){ entry in
                        if(entry.exercise_name == current_exercise_name){
                            NavigationLink{
                                Text("Entry: \(entry.timestamp!, formatter: itemFormatter)\n  Weight: \(entry.weight)\n  Reps: \(entry.reps)")
                                
                            } label:{
                                Text(entry.timestamp!, formatter: itemFormatter)
                            }
                        }
                    }
                    .onDelete(perform: deleteEntry)
                }
            }
            Text("Entries")
        }
        
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    private func deleteEntry(offsets:IndexSet){
        withAnimation{
            offsets.map { enteries[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

