//
//  API-1.swift
//  DakkeApp
//
//  Created by Sothesom on 18/09/1403.
//

import Foundation

class API1 {
    func search(text: String) async throws -> [String] {
        print("\(Date()) -> API searching for \(text)")
        try await Task.sleep(for: .milliseconds((400...800).randomElement()!))
        try Task.checkCancellation()
        return Self.Pep
            .filter( {$0.localizedCaseInsensitiveContains(text)})
    }
    
    static let Pep = [
    "IRAN",
    "Tehran",
    "IranVarzeshi",
    "DonyayeEqtesad",
    "Farhikhtegan",
    "Goal",
    "Ebtekar"
    ]
}
