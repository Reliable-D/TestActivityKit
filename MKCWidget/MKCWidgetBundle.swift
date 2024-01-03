//
//  MKCWidgetBundle.swift
//  MKCWidget
//
//  Created by huihui.zhang on 2024/1/3.
//

import WidgetKit
import SwiftUI

@main
struct MKCWidgetBundle: WidgetBundle {
    var body: some Widget {
        MKCWidget()
        MKCLiveWidgetActivity()
    }
}
