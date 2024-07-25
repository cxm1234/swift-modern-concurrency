//
//  ListView.swift
//  SuperStorage_Mike
//
//  Created by ming on 2024/7/25.
//

import SwiftUI

struct ListView: View {
    
    let model: SuperStorageModel
    @State var files: [DownloadFile] = []
    @State var status = ""
    @State var selected = DownloadFile.empty {
        didSet {
            isDisplayingDownload = true
        }
    }
    @State var isDisplayingDownload = false
    
    @State var lastErrorMessage = "None" {
        didSet {
            isDisplayingError = true
        }
    }
    
    @State var isDisplayingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: DownloadView(file: selected).environmentObject(model), isActive: $isDisplayingDownload) {
                    EmptyView()
                }.hidden()
                
                List {
                    Section(content: {
                        if files.isEmpty {
                            ProgressView().padding()
                        }
                        ForEach(files) { file in
                            Button(action: {
                                selected = file
                            }, label: {
                                FileListItem(file: file)
                            })
                        }
                    }, header: {
                        Label(" SuperStorage", systemImage: "externaldrive.badge.icloud")
                            .font(.custom("SerreriaSobria", size: 27))
                            .foregroundColor(Color.accentColor)
                            .padding(.bottom, 20)
                    }, footer: {
                        Text(status)
                    })
                }
                .listStyle(InsetGroupedListStyle())
                .animation(.easeInOut(duration: 0.33), value: files)
            }
            .alert("Error", isPresented: $isDisplayingError) {
                Button("Close", role: .cancel) {}
            } message: {
                Text(lastErrorMessage)
            }
            .task {
                guard files.isEmpty else {
                    return
                }
                
                do {
                    async let files = try model.availableFiles()
                    async let status = try model.status()
                    let (filesResult, statusResult) = try await (files, status)
                    self.files = filesResult
                    self.status = statusResult
                } catch {
                    lastErrorMessage = error.localizedDescription
                }
            }
        }
    }
    
}
