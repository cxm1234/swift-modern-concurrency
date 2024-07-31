//
//  LoadingView.swift
//  EmojiArt_Mike
//
//  Created by ming on 2024/7/31.
//

import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var model: EmojiArtModel
    @State var lastErrorMessage = "None" {
        didSet {
            isDisplayingError = true
        }
    }
    @State var isDisplayingError = false
    @State var progress = 0.0
    
    @Binding var isVerified: Bool
    
    let timer = Timer.publish(every: 0.2, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        VStack(spacing: 4) {
            ProgressView("Verifying feed", value: progress)
                .tint(.gray)
                .font(.subheadline)
            
            if !model.imageFeed.isEmpty {
                Text("\(Int(progress * 100))%")
                    .fontWeight(.bold)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 20)
        .task {
            guard model.imageFeed.isEmpty else { return }
            Task {
                do {
                    try await model.loadImages()
                } catch {
                    lastErrorMessage = error.localizedDescription
                }
            }
        }
        .alert("Error", isPresented: $isDisplayingError) {
            Button("Close", role: .cancel) {}
        } message: {
            Text(lastErrorMessage)
        }
    }
}
