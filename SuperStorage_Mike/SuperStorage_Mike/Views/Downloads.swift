//
//  Downloads.swift
//  SuperStorage_Mike
//
//  Created by ming on 2024/7/25.
//

import SwiftUI

struct Downloads: View {
    let downloads: [DownloadInfo]
    
    var body: some View {
        ForEach(downloads) { download in
            VStack(alignment: .leading, content: {
                Text(download.name).font(.caption)
                ProgressView(value: download.progress)
            })
        }
    }
}
