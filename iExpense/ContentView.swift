//
//  ContentView.swift
//  iExpense
//
//  Created by Lance Kent Briones on 4/27/20.
//  Copyright © 2020 Lance Kent Briones. All rights reserved.
//

import SwiftUI
struct User: Codable{
    var firstName: String
    var lastName: String
}
struct ContentView: View {
    @State private var user = User(firstName: "Lance", lastName: "Briones")
    var body: some View {
        Button(action: {
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(self.user){
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }){
            Text("Save User")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
}
