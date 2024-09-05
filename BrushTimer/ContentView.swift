//
//  ContentView.swift
//  BrushTimer
//

import SwiftUI

struct ContentView: View {
    // Variables
    @State private var started = false
    @State private var timeRemaining = 120.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView {
            Tab("Timer", systemImage: "clock") {
                VStack(spacing: 50) {
                    if started {
                        ZStack {
                            Circle()
                                .trim(from: 0, to: timeRemaining/120.0)
                                .stroke(style: StrokeStyle(lineWidth: 16.0))
                                .foregroundColor(Color.blue)
                                .padding(50)
                                .rotationEffect(.degrees(270))
                            Text("\(Int(timeRemaining))")
                                .font(.system(size: 64))
                                .fontWeight(.bold)
                                .monospaced()
                                .contentTransition(.numericText(countsDown: true))
                                .animation(.default, value: timeRemaining)
                                .onReceive(timer) { time in
                                    if timeRemaining > 0 && started {
                                        withAnimation {
                                            timeRemaining -= 0.1
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
                    if timeRemaining < 120 && !started {
                        Button("Cancel") {
                            withAnimation {
                                timeRemaining = 120
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .navigationTitle("BrushTimer")
                .navigationBarTitleDisplayMode(.inline)
            }
            
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
