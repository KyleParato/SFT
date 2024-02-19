//
//  test_homescreen.swift
//  SFT
//
//  Created by Kyle Parato on 2/18/24.
//

import SwiftUI

struct test_homescreen: View {
    var body: some View {
        TabView {
            
            Demo_View_Squat()
            Demo_View_Bench()
            Demo_View_Deadlift()
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    test_homescreen()
}
