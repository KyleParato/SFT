//
//  Table_View_Exercise_Entry_List.swift
//  SFT
//
//  Created by Kyle Parato on 3/7/24.
//

import SwiftUI
import Foundation

struct Entries_List_Static: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch all static exercise data and store it to var enteries
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise_Static.timestamp, ascending: true)],
        animation: .default)
    private var enteries : FetchedResults<Exercise_Static>
    
    // parent exercise name
    @State var current_exercise_name :String
    @State private var searchItem = ""
    
    // controls text color and background color
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    var color_Text: Color {
        if isDarkMode == true { return .white
        } else { return .black
        }
    }
    
    var body: some View{
        // list of entries
        let exercise_name_list = generate_entry_list(entries:enteries)
        NavigationStack{
            VStack{
                NavigationView{
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
                }.navigationTitle(current_exercise_name)
                Button(action: {deleteAllEntries()}){
                    Text("Delete All Entries")
                        .foregroundStyle(Color.red)
                }
                .buttonStyle(.bordered)
                    
            }
        }
        .searchable(text: $searchItem, placement: .navigationBarDrawer, prompt: "Search Workouts")
        // filters through workout names
        var filteredSearch: [String] {
            if searchItem.isEmpty {
                //returns original array if search is empty
                return exercise_name_list
            } else {
                return exercise_name_list.filter { $0.localizedCaseInsensitiveContains(searchItem)}
            }
        }
        
    }
    // date to string
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    // deletes entry from list
    private func deleteEntry(offsets:IndexSet){
        withAnimation{
            offsets.map { enteries[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    // gathers entries and stores in readable format
    func generate_entry_list(entries : FetchedResults<Exercise_Static>) -> [String]{
        var returnarr :[String] = []
        for entry in enteries{
            returnarr.append(entry.exercise_name!)
        }
        return returnarr
    }
    // deletes all entries
    func deleteAllEntries(){
        for entry in enteries{
            if entry.exercise_name == current_exercise_name{
                viewContext.delete(entry)
            }
        }
    }
}

struct Entries_List_Time: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch all static exercise data and store it to var enteries
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise_Time.timestamp, ascending: true)],
        animation: .default)
    private var enteries : FetchedResults<Exercise_Time>
    
    // parent exercise name
    @State var current_exercise_name :String
    @State private var searchItem = ""
    
    // controls text color and background color
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    var color_Text: Color {
        if isDarkMode == true { return .white
        } else { return .black
        }
    }
    var body: some View{
        // list of entries
        let exercise_name_list = generate_entry_list(entries:enteries)
        NavigationStack{
            VStack{
                NavigationView{
                    List{
                        ForEach(enteries){ entry in
                            if(entry.exercise_name == current_exercise_name){
                                NavigationLink{
                                    Text("Entry: \(entry.timestamp!, formatter: itemFormatter)\n Duration: \(entry.duration) in seconds")
                                    
                                } label:{
                                    Text(entry.timestamp!, formatter: itemFormatter)
                                }
                            }
                        }
                        .onDelete(perform: deleteEntry)
                    }
                }.navigationTitle(current_exercise_name)
                Button(action: {deleteAllEntries()}){
                    Text("Delete All Entries")
                        .foregroundStyle(Color.red)
                }
                .buttonStyle(.bordered)
                    
            }
        }
        .searchable(text: $searchItem, placement: .navigationBarDrawer, prompt: "Search Workouts")
        // filters through workout names
        var filteredSearch: [String] {
            if searchItem.isEmpty {
                //returns original array if search is empty
                return exercise_name_list
            } else {
                return exercise_name_list.filter { $0.localizedCaseInsensitiveContains(searchItem)}
            }
        }
        
    }
    // date to string
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    // deletes entry from list
    private func deleteEntry(offsets:IndexSet){
        withAnimation{
            offsets.map { enteries[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    // gathers entries and stores in readable format
    func generate_entry_list(entries : FetchedResults<Exercise_Time>) -> [String]{
        var returnarr :[String] = []
        for entry in enteries{
            returnarr.append(entry.exercise_name!)
        }
        return returnarr
    }
    // deletes all entries
    func deleteAllEntries(){
        for entry in enteries{
            if entry.exercise_name == current_exercise_name{
                viewContext.delete(entry)
            }
        }
    }
    
}

