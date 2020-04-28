//
//  ContentView.swift
//  iExpense
//
//  Created by Lance Kent Briones on 4/27/20.
//  Copyright © 2020 Lance Kent Briones. All rights reserved.
//

import SwiftUI
class Expenses: ObservableObject{
    @Published var items = [ExpenseItem](){
        didSet{
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(items){
                UserDefaults.standard.set(data, forKey: "Items")
            }
        }
    }
    
    init(){
        if let items = UserDefaults.standard.data(forKey: "Items"){
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items){
                self.items = decoded
                
                return
            }
        }
        
        self.items = []
    }
}
struct ExpenseItem: Identifiable, Codable{
    let id = UUID()      // There must be a unique id property to conform to Identifiable
    let name: String
    let type: String
    let amount: Int
}

struct ContentView: View {
    @ObservedObject private var expenses = Expenses()
    @State private var show_AddExpense: Bool = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(expenses.items) { i in          // doesn't need and id parameter since ExpenseItems
                    HStack{                             // already conforms to Identifiable
                        VStack(alignment: .leading){
                            Text(i.name)
                                .font(.headline)
                            Text(i.type)
                        }
                        
                        Spacer()
                        
                        Text("Php\(i.amount)")
                    }
                }
                .onDelete(perform: self.removeItem)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(trailing:
                Button(action: {
                    self.show_AddExpense = true
                }){
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $show_AddExpense){
                AddView(expenses: self.expenses)
            }
        }
    }
    func removeItem(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
}
