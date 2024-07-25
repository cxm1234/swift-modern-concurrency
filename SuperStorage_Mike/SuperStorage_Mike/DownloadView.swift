//
//  DownloadView.swift
//  SuperStorage_Mike
//
//  Created by ming on 2024/7/25.
//

import SwiftUI

struct DownloadView: View {
    let file: DownloadFile
    @EnvironmentObject var model: SuperStorageModel
    @State var fileData: Data?
    @State var isDownloadActive = false
    @State var downloads: [DownloadInfo] = []
    var body: some View {
        List {
            FileDetails(
                file: file,
                isDownloading: !model.downloads.isEmpty,
                isDownloadActive: $isDownloadActive) {
                    // Download a file in a single go.
                    isDownloadActive = true
                    Task {
                        do {
                            fileData = try await model.download(file: file)
                        } catch {
                            
                        }
                        isDownloadActive = false
                    }
                } downloadWithUpdatesAction: {
                    // Download a file with UI progress updates.
                    isDownloadActive = true
                    Task {
                        do {
                            try await SuperStorageModel
                                .$supportsPartialDownloads
                                .withValue(file.name.hasSuffix(".jpeg")) {
                                    fileData = try await model.downloadWithProgress(file: file)
                                }
                        } catch {}
                        isDownloadActive = false 
                    }
                } downloadWithMultipleAction: {
                    // Download a file in multiple concurrent parts.
                }
            if !model.downloads.isEmpty {
                Downloads(downloads: downloads)
            }
            if let fileData = fileData {
                FilePreview(fileData: fileData)
            }
        }
        .animation(.easeOut(duration: 0.33), value: model.downloads)
        .listStyle(InsetGroupedListStyle())
        .toolbar(content: {
            Button(action: {}, label: {
                Text("Cancel All")
            })
            .disabled(downloads.isEmpty)
        })
        .onDisappear(perform: {
            fileData = nil
            model.reset()
        })
        .onChange(of: model.downloads) { oldValue, newValue in
            downloads = newValue
        }
    }
}
