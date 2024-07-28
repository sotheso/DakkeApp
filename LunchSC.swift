//
//  LunchSC.swift
//  DakkeApp
//
//  Created by Sothesom on 12/04/1403.
//

import SwiftUI

struct LunchSC: View {
    
    @State private var show = false
    @State private var showHomeView = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0){
                ZStack{
                    Image("lunch2")
                        .resizable().scaledToFit()
                        .frame(width: geo.size.width)
                }
            }
        }

    }
}

#Preview {
    LunchSC()
}
