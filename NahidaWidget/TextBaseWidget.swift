//
//  TextBaseWidget.swift
//  NahidaWidgetExtension
//
//  Created by 鸳汐 on 2024/7/13.
//

import Foundation
import SwiftUI
import WidgetKit
import AppIntents

struct TextBasedWidgetConfiguration: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "图文小组件配置"
    static var description: IntentDescription = IntentDescription("配置要展示的图片与文本")
    
    @Parameter(title: "标题", default: "Nahida")
    var showingTitle: String
    
    @Parameter(title: "采用内置资源", default: true)
    var useInnerImg: Bool
}

struct TextBasedWidgetEntry : TimelineEntry {
    var date: Date
    let config: TextBasedWidgetConfiguration
    var showing: String
}

struct TextBaseWidgetProvider: AppIntentTimelineProvider {
    func timeline(for configuration: TextBasedWidgetConfiguration, in context: Context) async -> Timeline<TextBasedWidgetEntry> {
        var enties: [TextBasedWidgetEntry] = []
        let entry = TextBasedWidgetEntry(date: Date(), config: configuration, showing: "new Demo")
        enties.append(entry)
        return Timeline(entries: enties, policy: .atEnd)
    }
    
    func placeholder(in context: Context) -> TextBasedWidgetEntry {
        TextBasedWidgetEntry(date: Date(), config: TextBasedWidgetConfiguration(), showing: "Demo")
    }
    
    func snapshot(for configuration: TextBasedWidgetConfiguration, in context: Context) async -> TextBasedWidgetEntry {
        TextBasedWidgetEntry(date: Date(), config: configuration, showing: "Demo")
    }
}

struct TextBasedWidgetView : View {
    var entry : TextBaseWidgetProvider.Entry
    
    var body: some View {
        VStack {
            Image("1", label: Text("Nihida")).resizable().scaledToFit().clipShape(Circle())
            Text(entry.config.showingTitle)
            Text(entry.showing)
            if entry.config.useInnerImg {
                Text("我使用来自自带的图片")
            } else {
                Text("期待用户添加新的图片")
            }
        }
    }
}

struct TextBasedWidget : Widget {
    let kind: String = "TextBasedWidget"
    
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: TextBasedWidgetProvider()){ entry in
//            if #available(macOS 14.0, *){
//                TextBasedWidgetView(entry: entry).containerBackground(.fill.secondary, for: .widget)
//            } else {
//                TextBasedWidgetView(entry: entry).padding().background()
//            }
//        }
//        .configurationDisplayName("文本型控件")
//        .description("展示静态文本与图片")
//        .supportedFamilies([.systemSmall])
//    }
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: TextBasedWidgetConfiguration.self, provider: TextBaseWidgetProvider()){ entry in
            TextBasedWidgetView(entry: entry)
                .containerBackground(.fill.secondary, for: .widget)
        }
        .configurationDisplayName("文本型控件")
        .description("展示静态文本与图片")
        .supportedFamilies([.systemSmall])
    }
}

