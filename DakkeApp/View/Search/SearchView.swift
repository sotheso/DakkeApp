//
//  SearchView.swift
//  DakkeApp
//
//  Created by Sothesom on 29/01/1403.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SearchView: View {
    @State private var heroes = ["01", "02","03","04", "05", "06"]
    @State private var searchTerm = ""
                                                     
    var filteredHeroes: [String] {
        guard !searchTerm.isEmpty else { return heroes }
        return heroes.filter { $0.localizedCaseInsensitiveContains (searchTerm) }
    }
                
    @AppStorage("log_status") private var logStatus: Bool = false

    @Binding var selectedProfile: Profile?
    @Binding var pushView: Bool
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(profiles){ profile in
                    Button(action: {
                        selectedProfile = profile
                        pushView.toggle()
                    },label:{
                        HStack(spacing: 15){
                            Color.clear
                                .frame(width: 60, height: 60)
                            // Source View Anchor
                                .anchorPreference(key: MAnchorKey.self, value: .bounds, transform: { anchor in
                                    return [profile.id: anchor]
                                })
                            
                            VStack(alignment: .leading, spacing: 2, content: {
                                Text(profile.userPapers)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                Text(profile.lastMsg)
                                    .font(.callout)
                                    .textScale(.secondary)
                                    .foregroundStyle(.orange)
                            })
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text(profile.lastActive)
                                .font(.caption)
                                .foregroundStyle(.gray)
                            
                            
                        }
                        .contentShape(.rect)

                    })
                }
            }
            .searchable (text: $searchTerm)

            Button("Logout"){
                try? Auth.auth().signOut()
                logStatus = false
            }
        }
        .overlayPreferenceValue(MAnchorKey.self, { value in
            GeometryReader ( content: {geometry in
                ForEach(profiles) { profile in
                    if let anchor = value[profile.id], selectedProfile?.id != profile.id {
                        let rect = geometry[anchor]
                        ImageView(profile: profile, size: rect.size)
                            .offset(x: rect.minX, y: rect.minY)
                            .allowsTightening(false)
                    }
                }
            })
        })
    }
}

// DatailView
struct DatailView: View {
    @Binding var selectedProfile: Profile?
    @Binding var pushView: Bool
    @Binding var hideView: (Bool, Bool)
    
    var body: some View {
        if let selectedProfile = selectedProfile {
            VStack {
                GeometryReader { geometry in
                    let size = geometry.size
                    
                    VStack{
                        if hideView.0 {
                            ImageView(profile: selectedProfile, size: size)
                                // Custom close buttem
                                .overlay(alignment: .top){
                                    ZStack{
                                        Button(action: {
                                            // closing the view with animation
                                            hideView.0 = false
                                            hideView.1 = false
                                            pushView = false
                                            // Average Navigation pop taje 0.35s that's the reason set the animaion duration as 0.35s after the is popped out, making selectedProfile to nil
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ){
                                                self.selectedProfile = nil
                                                
                                            }
                                        }, label: {
                                            Image(systemName: "xmark")
                                                .foregroundStyle(.white)
                                                .padding(10)
                                                .background(.black, in: .circle)
                                                .contentShape(.circle)
                                        })
                                        .padding(15)
                                        .padding(.top, 40)
                                    }
                                    .opacity(hideView.1 ? 1:0)
                                    .animation(.snappy, value: hideView.1)
                                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .topTrailing)

                                    Text(selectedProfile.userPapers)
                                        .font(.title.bold())
                                        .foregroundStyle(.black)
                                        .padding(15)
                                        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomLeading)
                                }
                                .onAppear(perform: {
                                    // Removing the Animated View once the Animation is finished
                                    DispatchQueue.main.asyncAfter(deadline: .now()){
                                        hideView.1 = true
                                    }
                                })
                        } else{
                            Color.clear
                        }
                    }
                    // destination View anthor
                    .anchorPreference(key: MAnchorKey.self, value: .bounds)
                        { anchor in
                        return [selectedProfile.id: anchor]
                        }
                }
                .frame(height: 400)
                .ignoresSafeArea()
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
            .toolbar(hideView.0 ? .hidden: .visible, for: .navigationBar)
            .onAppear(perform: {
                // Removing the Animated View once the Animation is finished
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    hideView.0 = true
                }
            })
        }
    }
}

struct ImageView: View {
    var profile: Profile
    var size: CGSize
    var body: some View {
        Image(profile.profilePicure)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
        // linear gradient at bottom
            .overlay(content:{
                LinearGradient(colors: [
                    .clear, .clear, .clear, .clear, .white.opacity(0.1), .white.opacity(0.5), .white.opacity(0.9), .white
                ], startPoint: .top, endPoint: .bottom)
                .opacity(size.width > 60 ? 1 : 0)
            })
            .clipShape(.rect(cornerRadius: size.width > 60 ? 0 : 30))
    }
}

#Preview {
    SearchView(selectedProfile: .constant(nil), pushView: .constant(false))
}
