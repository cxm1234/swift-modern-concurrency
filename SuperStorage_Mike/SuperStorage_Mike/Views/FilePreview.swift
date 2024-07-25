//
//  FilePreview.swift
//  SuperStorage_Mike
//
//  Created by ming on 2024/7/25.
//

import SwiftUI

struct FilePreview: View {
    let fileData: Data
    var body: some View {
        Section("Preview") {
            VStack(alignment: .center, content: {
                if let image = UIImage(data: fileData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 200)
                        .cornerRadius(10)
                } else {
                    Text("No preview")
                }
            })
        }
    }
}
