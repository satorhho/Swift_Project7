//
//  ContentView.swift
//  iExpense
//
//  Created by Lance Kent Briones on 4/27/20.
//  Copyright © 2020 Lance Kent Briones. All rights reserved.
//

import SwiftUI
struct BelowTenStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.green)
    }
}
struct BelowHundredStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.gray)
    }
}
struct OverHundredStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.red)
    }
}
extension View {
    func belowTenStyle() -> some View {
        self.modifier(BelowTenStyle())
    }
    func belowHundredStyle() -> some View {
        self.modifier(BelowHundredStyle())
    }
    func overHundredStyle() -> some View {
        self.modifier(OverHundredStyle())
    }
    func amount_modier(item: ExpenseItem) -> some View {
        switch item.amount {
        case 0..<10:
            return AnyView(Text("\(item.amount)").belowTenStyle())
        case 10..<100:
            return AnyView(Text("\(item.amount)").belowHundredStyle())
        default:
            return AnyView(Text("\(item.amount)").overHundredStyle())
        }
    }
}
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
                        
                        self.amount_modier(item: i)
                    }
                }
                .onDelete(perform: self.removeItem)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    self.show_AddExpense = true
                    
                }){
                    Image(systemName: "plus")
                    
            })
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
