//
//  SuperStorageModel.swift
//  SuperStorage_Mike
//
//  Created by ming on 2024/7/25.
//

import Foundation

class SuperStorageModel: ObservableObject {
    
    @Published var downloads: [DownloadInfo] = []
    @TaskLocal static var supportsPartialDownloads = false
    
    func download(file: DownloadFile) async throws -> Data {
        guard let url = URL(string: "http://localhost:8080/files/download?\(file.name)") else {
            throw "Could not create the URL."
        }
        await addDownload(name: file.name)
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        await updateDownload(name: file.name, progress: 1.0)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responsed with an error."
        }
        
        return data
    }
    
    func downloadWithProgress(file: DownloadFile) async throws -> Data {
        return try await downloadWithProgress(fileName: file.name, name: file.name, size: file.size)
    }
    
    private func downloadWithProgress(fileName: String, name: String, size: Int, offset: Int? = nil) async throws -> Data {
        guard let url = URL(string: "http://localhost:8080/files/download?\(fileName)") else {
            throw "Could not create the URL."
        }
        await addDownload(name: name)
        let result: (downloadStream: URLSession.AsyncBytes, response: URLResponse)
        if let offset = offset {
            let urlRequest = URLRequest(url: url, offset: offset, length: size)
            result = try await URLSession.shared.bytes(for: urlRequest, delegate: nil)
            guard (result.response as? HTTPURLResponse)?.statusCode == 206 else {
                throw "The server responded whth an error."
            }
        } else {
            result = try await URLSession.shared.bytes(from: url, delegate: nil)
            guard (result.response as? HTTPURLResponse)?.statusCode == 200 else {
                throw "The server responded with an error."
            }
        }
        var asyncDownloadIterator = result.downloadStream.makeAsyncIterator()
        var accumulator = ByteAccumulator(name: name, size: size)
        while await !stopDownloads, !accumulator.checkCompleted() {
            while !accumulator.isBatchCompleted, 
                    let byte = try await asyncDownloadIterator.next() {
                accumulator.append(byte)
            }
            let progress = accumulator.progress
            print("progress \(progress)")
            Task.detached(priority: .medium) { [weak self] in
                await self?.updateDownload(name:name, progress: progress)
            }
            print(accumulator.description)
        }
        
        return accumulator.data
    }
    
    func availableFiles() async throws -> [DownloadFile] {
        guard let url = URL(string: "http://localhost:8080/files/list") else {
            throw "Could not create the URL."
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responsed with an error."
        }
        guard let list = try? JSONDecoder()
            .decode([DownloadFile].self, from: data) else {
            throw "The server response was not recognized."
        }
        return list
    }
    
    func status() async throws -> String {
        guard let url = URL(string: "http://localhost:8080/files/status") else {
            throw "Could not create the URL"
        }
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responsed with an error"
        }
        
        return String(decoding: data, as: UTF8.self)
    }
    
    @MainActor var stopDownloads = false
    
    @MainActor
    func reset() {
        stopDownloads = false
        downloads.removeAll()
    }
    
}

extension SuperStorageModel {
    @MainActor
    func addDownload(name: String) {
        let downloadInfo = DownloadInfo(id: UUID(), name: name, progress: 0.0)
        downloads.append(downloadInfo)
    }
    @MainActor
    func updateDownload(name: String, progress: Double) {
        if let index = downloads.firstIndex(where: { $0.name == name }) {
            print("updateDownload \(name) progress: \(progress)")
            var info = downloads[index]
            info.progress = progress
            downloads[index] = info
        }
    }
}
