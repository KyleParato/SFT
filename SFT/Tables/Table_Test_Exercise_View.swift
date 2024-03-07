//
//  Table_Test_Exercise_View.swift
//  SFT
//
//  Created by Kyle Parato on 2/25/24.
//

import SwiftUI
import Foundation
import Charts

struct Table_Test_Exercise_View: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
   
    // Fetch all static exercise data and store it to var enteries
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise_Static.timestamp, ascending: true)],
        animation: .default)
    private var enteries : FetchedResults<Exercise_Static>
    
    // parent exercise name
    @State var current_exercise_name :String
    
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
                // Plot data to graph
                Chart(to_plot, id:\.name){
                    // Bar graph version
                    BarMark(x: .value("Time",$0.timestamp), y: .value("Weight", $0.weight)).foregroundStyle(by: .value("Reps: ", $0.reps))
                    
                    // Original line graph with poits idea, uncomment to test
//                    LineMark( x: .value("Time",$0.timestamp), y: .value("Weight", $0.weight))
//                    PointMark(x: .value("Time",$0.timestamp), y: .value("Weight", $0.weight)).foregroundStyle(by: .value("Reps: ", $0.reps))
                                
                }
                .aspectRatio(1,contentMode: .fit)
                .padding(.horizontal,5)
                // Create new entry button
                Button(action:{addEntry(weight:Double.random(in: 100..<200),reps:Int16.random(in: 1..<10))}){
                    Label("Add New Entry", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                NavigationLink(destination: Table_View_Exercise_Entry_List(current_exercise_name: current_exercise_name)){
                    Text("View Entries")
                }
                .buttonStyle(.bordered)
            }
            Spacer()
        }
    }
    
    // Creating new entry
    func addEntry(weight: Double,reps: Int16){
        withAnimation{
            // Create new exercise entry
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
    // Filtering data and converting it to a plottable form
    func create_plot_data() -> [data_value]{
        let formater = DateFormatter()
            formater.dateStyle = .short
        var return_arr:[data_value] = []
        for data in enteries{
            if(data.exercise_name == current_exercise_name){
                let point: data_value = data_value(name:current_exercise_name, weight:data.weight,timestamp:data.timestamp!.formatted(),reps:"\(data.reps)")
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
