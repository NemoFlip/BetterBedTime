//
//  ContentView.swift
//  TestProject
//
//  Created by Артем Хлопцев on 18.07.2021.
//

import SwiftUI
var defaultWakeUpTime: Date {
    var components = DateComponents()
    components.hour = 6
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
}
struct TextHeader: View {
    var text: String
    var body: some View {
        Text(text).fontWeight(.bold).textCase(nil).font(.headline)
    }
}

struct ContentView: View {
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: TextHeader(text: "When do you want to wake up?").padding(.top,20)) {
                    DatePicker("Pick a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden().fixedSize().frame(width: 325, height: 40, alignment: .center)
                }
                Section(header: TextHeader(text: "Desired amount of sleep")) {
                    Stepper("\(sleepAmount, specifier: "%g") hours", value: $sleepAmount,in: 2...12, step: 0.25)
                }
                Section(header: TextHeader(text: "How much cups of coffee would you drink?")) {
                    Picker(selection: $coffeeAmount, label: Text("\(coffeeAmount == 1 ? "\(coffeeAmount) cup": "\(coffeeAmount) cups")"), content: {
                        ForEach(0..<21) {
                            Text("\($0)")
                        }
                    })
                }
                Section(header: TextHeader(text: "Your best bedtime is...")) {
                    Text(calculateBedTime)
                }
            }
            .navigationBarTitle("Better Rest",displayMode: .inline)
        }
    }
    
    var calculateBedTime: String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            return formatter.string(from: sleepTime)
        } catch {
            return "Sorry, there is a problem"
        }
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
