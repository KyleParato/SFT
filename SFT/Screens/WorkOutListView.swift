//
//  WorkOutListView.swift
//  SFT
//
//  Created by Jovani Antonio on 2/21/24.
//

import SwiftUI

struct WorkOutListView: View {
    let workout = workList
    var body: some View {
        NavigationView {
            List {
                ForEach(workout, id: \.self){ workOut in
                    NavigationLink(destination: Text(workOut)){
                        Image(systemName: "scalemass")
                        Text(workOut)
                    }.padding()
                }
                .navigationTitle("Select Workout")
            }
        }
    }
}

#Preview {
    WorkOutListView()
}
