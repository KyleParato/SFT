//
//  sft_homescreen.swift
//  SFT
//
//  Created by Kyle Parato on 2/13/24.
//

import SwiftUI

struct SFT_loading_screen: View {
    var body: some View {
        VStack(){
            Image("SFT_Icon")
            Text("Simple Fitness Tracker")
                .font(.title)
            Text("progress made simple")
                .italic()
            Text("test")
        }
        .padding() 
    }
}

#Preview {
    SFT_loading_screen()
}
