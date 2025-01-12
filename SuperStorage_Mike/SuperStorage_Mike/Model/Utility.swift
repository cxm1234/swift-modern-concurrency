//
//  Utility.swift
//  SuperStorage_Mike
//
//  Created by ming on 2024/7/25.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}

let sizeFormatter: ByteCountFormatter = {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useMB]
    formatter.isAdaptive = true
    return formatter
}()

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

extension URLRequest {
    init(url: URL, offset: Int, length: Int) {
        self.init(url: url)
        addValue("bytes=\(offset)-\(offset + length - 1)", forHTTPHeaderField: "Range")
    }
}
