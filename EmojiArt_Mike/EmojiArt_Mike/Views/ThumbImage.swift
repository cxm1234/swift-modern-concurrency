//
//  ThumbImage.swift
//  EmojiArt_Mike
//
//  Created by ming on 2024/7/31.
//

import SwiftUI

struct ThumbImage: View {
    let file: ImageFile
    @State var image = UIImage()
    @State var overlay = ""
    
    @MainActor func updateImage(_ image: UIImage) {
        self.image = image
    }
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .foregroundColor(.gray)
            .overlay {
                if !overlay.isEmpty {
                    Image(systemName: overlay)
                }
            }
    }
}
