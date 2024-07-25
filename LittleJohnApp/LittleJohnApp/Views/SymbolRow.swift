//
//  SymbolRow.swift
//  LittleJohnApp
//
//  Created by ming on 2024/7/24.
//

import SwiftUI

struct SymbolRow: View {
    let symbolName: String
    @Binding var selected: Set<String>
    
    var body: some View {
        Button {
            if !selected.insert(symbolName).inserted {
                selected.remove(symbolName)
            }
        } label: {
            HStack {
                HStack {
                    if selected.contains(symbolName) {
                        Image(systemName: "checkmark")
                    }
                }
                .frame(width: 20)
                Text(symbolName)
                    .fontWeight(.bold)
            }
        }

    }
}
