//
//  PictureOnlyWidget.swift
//  DesktopWidgetsExtension
//
//  Created by 鸳汐 on 2024/7/27.
//

import Foundation
import WidgetKit
import SwiftUI
import AppIntents
import AppKit

struct PictureOnlyEntry : TimelineEntry {
    var date: Date
    let config: PictureOnlyWidgetConfig
}

struct PictureOnlyWidgetConfig : WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "图片小组件配置"
    static var description: IntentDescription = IntentDescription("配置要展示的图片")
    
    @Parameter(title: "使用默认资源", default: true)
    var useDefaultImg: Bool
    
    @Parameter(title: "本地资源名", description: "只有在关闭“使用默认资源”时才生效", default: "")
    var localImgPath: String
}

struct PictureOnlyWidgetProvider : AppIntentTimelineProvider {
    func snapshot(for configuration: PictureOnlyWidgetConfig, in context: Context) async -> PictureOnlyEntry {
        PictureOnlyEntry(date: Date(), config: configuration)
    }
    
    func placeholder(in context: Context) -> PictureOnlyEntry {
        PictureOnlyEntry(date: Date(), config: PictureOnlyWidgetConfig())
    }
    
    func timeline(for configuration: PictureOnlyWidgetConfig, in context: Context) async -> Timeline<PictureOnlyEntry> {
        var entities: [PictureOnlyEntry] = []
        let entry = PictureOnlyEntry(date: Date(), config: configuration)
        entities.append(entry)
        return Timeline(entries: entities, policy: .atEnd)
    }
}

struct PictureOnlyView : View {
    var entry: PictureOnlyWidgetProvider.Entry
    
    var body: some View {
        VStack {
            if entry.config.useDefaultImg {
                Image("nahida_from_miyoushe").resizable()
            } else {
                let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.org.giwidget.yuanshine")!
                    .appending(component: "images")
                    .path().removingPercentEncoding! + "/"
                let data = try! Data(contentsOf: URL(fileURLWithPath: (dir + entry.config.localImgPath)))
                Image(nsImage: NSImage(data: data)!).resizable()
            }
        }
    }
}

struct PictureOnlyWidget : Widget {
    let kind: String = "PictureOnlyWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: PictureOnlyWidgetConfig.self, provider: PictureOnlyWidgetProvider()){ entry in
            PictureOnlyView(entry: entry).containerBackground(.fill.secondary, for: .widget)
        }
        .configurationDisplayName("图片型控件")
        .description("展示静态图片")
    }
}
