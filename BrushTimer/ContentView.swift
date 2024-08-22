//
//  ContentView.swift
//  BrushTimer
//

import SwiftUI

struct ContentView: View {
    // Variables
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Ready?")
            Button("Start") {}
                .buttonStyle(.borderedProminent)
        }
        .navigationTitle("BrushTimer")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingSettings) {
            NavigationStack {
                List {
                    Text("Option")
                }
                .interactiveDismissDisabled()
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            showingSettings.toggle()
                        }
                        .bold()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Settings", systemImage: "gear", action: {
                    showingSettings.toggle()
                })
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
