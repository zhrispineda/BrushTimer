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
                            // Underlying circle stroke
                            Circle()
                                .trim(from: 0, to: timerDuration)
                                .stroke(style: StrokeStyle(lineWidth: 20.0))
                                .foregroundStyle(.background)
                                .padding(50)
                            
                            // Animating circle stroke
                            Circle()
                                .trim(from: 0, to: timeRemaining/timerDuration)
                                .stroke(style: StrokeStyle(lineWidth: 20.0, dash: [3.5]))
                                .foregroundStyle(selectedColor)
                                .padding(50)
                                .rotationEffect(.degrees(270))
                                .shadow(color: selectedColor, radius: 7.5)
                            
                            // Remaining time text
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
                        .background {
                            RoundedRectangle(cornerRadius: 15.0)
                                .foregroundStyle(Color(UIColor.tertiarySystemGroupedBackground))
                                .frame(maxHeight: 350)
                                .padding()
                        }
                    }
                    
                    // Start/resume text
                    if !running {
                        Text(timeRemaining < timerDuration ? "Continue?" : "Ready?")
                            .font(.system(size: 42))
                            .fontWeight(.bold)
                    }
                    
                    // Primary button (Start, Pause, Resume, Dismiss)
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
                                
                                let now = Date()
                                let startDate = now.addingTimeInterval(-2 * 60) // 2 minutes
                                let endDate = now
                                healthKitManager.saveToothbrushingData(startDate: startDate, endDate: endDate)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    // Cancel button
                    if timeRemaining < timerDuration && !running {
                        Button("Cancel") {
                            withAnimation {
                                timeRemaining = timerDuration
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
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
