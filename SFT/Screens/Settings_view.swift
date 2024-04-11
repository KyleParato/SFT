import SwiftUI

struct Settings_view: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Display")){
                    Toggle(isOn: $isDarkMode,
                           label: {
                        Text("Dark mode")
                    })
                    
                    HStack {
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
    
    struct Settings_view_Previews: PreviewProvider {
        static var previews: some View {
            Settings_view()
        }
    }
}
