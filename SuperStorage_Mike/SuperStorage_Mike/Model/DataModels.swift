//
//  DataModels.swift
//  SuperStorage_Mike
//
//  Created by ming on 2024/7/25.
//

import Foundation

struct DownloadFile: Codable, Identifiable, Equatable {
    
    var id: String { return name }
    let name: String
    let size: Int
    let date: Date
    static let empty = DownloadFile(name: "", size: 0, date: Date())

}

struct DownloadInfo: Identifiable, Equatable {
    let id: UUID
    let name: String
    var progress: Double
}
