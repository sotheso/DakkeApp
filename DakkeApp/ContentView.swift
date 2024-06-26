//
//  ContentView.swift
//  DakkeApp
//
//  Created by Sothesom on 24/12/1402.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @AppStorage("log_status") private var logStatus: Bool = false

    var body: some View {
        if logStatus{
            Home()
        } else {
            Login()
        }
    }
}

#Preview {
    ContentView()
}
