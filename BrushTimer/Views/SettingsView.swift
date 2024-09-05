//
//  SettingsView.swift
//  BrushTimer
//

import SwiftUI

struct SettingsView: View {
    // Variables
    @State private var selected = "Default (Blue)"
    let colors = ["Default (Blue)", "Yellow", "Green", "Pink", "Purple"]
    @State private var duration = 120.0
    
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
                }
                
                Section {
                    Slider(value: $duration,
                           in: 60.0...180.0,
                           step: 10.0,
                           label: { Text("Duration")  }
                    )
                    Text("\(Int(duration)) seconds")
                } header: {
                    Text("Timer Duration")
                } footer: {
                    Text("It is strongly recommended to brush for 2 minutes or 120 seconds.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
