//
//  LittleJohnAppApp.swift
//  LittleJohnApp
//
//  Created by ming on 2024/7/24.
//

import SwiftUI

@main
struct LittleJohnAppApp: App {
    var body: some Scene {
        WindowGroup {
            SymbolListView(model: LittleJohnModel())
        }
    }
}
