//
//  DesktopWidgetsBundle.swift
//  DesktopWidgets
//
//  Created by 鸳汐 on 2024/7/27.
//

import WidgetKit
import SwiftUI

@main
struct DesktopWidgetsBundle: WidgetBundle {
    var body: some Widget {
        PictureOnlyWidget()
        TextWithImageWidget()
    }
}
