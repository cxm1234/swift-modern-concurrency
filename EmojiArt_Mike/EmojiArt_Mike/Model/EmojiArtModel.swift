//
//  EmojiArtModel.swift
//  EmojiArt_Mike
//
//  Created by ming on 2024/7/31.
//

import Foundation

class EmojiArtModel: ObservableObject {
    @Published private(set) var imageFeed: [ImageFile] = []
    private(set) var verifiedCount = 0
    
    func verifyImages() async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            imageFeed.forEach { file in
                group.addTask { [unowned self] in
                    try await Checksum.verify(file.checksum)
                    self.verifiedCount += 1
                }
            }
            try await group.waitForAll()
        }
    }
    
    func loadImages() async throws {
        imageFeed.removeAll()
        guard let url = URL(string: "http://localhost:8080/gallery/images") else {
            throw "Could not create endpoint URL"
        }
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responded with an error."
        }
        guard let list = try? JSONDecoder().decode([ImageFile].self, from: data) else {
            throw "The server response was not recognized."
        }
        imageFeed = list
    }
    
    func downloadImage(_ image: ImageFile) async throws -> Data {
        guard let url = URL(string: "http://localhost:8080\(image.url)") else {
            throw "Could not create image URL"
        }
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responded with an error."
        }
        return data 
    }
}
