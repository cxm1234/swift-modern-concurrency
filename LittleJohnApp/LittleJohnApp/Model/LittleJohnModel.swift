//
//  LittleJohnModel.swift
//  LittleJohnApp
//
//  Created by ming on 2024/7/24.
//

import Foundation

extension String: Error {
    
}

class LittleJohnModel: ObservableObject {
    
    @Published private(set) var tickerSymbols: [Stock] = []
    
    func startTicker(_ selectedSymbols: [String]) async throws {
        await MainActor.run {
            tickerSymbols = []
        }
        guard let url = URL(string: "http://localhost:8080/littlejohn/ticker?\(selectedSymbols.joined(separator: ","))") else {
            throw "The URL could not be created"
        }
        
        let (stream, response) = try await liveURLSession.bytes(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server response with an error."
        }
        
        for try await line in stream.lines {
            let sortedSymbols = try JSONDecoder()
                .decode([Stock].self, from: Data(line.utf8))
                .sorted(by: { $0.name < $1.name})
            
            await MainActor.run {
                tickerSymbols = sortedSymbols
                print("Updated: \(Date())")
            }
            
        }
        
        await MainActor.run {
            tickerSymbols = []
        }
    }
    
    private lazy var liveURLSession: URLSession = {
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = .infinity
        return URLSession(configuration: configuration)
    }()
    
    func avaliableSymbols() async throws -> [String] {
        guard let url = URL(string: "http://localhost:8080/littlejohn/symbols") else {
            throw "The URL could not be created."
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responsed with an error"
        }
        return try JSONDecoder().decode([String].self, from: data)
    }
    
    
}
