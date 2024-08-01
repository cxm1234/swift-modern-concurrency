//
//  EmojiArt_MikeApp.swift
//  EmojiArt_Mike
//
//  Created by ming on 2024/7/31.
//

import SwiftUI

@main
struct EmojiArt_MikeApp: App {
    private var model = EmojiArtModel()
    @State private var isVerified = false
    var body: some Scene {
        WindowGroup {
            VStack {
                if isVerified {
                    ListView()
                        .environmentObject(ImageLoader())
                } else {
                    LoadingView(isVerified: $isVerified)
                }
            }
            .transition(.opacity)
            .animation(.linear, value: isVerified)
            .environmentObject(model)
        }
    }
}
