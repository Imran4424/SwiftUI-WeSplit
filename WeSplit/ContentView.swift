//
//  ContentView.swift
//  WeSplit
//
//  Created by Shah Md Imran Hossain on 28/3/23.
//

import SwiftUI

struct ContentView: View {
    // by default struct property in not editable
    // @State is making the property editable
    // @State variable also updates the views which are using them
    // @State is designed for simple properties which stays in one view
    // always make sure to use private for consistency
    @State private var checkAmout = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    // @FocusState -
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        // plus 2 because number of people indicate the index not real value
        // there is always 2 gap because picker start with 2
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = tipPercentage
        // if user selects 0 it all zero, skipping that
        let tipFraction = 100 * tipSelection == 0 ? 1 : (100 * tipPercentage)
        
        let tipValue = checkAmout / Double(tipFraction)
        let grandTotal = checkAmout + tipValue
        let amountPerson = grandTotal / peopleCount
        
        return amountPerson
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // $ - working as a bidirectional biniding operator
                    // 1 - read the value from name
                    // 2 - also update name while user the name TextField
                    // only $ sign will error, cause in text field swift expects only string
                    // we can solve this issue adding a third parameter named format
                    TextField("Amount", value: $checkAmout, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad) // modifier for keyboard type for text field
                        .focused($amountIsFocused) // making the keyboard focused
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            // $0 - indicates every element
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented) // modifier for picker style
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                } header: {
                    Text("Total payable per person")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    // blank view
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            } // adding done button above keyboard with the help of toolba
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
