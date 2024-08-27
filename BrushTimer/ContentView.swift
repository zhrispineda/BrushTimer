//
//  ContentView.swift
//  BrushTimer
//

import SwiftUI

struct ContentView: View {
    // Variables
    @State private var showingSettings = false
    @State private var started = false
    @State private var timeRemaining = 120
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            if started {
                ZStack {
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining)/120.0)
                        .stroke(style: StrokeStyle(lineWidth: 16.0))
                        .foregroundColor(Color.blue)
                        .padding(50)
                        .rotationEffect(.degrees(270))
                    Text("\(timeRemaining)")
                        .font(.system(size: 64))
                        .fontWeight(.bold)
                        .monospaced()
                        .contentTransition(.numericText(countsDown: true))
                        .animation(.default, value: timeRemaining)
                        .onReceive(timer) { time in
                            if timeRemaining > 0 && started {
                                withAnimation {
                                    timeRemaining -= 1
                                }
                            }
                        }
                }
            }
            if !started {
                Text(timeRemaining < 120 ? "Continue?" : "Ready?")
            }
            Button(started ? "Pause" : timeRemaining < 120 ? "Resume" : "Start") {
                withAnimation {
                    started.toggle()
                }
            }
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
