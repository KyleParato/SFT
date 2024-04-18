//
//  Table_Test_Exercise_View.swift
//  SFT
//
//  Created by Kyle Parato on 2/25/24.
//

import SwiftUI
import Foundation
import Charts

struct Single_Exercise_View: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
   
    // Fetch all static exercise data and store it to var enteries
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise_Static.timestamp, ascending: true)],
        animation: .default)
    private var enteries : FetchedResults<Exercise_Static>
    
    // parent exercise name
    @State var current_exercise_name :String
    @State var showingWeightVew = false
    @State private var showAlert = false
    
    // Single exercise view
    var body: some View {
        NavigationStack{
            VStack{
                Text(current_exercise_name)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                // Gather data from enteries
                let to_plot = create_plot_data()
                let numberOfDisplay = 5
                // Plot data to graph
                Chart(to_plot, id:\.name){
                    // Bar graph version
                    BarMark(x: .value("Time",$0.timestamp), y: .value("Weight", $0.weight)).foregroundStyle(by: .value("Reps: ", $0.reps))
                    
                    
                    // Original line graph with poits idea, uncomment to test
//                    LineMark( x: .value("Time",$0.timestamp), y: .value("Weight", $0.weight))
//                    PointMark(x: .value("Time",$0.timestamp), y: .value("Weight", $0.weight)).foregroundStyle(by: .value("Reps: ", $0.reps))
                                
                }
                .chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: numberOfDisplay)
                
                .aspectRatio(1,contentMode: .fit)
                .padding(.horizontal,5)
                // Create new entry button
                Button("Add New Entry", systemImage: "plus"){
                    showingWeightVew.toggle()
                }
                .buttonStyle(.bordered)
                .sheet(isPresented:$showingWeightVew, content: {weight_entry(current_exercise_name: current_exercise_name).presentationDetents([.medium])})
                NavigationLink(destination: Entries_List(current_exercise_name: current_exercise_name)){
                    Text("View Entries")
                }
                .buttonStyle(.bordered)
            }
            Spacer()
        }
    }
    
    
    // Filtering data and converting it to a plottable form
    func create_plot_data() -> [data_value] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        var return_arr:[data_value] = []
        for data in enteries {
            if(data.exercise_name == current_exercise_name) {
                let timestamp = formatter.string(from: data.timestamp!)
                let point: data_value = data_value(name:current_exercise_name, weight:data.weight,timestamp:timestamp,reps:"\(data.reps)")
                return_arr.append(point)
            }
        }
        return return_arr
    }
    
    // Struct to store data for plotting, id is name, type string
    struct data_value{
        var name : String // id
        var weight: Double
        var timestamp : String
        var reps: String
    }
    
}

struct weight_entry: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var current_exercise_name :String
    @State var weight_in : String = ""
    @State var reps_in: String = ""
    @State var weight:Double = 0.0
    @State var reps:Int16 = 0
    
    var body: some View {
        TextField("Weight", text: $weight_in)
            .disableAutocorrection(true)
            .textFieldStyle(.roundedBorder)
        TextField("Reps", text: $reps_in)
            .disableAutocorrection(true)
            .textFieldStyle(.roundedBorder)
        
        Button("Submit", action: {
            weight = Double(weight_in)!
            reps = Int16(reps_in)!
            addEntry(weight:weight,reps:reps)
            
        })
            
    }
    
    // Creating new entry
    func addEntry(weight: Double,reps: Int16)->Void{
        let timestamp = Date().timeIntervalSince1970
        withAnimation{
            // Create new exercise entry
            let newEntry = Exercise_Static(context: viewContext)
            newEntry.exercise_name = current_exercise_name
            newEntry.weight = weight
            newEntry.reps = reps
            newEntry.timestamp = Date(timeIntervalSince1970: timestamp)
            do{
                try viewContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
}
