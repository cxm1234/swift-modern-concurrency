//
//  Header.swift
//  LittleJohnApp
//
//  Created by ming on 2024/7/24.
//

import SwiftUI

struct Header: View {
    var body: some View {
        Label(" LittleJohn", systemImage: "chart.bar.xaxis")
            .foregroundColor(Color(uiColor: .systemGreen))
            .font(.custom("FantasqueSansMono-Regular", size: 34))
            .padding(.bottom, 20)
    }
}
