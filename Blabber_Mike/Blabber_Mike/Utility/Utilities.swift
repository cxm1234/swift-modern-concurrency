//
//  Utilities.swift
//  Blabber_Mike
//
//  Created by ming on 2024/7/29.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? {
        return self 
    }
}
