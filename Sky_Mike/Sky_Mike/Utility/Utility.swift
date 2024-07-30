//
//  Utility.swift
//  Sky_Mike
//
//  Created by ming on 2024/7/30.
//

import Foundation

actor UnreliableAPI {
    struct Error: LocalizedError {
        var errorDescription: String? {
            return "UnreliableAPI.action(failingEvery:) failed."
        }
    }
    
    static let shared = UnreliableAPI()
    
    var counter = 0
    
    func action(failingEvery: Int) throws {
        counter += 1
        if counter % failingEvery == 0 {
            counter = 0
            throw Error()
        }
    }
}
