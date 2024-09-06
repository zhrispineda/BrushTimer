//
//  SettingsView.swift
//  BrushTimer
//

import SwiftUI

struct SettingsView: View {
    // Variables
    @State private var selected = "Default (Blue)"
    let colors = ["Default (Blue)", "Green", "Orange", "Pink", "Purple", "Red", "Yellow"]
    @State private var duration = 120.0
    @Binding var selectedColor: Color
    
    var body: some View {
        NavigationStack {
            List {
                Section("Timer Color") {
                    Picker("", selection: $selected) {
                        ForEach(colors, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                    .onChange(of: selected) {
                        switch selected {
                        case "Green":
                            selectedColor = Color.green
                        case "Orange":
                            selectedColor = Color.orange
                        case "Pink":
                            selectedColor = Color.pink
                        case "Purple":
                            selectedColor = Color.purple
                        case "Red":
                            selectedColor = Color.red
                        case "Yellow":
                            selectedColor = Color.yellow
                        default:
                            selectedColor = Color.blue
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView(selectedColor: .constant(Color.blue))
}
