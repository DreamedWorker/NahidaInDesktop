//
//  TextWithImageWidget.swift
//  DesktopWidgetsExtension
//
//  Created by 鸳汐 on 2024/7/27.
//

import Foundation
import WidgetKit
import SwiftUI
import AppIntents

struct TextWithImageConfig : WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "图文小组件配置"
    static var description: IntentDescription = IntentDescription("配置要展示的图片和文本")
    
    @Parameter(title: "使用默认配置", default: true)
    var useDefault: Bool
    
    @Parameter(title: "本地资源名", description: "只有在关闭“使用默认资源”时才生效", default: "")
    var localImg: String
    
    @Parameter(title: "语句", description: "只有在关闭“使用默认资源”时才生效", default: "")
    var sentence: String
}

struct TextWithImageEntry : TimelineEntry {
    var date: Date
    let config: TextWithImageConfig
}

struct TextWithImageProvider : AppIntentTimelineProvider {
    func snapshot(for configuration: TextWithImageConfig, in context: Context) async -> TextWithImageEntry {
        TextWithImageEntry(date: Date(), config: configuration)
    }
    
    func placeholder(in context: Context) -> TextWithImageEntry {
        TextWithImageEntry(date: Date(), config: TextWithImageConfig())
    }
    
    func timeline(for configuration: TextWithImageConfig, in context: Context) async -> Timeline<TextWithImageEntry> {
        var entities: [TextWithImageEntry] = []
        let entry = TextWithImageEntry(date: Date(), config: configuration)
        entities.append(entry)
        return Timeline(entries: entities, policy: .atEnd)
    }
}

struct TextWithImageView : View {
    var entry: TextWithImageProvider.Entry
    
    var body: some View {
        VStack {
            if entry.config.useDefault {
                Image("nahida_avatar").resizable()
            } else {
                let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.org.giwidget.yuanshine")!
                    .appending(component: "images")
                    .path().removingPercentEncoding! + "/"
                let data = try! Data(contentsOf: URL(fileURLWithPath: (dir + entry.config.localImg)))
                Image(nsImage: NSImage(data: data)!).resizable()
            }
            let label = if entry.config.useDefault { "知识，与你分享。" } else { entry.config.sentence }
            Text(label).font(.headline)
        }
    }
}

struct TextWithImageWidget : Widget {
    let kind: String = "TextWithImageWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: TextWithImageConfig.self, provider: TextWithImageProvider()){entry in
            TextWithImageView(entry: entry).containerBackground(.fill.secondary, for: .widget)
        }
        .configurationDisplayName("图文型控件")
        .description("展示静态图片和文本")
        .supportedFamilies([.systemSmall])
    }
}
