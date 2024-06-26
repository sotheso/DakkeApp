//
//  Profile.swift
//  DakkeApp
//
//  Created by Sothesom on 04/04/1403.
//

import SwiftUI

struct Profile: Identifiable {
    var id = UUID().uuidString
    var userPapers: String
    var profilePicure: String
    var lastMsg: String
    var lastActive: String
}

// Sample DataBase
let profiles : [Profile] = [
    Profile(userPapers: "01", profilePicure:"01", lastMsg: "00", lastActive: "01"),
    Profile(userPapers: "02", profilePicure:"02", lastMsg: "00", lastActive: "01"),
    Profile(userPapers: "03", profilePicure:"03", lastMsg: "00", lastActive: "01"),
    Profile(userPapers: "04", profilePicure:"04", lastMsg: "00", lastActive: "01"),
    Profile(userPapers: "05", profilePicure:"05", lastMsg: "00", lastActive: "01"),
    Profile(userPapers: "06", profilePicure:"06", lastMsg: "00", lastActive: "01")
]


