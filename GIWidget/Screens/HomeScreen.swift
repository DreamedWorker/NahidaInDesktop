//
//  HomeScreen.swift
//  GIWidget
//
//  Created by 鸳汐 on 2024/7/23.
//

import SwiftUI

struct HomeScreen: View {
    @State private var selectedView = "groups"
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedView) {
                NavigationLink(
                    value: "groups",
                    label: { Label(
                        title: { Text("home.menu.group.manager") },
                        icon: { Image(systemName: "rectangle.3.group") }
                    )}
                )
                NavigationLink(
                    value: "sentences",
                    label: { Label(
                        title: { Text("home.menu.sentences") },
                        icon: { Image(systemName: "text.word.spacing") }
                    )}
                )
                NavigationLink(
                    value: "images",
                    label: { Label(
                        title: { Text("home.menu.images") },
                        icon: { Image(systemName: "photo.artframe") }
                    )}
                )
            }
        } detail: {
            NavigationStack {
                switch selectedView {
                case "groups":
                    GroupScreen()
                case "sentences":
                    SentenceScreen()
                case "images":
                    ImageSourceScreen()
                default:
                    Text("developing")
                }
            }
        }

    }
}

#Preview {
    HomeScreen()
}
