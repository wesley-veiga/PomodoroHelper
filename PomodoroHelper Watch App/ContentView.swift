//
//  ContentView.swift
//  PomodoroHelper Watch App
//
//  Created by Wesley Veiga on 12/10/22.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    @State private var focusTime = 25.0
    
    @State private var breakTime = 5.0
    
    @State private var isFocusSelected = true
    
    @State private var isStarted = false
    
    @State private var timer: Timer?
    
    @State private var timeRemaning: Int = 0
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                HStack(alignment: .center, spacing: 20) {
                    if !isStarted {
                        Button(action: {
                            self.isFocusSelected = true
                        }) {
                            Text("Focus")
                                .font(.headline)
                                .foregroundColor(isFocusSelected ? .blue : .gray)
                        }
                        
                        Button(action: {
                            self.isFocusSelected = false
                        }) {
                            Text("Break")
                                .font(.headline)
                                .foregroundColor(isFocusSelected ? .gray : .green)
                        }
                    }
                }
            }
            
            Text(isStarted ? ("\(displayTime(timeRemaning))") : isFocusSelected ? "\(focusTime, specifier: "%.0f") min" : "\(breakTime, specifier: "%.0f") min")
                .focusable(true)
                .disabled(isStarted)
                .digitalCrownRotation(isFocusSelected ? $focusTime : $breakTime, from: 0, through: 120.0, by: 1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                .padding(15)
                .font(.title)
            
            if isStarted {
                Text(isFocusSelected ? "Is Focus Time!" : "Take a break")
                    .padding(15)
                    .foregroundColor(isFocusSelected ? .blue : .green)
            }
                
            
            Button(action: {
                isFocusSelected ? (self.timeRemaning = Int(focusTime)) : (self.timeRemaning = Int(breakTime))
                isStarted ? (self.timeRemaning = timeRemaning / 60) :( self.timeRemaning = timeRemaning * 60)
                self.startTimer(isStarted)
                self.isStarted.toggle()
                isStarted ? WKInterfaceDevice.current().play(.start) : WKInterfaceDevice.current().play(.stop)
            }) {
                Text(isStarted ? "Stop" : "Start")
                    .font(.headline)
                    .foregroundColor(isStarted ? .red : .green)
            }
            
   
        }
    }
    
    func startTimer(_ isStarted: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if isStarted {
                Timer.invalidate()
            }
            
            if self.timeRemaning > 0 {
                self.timeRemaning -= 1
            } else {
                self.isStarted = false
                Timer.invalidate()
            }
        }
    }
    
    func displayTime(_ time: Int) -> String {
        let seconds: Int = time % 60
        let minutes: Int = (time / 60) % 60
        
        if minutes == 0 && seconds == 30 {
            WKInterfaceDevice.current().play(.notification)
        }
        
        if minutes == 0 && seconds == 0 {
            WKInterfaceDevice.current().play(.success)
        }
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
