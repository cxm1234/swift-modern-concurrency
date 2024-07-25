//
//  SymbolListView.swift
//  LittleJohnApp
//
//  Created by ming on 2024/7/24.
//

import SwiftUI

struct SymbolListView: View {
    let model: LittleJohnModel
    @State var symbols: [String] = []
    @State var selected: Set<String> = []
    @State var lastErrorMessage = "" {
        didSet { isDisplayingError = true }
    }
    @State var isDisplayingError = false
    @State var isDisplayingTicker = false
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: TickerView(selectedSymbols: Array($selected.wrappedValue).sorted()).environmentObject(model), 
                    isActive: $isDisplayingTicker,
                    label: {
                        EmptyView()
                    }).hidden()

                
                List {
                    Section {
                        if symbols.isEmpty {
                            ProgressView().padding()
                        }
                        ForEach(symbols, id: \.self) { symbolName in
                            SymbolRow(symbolName: symbolName, selected: $selected)
                        }
                        .font(.custom("FantasqueSansMono-Regular", size: 18))
                    } header: {
                        Header.init()
                    }
                }
                .listStyle(PlainListStyle())
                .statusBarHidden(true)
                .toolbar {
                    Button("Live ticker") {
                        if !selected.isEmpty {
                            isDisplayingTicker = true
                        }
                    }
                    .disabled(selected.isEmpty)
                }
                .alert("Error", isPresented: $isDisplayingError) {
                    Button("Close", role: .cancel) {}
                } message: {
                    Text(lastErrorMessage)
                }
                .padding(.horizontal)
                .task {
                    guard symbols.isEmpty else {
                        return
                    }
                    do {
                        symbols = try await model.avaliableSymbols()
                    } catch {
                        lastErrorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}
