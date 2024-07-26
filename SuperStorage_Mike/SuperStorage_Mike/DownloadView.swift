//
//  DownloadView.swift
//  SuperStorage_Mike
//
//  Created by ming on 2024/7/25.
//

import SwiftUI
import Combine

struct DownloadView: View {
    let file: DownloadFile
    @EnvironmentObject var model: SuperStorageModel
    @State var fileData: Data?
    @State var isDownloadActive = false {
        didSet {
            if !isDownloadActive {
                timerTask?.cancel()
            }
        }
    }
    @State var duration = ""
    @State var downloadTask: Task<Void, Error>? {
        didSet {
            timerTask?.cancel()
            guard isDownloadActive else { return }
            let startTime = Date().timeIntervalSince1970
            let timerSequence = Timer
                .publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .map { date -> String in
                    let duration = Int(date.timeIntervalSince1970 - startTime)
                    return "\(duration)s"
                }
                .values
            timerTask = Task {
                for await duration in timerSequence {
                    self.duration = duration
                }
            }
        }
    }
    @State var timerTask: Task<Void, Error>?
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
                    downloadTask = Task {
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
                    isDownloadActive = true
                    Task {
                        do {
                            fileData = try await model.multiDownloadWithProgress(file: file)
                        } catch {}
                        isDownloadActive = false
                    }
                }
            if !model.downloads.isEmpty {
                Downloads(downloads: model.downloads)
            }
            
            if !duration.isEmpty {
                Text("Duration: \(duration)")
                    .font(.caption)
            }
            
            if let fileData = fileData {
                FilePreview(fileData: fileData)
            }
        }
        .animation(.easeOut(duration: 0.33), value: model.downloads)
        .listStyle(InsetGroupedListStyle())
        .toolbar(content: {
            Button(action: {
                model.stopDownloads = true 
                timerTask?.cancel()
            }, label: {
                Text("Cancel All")
            })
            .disabled(model.downloads.isEmpty)
        })
        .onDisappear(perform: {
            fileData = nil
            model.reset()
            downloadTask?.cancel()
        })
    }
}
