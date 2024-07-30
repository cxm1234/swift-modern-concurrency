//
//  ScanModel.swift
//  Sky_Mike
//
//  Created by ming on 2024/7/30.
//

import Foundation

class ScanModel: ObservableObject {
    private var counted = 0
    private var started = Date()
    
    @MainActor @Published var scheduled = 0
    @MainActor @Published var countPerSecond: Double = 0
    
    @MainActor @Published var completed = 0
    
    @Published var total: Int
    
    @MainActor @Published var isCollaborating = false
    
    init(total: Int, localName: String) {
        self.total = total
    }
    
    func runAllTasks() async throws {
        started = Date()
        try await withThrowingTaskGroup(of: Result<String, Error>.self) { [unowned self] group in
            let batchSize = 4
            for index in 0..<batchSize {
                group.addTask {
                    await self.worker(number: index)
                }
            }
            var index = batchSize
            for try await result in group {
                switch result {
                case .success(let result):
                    print("Completed: \(result)")
                case .failure(let error):
                    print("Failed: \(error.localizedDescription)")
                }
                if index < total {
                    group.addTask { [index] in
                        await self.worker(number: index)
                    }
                    index += 1
                }
            }
            
            await MainActor.run {
                completed = 0
                countPerSecond = 0
                scheduled = 0
            }
        }
    }
    
    func worker(number: Int) async -> Result<String, Error> {
        await onScheduled()
        let task = ScanTask(input: number)
        let result: String
        do {
            result = try await task.run()
        } catch {
            return .failure(error)
        }
        await onTaskCompleted()
        return .success(result)
    }
}

extension ScanModel {
    @MainActor
    private func onTaskCompleted() {
        completed += 1
        counted += 1
        scheduled -= 1
        
        countPerSecond = Double(counted) / Date().timeIntervalSince(started)
    }
    
    @MainActor
    private func onScheduled() {
        scheduled += 1
    }
}
