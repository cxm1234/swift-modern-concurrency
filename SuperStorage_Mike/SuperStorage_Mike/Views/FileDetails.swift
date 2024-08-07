//
//  FileDetails.swift
//  SuperStorage_Mike
//
//  Created by ming on 2024/7/25.
import SwiftUI

struct FileDetails: View {
    let file: DownloadFile
    let isDownloading: Bool
    
    @Binding var isDownloadActive: Bool
    let downloadSingleAction: () -> Void
    let downloadWithUpdatesAction: () -> Void
    let downloadWithMultipleAction: () -> Void
    
    var body: some View {
        Section {
            VStack(alignment: .leading, content: {
                HStack(spacing: 8) {
                    if isDownloadActive {
                        ProgressView()
                    }
                    Text(file.name)
                        .font(.title3)
                }
                .padding(.leading, 8)
                Text(sizeFormatter.string(fromByteCount: Int64(file.size)))
                    .font(.body)
                    .foregroundColor(Color.indigo)
                    .padding(.leading, 8)
                if !isDownloading {
                    HStack {
                        Button(action: downloadSingleAction) {
                            Image(systemName: "arrow.down.app")
                            Text("Silver")
                        }
                        .tint(Color.teal)
                        Button(action: downloadWithUpdatesAction) {
                            Image(systemName: "arrow.down.app.fill")
                            Text("Gold")
                        }
                        .tint(Color.pink)
                        Button(action: downloadWithMultipleAction) {
                            Image(systemName: "dial.max.fill")
                            Text("Cloud 9")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.purple)
                    }
                    .buttonStyle(.bordered)
                    .font(.subheadline)
                }
            })
        } header: {
            Label(" Download", systemImage: "arrow.down.app")
                .font(.custom("SerreriaSobria", size: 27))
                .foregroundColor(Color.accentColor)
                .padding(.bottom, 20)
        }
    }
}
