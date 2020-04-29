//
//  AddView.swift
//  iExpense
//
//  Created by Lance Kent Briones on 4/28/20.
//  Copyright © 2020 Lance Kent Briones. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name: String = ""
    @State private var type: String = "Personal"
    @State private var amount: String = ""
    
    @State private var show_alert: Bool = false
    
    static let types: [String] = ["Business", "Personal"]
    
    var body: some View {
        NavigationView{
            Form{
                TextField("Enter Name", text: $name)
                
                Picker("Select Type", selection: $type){
                    ForEach(Self.types, id: \.self){
                        Text($0)
                    }
                }
                TextField("Enter Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
        .navigationBarTitle("Add new expense")
        .navigationBarItems(trailing:
            Button(action: {
                if let actualAmount = Int(self.amount){
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                }
                else{
                    self.show_alert = true
                }
                
            }){
                Text("Save")
            }
        )
        .alert(isPresented: $show_alert){
            Alert(title: Text("Invalid Amount"), dismissButton: .default(Text("Continue")))
        }
            
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
