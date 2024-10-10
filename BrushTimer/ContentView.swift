//
//  ContentView.swift
//  BrushTimer
//

import SwiftUI
import HealthKit

struct ContentView: View {
    // Variables
    var healthKitManager: HealthKitManager = HealthKitManager()
    @State private var running = false
    @State private var timerDuration = 120.0
    @State private var timeRemaining = 120.0
    @State private var selectedColor = Color.blue
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    init() {
        healthKitManager.requestHealthData()
    }
    
    var body: some View {
        TabView {
            Tab("Timer", systemImage: "clock") {
                VStack(spacing: 50) {
                    if running && timeRemaining > 0 {
                        ZStack {
                            Circle()
                                .trim(from: 0, to: timerDuration)
                                .stroke(style: StrokeStyle(lineWidth: 16.0))
                                .foregroundColor(Color.gray.opacity(0.5))
                                .padding(50)
                            Circle()
                                .trim(from: 0, to: timeRemaining/timerDuration)
                                .stroke(style: StrokeStyle(lineWidth: 16.0))
                                .foregroundColor(selectedColor)
                                .padding(50)
                                .rotationEffect(.degrees(270))
                                .shadow(color: selectedColor, radius: 10.0)
                            Text("\(Int(timeRemaining))")
                                .font(.system(size: 72))
                                .fontWeight(.bold)
                                .monospaced()
                                .contentTransition(.numericText(countsDown: true))
                                .animation(.default, value: timeRemaining)
                                .onReceive(timer) { time in
                                    if timeRemaining > 0 && running {
                                        withAnimation {
                                            timeRemaining -= 0.1
                                        }
                                    }
                                }
                        }
                    }
                    if !running {
                        Text(timeRemaining < timerDuration ? "Continue?" : "Ready?")
                            .font(.system(size: 42))
                            .fontWeight(.bold)
                    }
                    if timeRemaining > 0 {
                        Button(running ? "Pause" : timeRemaining < timerDuration ? "Resume" : "Start") {
                            withAnimation {
                                running.toggle()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .font(.title2)
                        .bold()
                    } else {
                        Text("Well done.")
                            .font(.system(size: 42))
                            .fontWeight(.bold)
                        Button("Dismiss") {
                            withAnimation {
                                timeRemaining = timerDuration
                                running = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    if timeRemaining < timerDuration && !running {
                        Button("Cancel") {
                            withAnimation {
                                timeRemaining = timerDuration
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .navigationTitle("BrushTimer")
                .navigationBarTitleDisplayMode(.inline)
            }
            
            Tab("Settings", systemImage: "gear") {
                SettingsView(selectedColor: $selectedColor)
            }
        }
    }
}

#Preview {
    ContentView()
}
