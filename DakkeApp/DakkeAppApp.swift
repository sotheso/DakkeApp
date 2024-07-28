//
//  DakkeAppApp.swift
//  DakkeApp
//
//  Created by Sothesom on 24/12/1402.
//

import SwiftUI
import Firebase

@main
struct DakkeAppApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
