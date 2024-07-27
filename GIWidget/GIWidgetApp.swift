//
//  GIWidgetApp.swift
//  GIWidget
//
//  Created by 鸳汐 on 2024/7/23.
//

import SwiftUI

@main
struct GIWidgetApp: App {
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environment(\.locale, .init(identifier: "zh-Hans"))
        }
    }
}
