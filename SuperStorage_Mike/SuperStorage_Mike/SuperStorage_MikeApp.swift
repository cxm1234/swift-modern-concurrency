//
//  SuperStorage_MikeApp.swift
//  SuperStorage_Mike
//
//  Created by ming on 2024/7/25.
//

import SwiftUI

@main
struct SuperStorage_MikeApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(model: SuperStorageModel())
        }
    }
}
