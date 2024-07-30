//
//  ScanTask.swift
//  Sky_Mike
//
//  Created by ming on 2024/7/30.
//

import Foundation

struct ScanTask: Identifiable {
    let id: UUID
    let input: Int
    
    init(input: Int, id: UUID = UUID()) {
        self.id = id
        self.input = input
    }
    
    func run() async throws -> String {
        try await UnreliableAPI.shared.action(failingEvery: 10)
        await Task(priority: .medium) {
            Thread.sleep(forTimeInterval: 1)
        }.value
        
        return "\(input)"
    }
}
