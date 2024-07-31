//
//  DetailsView.swift
//  EmojiArt_Mike
//
//  Created by ming on 2024/7/31.
//

import SwiftUI

struct DetailsView: View {
    let file: ImageFile
    @State var image: UIImage?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Text("No preview available")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
                    .background(Color(.sRGB, white: 0.2, opacity: 1))
            }
            VStack(alignment: .center) {
                Text(file.name)
                    .font(.custom("YoungSerif-Regular", size: 28))
                
                Text(String(format: "$%.2f", file.price))
                    .font(.custom("YoungSerif-Regular", size: 21))
                    .background(.pink)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 40)
            .clipped()
        }
        .ignoresSafeArea()
        .foregroundColor(.white)
    }
}

