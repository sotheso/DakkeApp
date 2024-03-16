//
//  Home.swift
//  DakkeApp
//
//  Created by Sothesom on 24/12/1402.
//

import SwiftUI

struct Home: View {

// View Properties
    @State private var activeTab: Tab = .home
// All Tab's
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    
// View Custom
    @State private var items: [CoverFlowItem] = [ .init(image: Image("3")), .init(image: Image("4")), .init(image: Image("5")),.init(image: Image("6"))
    ]
    
    @State private var spacing: CGFloat = 0
    @State private var rotation: CGFloat = .zero
// بازتاب
    @State private var enableReflection: Bool = false
    
    var body: some View {
        VStack(spacing:0){
            TabView(selection: $activeTab){
// Your Tab views
                NavigationStack{
                    VStack{
                        CoverFlowView(spacing: spacing, rotation: rotation, enableReflection: enableReflection ,itemWidth: 280, items: items){ item in
                            ZStack {
                                    item.image
                                    .resizable()
                                    .frame(width: 280, height: 200)
                                    .scaledToFit()
                                    .clipped()
                                }
                        }
                        .frame(height: 200)
                        Spacer()
                    
// تنظیمات
                        VStack(alignment: .leading, spacing: 10, content: {
                            Toggle("Toggle Reflection", isOn: $enableReflection)
                            Slider(value: $spacing, in: -90...20)
                            Slider(value: $rotation, in: 0...90)
                        })
                    }
                    .navigationTitle(Tab.home.title)
                }
                .setUpTab(.home)
                
                NavigationStack{
                    VStack{
                        
                    }
                    .navigationTitle(Tab.category.title)
                }
                .setUpTab(.category)
                
                NavigationStack{
                    VStack{
                        
                    }
                    .navigationTitle(Tab.favourite.title)
                }
                .setUpTab(.favourite)
                
                NavigationStack{
                    VStack{
                        
                    }
                    .navigationTitle(Tab.setting.title)
                }
                .setUpTab(.setting)
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
