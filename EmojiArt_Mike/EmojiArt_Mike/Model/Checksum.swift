//
//  Checksum.swift
//  EmojiArt_Mike
//
//  Created by ming on 2024/7/31.
//

import Foundation

enum Checksum {
    static var cnt = 0
    static func verify(_ checksum: String) async throws {
        let duration = Double.random(in: 0.5...2.5)
        try await Task.sleep(for: .seconds(duration))
    }
}
