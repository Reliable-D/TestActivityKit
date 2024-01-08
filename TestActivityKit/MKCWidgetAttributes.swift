//
//  MKCWidgetAttributes.swift
//  TestActivityKit
//
//  Created by dengle on 2024/1/6.
//

import Foundation
import ActivityKit
import SwiftUI

public enum MKCLiveActivityState: Int, Codable, Hashable, CaseIterable {
    case notStart // 直播预告(未开始)
    case playing // 直播中
    case end // 直播回顾
    
    func imageIcon(_ currentState: MKCLiveActivityState) -> String {
        let isSelect = currentState == self
        switch self {
        case .notStart:
            return isSelect ? "live_no_start_hightlight" : "live_no_start_hightlight"
        case .playing:
            return isSelect ? "live_living" : "live_living"
        case .end:
            return isSelect ? "live_end" : "live_end"
        }
    }
    
    func desc() -> String {
        switch self {
        case .notStart:
            return "直播预告"
        case .playing:
            return "直播中"
        case .end:
            return "直播回顾"
        }
    }
    
    func hidenDesc(_ currentState: MKCLiveActivityState) -> Bool {
        switch currentState {
        case .notStart:
            return false
        case .playing:
            if self == .notStart {
                return true
            } else {
                return false
            }
        case .end:
            if self == .end {
                return false
            } else {
                return true
            }
        }
    }
}

public struct MKCWidgetAttributes: ActivityAttributes {
    
    /// ContentState存储动态数据
    public struct ContentState: Codable, Hashable {
        public var state: MKCLiveActivityState
        var audience: Int // 观众
        var barrage: Int // 弹幕
    }

    /* ActivityAttributes存储静态数据 */
    public var title: String // 12月月度沟通会
    public var startTime: Date // 预计2023/11/29 19:39 分开始
    
    
    /// 获取副标题文字
    /// - Parameter state: 状态
    /// - Returns: 文字
    func subTitleString(state: MKCWidgetAttributes.ContentState, island: Bool) -> AttributedString {
        switch state.state {
        case .notStart:
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("yyyy/MM/dd")
            let yearStr = df.string(from: startTime)
            var str1 = AttributedString("预计\(yearStr) ")
            str1.font = .systemFont(ofSize: 14)
            str1.foregroundColor = island ? Color.white : Color("headerSubtitle")
            
            df.setLocalizedDateFormatFromTemplate("HH:mm")
            let timeStr = df.string(from: startTime)
            var str2 = AttributedString("\(timeStr)")
            str2.font = .systemFont(ofSize: 14)
            str2.foregroundColor = Color("headerHightlightTitle")
            
            var str3 = AttributedString("分开始")
            str3.font = .systemFont(ofSize: 14)
            str3.foregroundColor = island ? Color.white : Color("headerSubtitle")
            
            return str1+str2+str3
        case .playing:
            var str1 = AttributedString("\(state.audience)")
            str1.font = .systemFont(ofSize: 14)
            str1.foregroundColor = Color("headerHightlightTitle")
            
            var str2 = AttributedString("人观看  ")
            str2.font = .systemFont(ofSize: 14)
            str2.foregroundColor = island ? Color.white : Color("headerSubtitle")
            
            var str3 = AttributedString("\(state.barrage)")
            str3.font = .systemFont(ofSize: 14)
            str3.foregroundColor = Color("headerHightlightTitle")
            
            var str4 = AttributedString("条弹幕")
            str4.font = .systemFont(ofSize: 14)
            str4.foregroundColor = island ? Color.white : Color("headerSubtitle")
            
            return str1+str2+str3+str4
        case .end:
            var str1 = AttributedString("直播已结束，可点击查看直播回顾～")
            str1.font = .systemFont(ofSize: 14)
            str1.foregroundColor = island ? Color.white : Color("headerSubtitle")
            return str1
        }
    }
}
