import SwiftUI

struct Settings_view: View {
    // Save information based on apple device settings
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
        
    var body: some View {
        NavigationView{
            Form {
                // Create a toggle button that can switch between dark mode and lightmode
                // More importantly this is the style for a toggle button
                Section(header: Text("Display")){
                    Toggle(isOn: $isDarkMode,
                           label: {
                        Text("Dark mode")
                    })
                    
                    HStack {
                        // Use system settings sets the button to off and takes ur systems color scheme
                        Text("Use System Settings")
                        Spacer()
                        Button(action: {
                            isDarkMode = false
                        }) {
                            Text("Reset")
                                .foregroundColor(.red)
                        }
                        .disabled(isDarkMode == false)
                        
                    }
                    
                }
                .navigationTitle("Settings")
                
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    

}
