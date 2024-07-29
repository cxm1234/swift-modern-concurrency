//
//  LoginView.swift
//  Blabber_Mike
//
//  Created by ming on 2024/7/27.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("username") var username = ""
    @State var isDisplayingChat = false
    @State var model = BlabberModel()
    var body: some View {
        VStack {
            Text("Blabber")
                .font(.custom("Lemon", size: 48))
                .foregroundColor(Color.teal)
            
            HStack {
                TextField(text: $username, prompt: Text("Username")) {}
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    model.username = username
                    self.isDisplayingChat = true
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title)
                        .foregroundColor(Color.teal)
                }
                .sheet(isPresented: $isDisplayingChat, onDismiss: {}) {
                    ChatView(model: model)
                }
            }
            .padding(.horizontal)
        }
        .statusBarHidden(true)
    }
}

#Preview {
    LoginView()
}
