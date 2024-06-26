//
//  FavouriteView.swift
//  DakkeApp
//
//  Created by Sothesom on 01/01/1403.
//
import SwiftUI

struct FavouriteView: View {
    
    @State private var images: [ImageModel] = []

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(images){ image in
//                    FaiveEffect {
//                        CardiView(imageModel: image)
//                    } onDelete: {
//                        
//                    }
                }
            }
            .padding(15)
        }
        .onAppear {
            // Add images to the array when the view appears
            for index in 1...3 {
                images.append(.init(assetName: "Pic \(index)"))
            }
        }
    }
}

struct CardiView: View {
    var imageModel: ImageModel

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack {
                Image(imageModel.assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
        }
        .frame(height: 130)
        .contentShape(Rectangle())
    }
}

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView()
    }
}

struct ImageModel: Identifiable {
    var id: UUID = .init()
    var assetName: String
}
