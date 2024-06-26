//
//  Table_Test_Exercise_View.swift
//  SFT
//
//  Created by Kyle Parato on 2/25/24.
//

import SwiftUI
import Foundation
import Charts

// graph view for weight
struct Single_Exercise_View_Static: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    // Color Text Boolean for dark mode
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    // controls text color and background color
    var color_Text: Color {
        if isDarkMode == true { return .white
        } else { return .black
        }
    }
    var color_Text2: Color {
        if isDarkMode == true { return .black
        } else { return .white
        }
    }
    private var background_color: Color {
        if isDarkMode == true { return .gray
        } else { return .black
        }
    }

    // Fetch all static exercise data and store it to var enteries
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise_Static.timestamp, ascending: true)],
        animation: .default)
    private var enteries : FetchedResults<Exercise_Static>
    
    // parent exercise name
    @State var current_exercise_name :String
    @State var showingWeightVew = false
    @State private var showAlert = false
    @State private var isGraph: Bool = false
    
    
    // Single exercise view
    var body: some View {
        NavigationStack{
            VStack{
                // Gather data from enteries
                let to_plot = create_plot_data()
                let numberOfDisplay = 5
                // Plot data to graph
                if isGraph == false {
                    // Bar graph version
                    Chart(to_plot, id:\.name){
                        BarMark(x: .value("Time",$0.timestamp), y: .value("Weight", $0.weight)).foregroundStyle(by: .value("Reps: ", $0.reps))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .chartScrollableAxes(.horizontal)
                    .chartXVisibleDomain(length: numberOfDisplay)
                    .aspectRatio(1,contentMode: .fit)
                    .padding(.horizontal,5)
                } else {
                    // Line graph version
                    Chart(to_plot, id:\.name){
                        LineMark( x: .value("Time",$0.timestamp), y: .value("Weight", $0.weight))
                        PointMark(x: .value("Time",$0.timestamp), y: .value("Weight", $0.weight)).foregroundStyle(by: .value("Reps: ", $0.reps))
                    }
                    .chartScrollableAxes(.horizontal)
                    .chartXVisibleDomain(length: numberOfDisplay)
                    .aspectRatio(1,contentMode: .fit)
                    .padding(.horizontal,5)
                }
                
                HStack {
                    // Toggle button between line graph and bargraph
                    Toggle(isOn: $isGraph,
                           label: {
                        Text("Line Graph")
                            .padding(.horizontal, 10)
                    })
                }
                
                // Create new entry button
                Button("Add New Entry", systemImage: "plus"){
                    showingWeightVew.toggle()
                }
                .foregroundColor(color_Text)
                .buttonStyle(.bordered)
                .sheet(isPresented:$showingWeightVew, content: {weight_entry(showingWeightVew:true, current_exercise_name: current_exercise_name).presentationDetents([.medium])})
                NavigationLink(destination: Entries_List_Static(current_exercise_name: current_exercise_name)){
                    Text("View Entries")
                        .foregroundColor(color_Text)
                }
                .buttonStyle(.bordered)
                Spacer()
            }
            .navigationTitle(current_exercise_name)
            .padding()
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

// gather user input for entry weight
struct weight_entry: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    // closes prompt
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // holds user input
    @State var showingWeightVew :Bool
    @State var current_exercise_name :String
    @State var weight_in : String = ""
    @State var reps_in: String = ""
    @State var weight:Double = 0.0
    @State var reps:Int16 = 0
    
    //variables for showing error alerts
    @State private var showAlert = false
    @State var alertTitle = ""
    // text color and background color vars
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    var color_Text: Color {
        if isDarkMode == true { return .white
        } else { return .black
        }
    }
    var color_Text2: Color {
        if isDarkMode == true { return .black
        } else { return .white
        }
    }
    private var background_color: Color {
        if isDarkMode == true { return .gray
        } else { return .black
        }
    }
    
    var body: some View {
        VStack{
            Text("Add New Entry")
                .font(.system(size: 20).weight(.bold))
                .padding()
            // gathers weight float
            TextField("Weight", text: $weight_in)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 75)
                .keyboardType(.decimalPad)
            // gathers weight int
            TextField("Reps", text: $reps_in)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 75)
                .keyboardType(.numberPad)
            // add entry weight with error checking
            Button {
                //if statements for error checking
                if (weight_in == "" && reps_in == ""){
                    alertTitle = "Looks like you did not enter any values"
                    showAlert.toggle()
                } else if (weight_in == ""){
                    alertTitle = "You did not enter a weight value"
                    showAlert.toggle()
                } else if (reps_in == ""){
                    alertTitle = "You did not enter any reps"
                    showAlert.toggle()
                } else {
                    weight = Double(weight_in)!
                    reps = Int16(reps_in)!
                    addEntry(weight:weight,reps:reps)
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            } label: {
                Text("Add Entry")
                .padding(.horizontal, 58)
                .padding(.vertical, 15)
                .foregroundColor(color_Text2)
                .background(background_color, in: RoundedRectangle(cornerRadius: 10))
            }
            .alert(isPresented: $showAlert, content: {
                getAlert()
            })
            // cancel prompt button
            Button{
                self.presentationMode.wrappedValue.dismiss()
                
            } label: {
                Text("Cancel")
                    .padding(.horizontal, 75)
                    .padding(.vertical, 15)
                    .foregroundColor(.white)
                    .background(.red, in: RoundedRectangle(cornerRadius: 10))
            }
        }
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
    // generates alerts
    func getAlert() -> Alert {
        return Alert(
            title: Text(alertTitle),
            dismissButton: .default(Text("Ok, got it!"))
        )
    }
}

// graph view time
struct Single_Exercise_View_Time: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    // Color Text Boolean for dark mode
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    private var color_Text: Color {
        if isDarkMode == true { return .white
        } else { return .black
        }
    }

    // Fetch all static exercise data and store it to var enteries
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise_Time.timestamp, ascending: true)],
        animation: .default)
    private var enteries : FetchedResults<Exercise_Time>
    
    // parent exercise name and alert vars
    @State var current_exercise_name :String
    @State var showingTimeVew = false
    @State private var showAlert = false
    @State private var isGraph: Bool = false
    
    // Single exercise view
    var body: some View {
        NavigationStack{
            VStack{
                // Gather data from enteries
                let to_plot = create_plot_data()
                let numberOfDisplay = 5
                // Plot data to graph
                if isGraph == false {
                    // Bar graph version
                   Chart(to_plot, id:\.name){
                        BarMark(x: .value("Time",$0.timestamp), y: .value("Duration", $0.duration))
                        
                    }
                    .foregroundColor(.green)
                    .chartYAxis {
                        // Converts seconds to hh:mm:ss on the axis ticks
                        AxisMarks { value in
                            AxisGridLine()
                            AxisTick()
                            if let value = value.as(Int.self) {
                                // converts seconds to hh:mm:ss
                                let valueLabel = "\(Int(value/3600)):\(Int(value/60)%60):\(Int(value%60))"
                                AxisValueLabel {
                                    Text(String(valueLabel))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .chartScrollableAxes(.horizontal)
                    .chartXVisibleDomain(length: numberOfDisplay)
                    
                    .aspectRatio(1,contentMode: .fit)
                    .padding(.horizontal,5)
                } else {
                    // line graph version
                    Chart(to_plot, id:\.name){
                        LineMark( x: .value("Time",$0.timestamp), y: .value("Duration", $0.duration))
                        PointMark(x: .value("Time",$0.timestamp), y: .value("Duration", $0.duration))
                    }
                    .foregroundColor(.green)
                    .chartYAxis {
                        // Converts seconds to hh:mm:ss on the axis ticks
                        AxisMarks { value in
                            AxisGridLine()
                            AxisTick()
                            if let value = value.as(Int.self) {
                                // converts seconds to hh:mm:ss
                                let valueLabel = "\(Int(value/3600)):\(Int(value/60)%60):\(Int(value%60))"
                                AxisValueLabel {
                                    Text(String(valueLabel))
                                }
                            }
                        }
                    }
                    .chartScrollableAxes(.horizontal)
                    .chartXVisibleDomain(length: numberOfDisplay)
                    .aspectRatio(1,contentMode: .fit)
                    .padding(.horizontal,5)
                }
                
                HStack {
                    // Toggle button between line graph and bargraph
                    Toggle(isOn: $isGraph,
                           label: {
                        Text("Line Graph")
                            .padding(.horizontal, 10)
                    })
                }
                
                // Create new entry button
                Button("Add New Entry", systemImage: "plus"){
                    showingTimeVew.toggle()
                }
                .buttonStyle(.bordered)
                .foregroundColor(color_Text)
                .sheet(isPresented:$showingTimeVew, content: {time_entry(current_exercise_name: current_exercise_name).presentationDetents([.medium])})
                NavigationLink(destination: Entries_List_Time(current_exercise_name: current_exercise_name)){
                    Text("View Entries")
                        .foregroundColor(color_Text)
                }
                .buttonStyle(.bordered)
                Spacer()
            }
            .navigationTitle(current_exercise_name)
            .padding()
        }
    }
    
    
    // Filtering data and converting it to a plottable form
    func create_plot_data() -> [data_value] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/mm/ss HH:mm:ss"
        var return_arr:[data_value] = []
        for data in enteries {
            if(data.exercise_name == current_exercise_name) {
                let timestamp = formatter.string(from: data.timestamp!)
                let point: data_value = data_value(name:current_exercise_name, duration:data.duration,timestamp:timestamp)
                return_arr.append(point)
            }
        }
        return return_arr
    }
    
    // Struct to store data for plotting, id is name, type string
    struct data_value{
        var name : String // id
        var duration: Int64
        var timestamp : String
    }
}

// gather user input for entry time
struct time_entry: View {
    // Database Context
    @Environment(\.managedObjectContext) private var viewContext
    // used to close form
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // holds user input
    @State var current_exercise_name :String
    @State var hours:Int = 0
    @State var min:Int = 0
    @State var sec:Int = 0
    
    //variables for showing error alerts
    @State private var showAlert = false
    @State var alertTitle = ""
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    // controls text color and background color
    var color_Text: Color {
        if isDarkMode == true { return .white
        } else { return .black
        }
    }
    var color_Text2: Color {
        if isDarkMode == true { return .black
        } else { return .white
        }
    }
    private var background_color: Color {
        if isDarkMode == true { return .gray
        } else { return .black
        }
    }
    
    var body: some View {
        VStack{
            Text("Add New Entry")
                .font(.system(size: 20).weight(.bold))
                .padding()
            // three wheel pickers for hh:mm:ss
            HStack{
                Picker("",selection: $hours){
                    ForEach(0..<999, id: \.self){ i in
                        Text("\(i) hours").tag(i)
                    }
                }.pickerStyle(WheelPickerStyle())
                Picker("", selection: $min){
                    ForEach(0..<60, id: \.self) { i in
                        Text("\(i) min").tag(i)
                    }
                }.pickerStyle(WheelPickerStyle())
                Picker("", selection: $sec){
                    ForEach(0..<60, id: \.self) { i in
                        Text("\(i) sec").tag(i)
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            
            // error checking and adding entry time
            Button {
                if (hours == 0 && min == 0 && sec == 0) {
                    alertTitle = "Looks like you did not enter a time"
                    showAlert.toggle()
                } else {
                    var time_in_seconds:Int64 = 0
                    time_in_seconds += Int64((hours*3600))
                    time_in_seconds += Int64((min*60))
                    time_in_seconds += Int64(sec)
                    addEntry(duration:time_in_seconds)
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            } label: {
                Text("Add Entry")
                .padding(.horizontal, 58)
                .padding(.vertical, 15)
                .foregroundColor(color_Text2)
                .background(background_color, in: RoundedRectangle(cornerRadius: 10))
            }
            .alert(isPresented: $showAlert, content: {
                getAlert()
            })
            
            // cancel and close form
            Button{
                self.presentationMode.wrappedValue.dismiss()
                
            } label: {
                Text("Cancel")
                    .padding(.horizontal, 75)
                    .padding(.vertical, 15)
                    .foregroundColor(.white)
                    .background(.red, in: RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    // Creating new entry
    func addEntry(duration: Int64)->Void{
        let timestamp = Date().timeIntervalSince1970
        withAnimation{
            // Create new exercise entry
            let newEntry = Exercise_Time(context: viewContext)
            newEntry.exercise_name = current_exercise_name
            newEntry.duration = duration
            newEntry.timestamp = Date(timeIntervalSince1970: timestamp)
            do{
                try viewContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
    // generates alerts
    func getAlert() -> Alert {
        return Alert(
            title: Text(alertTitle),
            dismissButton: .default(Text("Ok, got it!"))
        )
    }
}
