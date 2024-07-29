//
//  ProfileView.swift
//  DakkeApp
//
//  Created by Sothesom on 06/05/1403.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var isProfileExpanded = false
    @Namespace private var profileAnimation
    
    var body: some View {
        ScrollView{
            VStack{
                if isProfileExpanded {
                    expanddedProfileView
                } else {
                    collapadProfileView
                }
                ImagePaper
            }
        }
    }
    
    // Collapad Profile View
    var collapadProfileView: some View{
        HStack{
            profileImage
                .matchedGeometryEffect(id: "Profile", in: profileAnimation)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, content: {
                Text("Gool")
                    .font(.title).bold()
                    .matchedGeometryEffect(id: "Name", in: profileAnimation)
                
                Text("روزنامه ورزشی")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .matchedGeometryEffect(id: "Category", in: profileAnimation)

            })
            .padding(.leading)
            Spacer()
                
        }
        .padding()
    }
    
    // Now we creat view for Expanded Profile
    var expanddedProfileView: some View{
        VStack{
            profileImage
                .matchedGeometryEffect(id: "Profile", in: profileAnimation)
                .frame(width: 130, height: 130)
            
            VStack(spacing: 10){
                Text("Gool")
                    .font(.title).bold()
                    .matchedGeometryEffect(id: "Name", in: profileAnimation)
                
                Text("ورزشی")
                    .foregroundStyle(.secondary)
                    .matchedGeometryEffect(id: "Category", in: profileAnimation)
                
                Text("گل یک روزنامه معتبر ورزشی است که در حوزه تخصصی ورزش و خصوصا فوتبال فعالیت دارد.")
                    .foregroundStyle(.secondary)

                
            }
        }
        .padding()
    }
    
    // we use multiple places profile image so we creat var of profile image. so its easy to maintian and understand
    var profileImage: some View{
        Image("06")
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .onTapGesture {
                withAnimation(.spring()){
                    isProfileExpanded.toggle()
                }
            }
    }
    
    // Now we need to add image
    var ImagePaper: some View{
        VStack{
            ForEach(0..<6){ item in
                VStack{
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 250)
                .background(.gray.opacity(0.3))
                .clipShape(.rect(cornerRadius: 14))
                .padding()
            }
        }
    }
}

#Preview {
    ProfileView()
}
