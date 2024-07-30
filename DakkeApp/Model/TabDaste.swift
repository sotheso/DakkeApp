//
//  TabDaste.swift
//  DakkeApp
//
//  Created by Sothesom on 26/12/1402.
//
//
import SwiftUI
//
enum TabDaste: String, CaseIterable{
    
    case siyasi = "person.and.background.dotted"
    case varzeshi = "figure.run"
    case ejtamae = "person.3.fill"
    
    var title: String{
        switch self {
        case .siyasi:
            return "سیاسی"
        case .varzeshi:
            return "ورزشی"
        case .ejtamae:
            return "اجتماعی"
        }
    }
}
