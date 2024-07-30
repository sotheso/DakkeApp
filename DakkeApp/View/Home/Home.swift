//
//  Home.swift
//  DakkeApp
//
//  Created by Sothesom on 24/12/1402.
//

import SwiftUI
import Firebase
 
struct Home: View {

// View Properties
    @State private var activeTab: Tab = .home
// All Tab's
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }

    @State private var selectedProfile: Profile?
    @State private var pushView: Bool = false
    // For back buttem in search page DatailView
    @State private var hideView: (Bool, Bool) = (false, false)
    
    var body: some View {
        
        VStack(spacing:0){
            TabView(selection: $activeTab){
// Your Tab views
// خانه
                NavigationStack{
// بنر اول
                    BanereAval()
                        .navigationTitle(Tab.home.title)
                        .background(Color.gray.opacity(0.2))
                    
                    CardView()
                    Spacer()
                }
                .setUpTab(.home)
                
                NavigationStack{
                    VStack{
                        DasteBandi()
                        .background(Color.gray.opacity(0.2))
                    }
                }
                .setUpTab(.category)
                
                NavigationStack{
                    VStack{
                        ContentView2()
                    }
                    .navigationTitle(Tab.favourite.title)
                }
                .setUpTab(.favourite)
                
                NavigationStack{
                    VStack{
                        SearchView(selectedProfile: $selectedProfile, pushView: $pushView)
                            .navigationDestination(isPresented: $pushView){
                                DatailView(selectedProfile: $selectedProfile, pushView: $pushView, hideView: $hideView
                                )
                        }
                    }
                    .navigationTitle("Search")
                }
                .overlayPreferenceValue(MAnchorKey.self, { value in
                    GeometryReader ( content: {geometry in
                        if let selectedProfile, let anchor = value[selectedProfile.id], !hideView.0 {
                            let rect = geometry[anchor]
                            ImageView(profile: selectedProfile, size: rect.size)
                                .offset(x: rect.minX, y: rect.minY)
                                .animation(.snappy(duration: 0.35, extraBounce: 0),value: rect)
                        }
                    })
                })
                .setUpTab(.search)

            }
            CustomTabBar()
        }

    }
    
// Custom Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View{
        HStack(spacing: 0){
            ForEach($allTabs){ $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4){
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                        .symbolEffect(.bounce.up.byLayer, value: animatedTab.isAnimating)
                    
                    
                    Text(tab.title)
                        .font(.caption)
                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(activeTab == tab ? Color.primary: Color.gray.opacity(0.8))
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
// You can also use button, if you choose to
                .onTapGesture {
// انیمیت کردن
                    withAnimation(.bouncy ,completionCriteria: .logicallyComplete, {
                        activeTab = tab
                        animatedTab.isAnimating = true
                    }, completion: {
// برای اینکه دوباره انیمیت نشه
                        var trasnction = Transaction()
                        trasnction.disablesAnimations = true
                        withTransaction(trasnction){
                            animatedTab.isAnimating = nil
                        }
                    })
                    activeTab = tab
                }
            }
        }
        .background(.bar)
    }
}

#Preview {
    ContentView()
}


// ویوی هر تب
extension View{
    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View{
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
