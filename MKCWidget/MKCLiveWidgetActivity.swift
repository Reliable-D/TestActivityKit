//
//  MKCWidgetLiveActivity.swift
//  MKCWidget
//
//  Created by huihui.zhang on 2024/1/3.
//

import ActivityKit
import WidgetKit
import SwiftUI

public enum MKCLiveActivityState: Int, Codable, Hashable, CaseIterable {
    case notStart // 直播预告(未开始)
    case playing // 直播中
    case end // 直播回顾
    
    func imageIcon() -> String {
        switch self {
        case .notStart:
            return "live_no_start_hightlight"
        case .playing:
            return "live_living"
        case .end:
            return "live_end"
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
}

struct MKCWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var state: MKCLiveActivityState
    }

    var audience: Int // 观众
    var barrage: Int // 弹幕
    var title: String // 12月月度沟通会
    var startTime: Date
    //预计2023/11/29 19:39 分开始
    
    func subTitleString(state: MKCLiveActivityState) -> AttributedString {
        switch state {
        case .notStart:
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("yyyy/MM/dd")
            let yearStr = df.string(from: startTime)
            var str1 = AttributedString("预计\(yearStr) ")
            str1.font = .systemFont(ofSize: 14)
            str1.foregroundColor = .headerSubtitle
            
            df.setLocalizedDateFormatFromTemplate("HH:mm")
            let timeStr = df.string(from: startTime)
            var str2 = AttributedString("\(timeStr)")
            str2.font = .systemFont(ofSize: 14)
            str2.foregroundColor = .headerHightlightTitle
            
            var str3 = AttributedString("分开始")
            str3.font = .systemFont(ofSize: 14)
            str3.foregroundColor = .headerSubtitle
            
            return str1+str2+str3
        case .playing:
            var str1 = AttributedString("\(audience)")
            str1.font = .systemFont(ofSize: 14)
            str1.foregroundColor = .headerHightlightTitle
            
            var str2 = AttributedString("人观看  ")
            str2.font = .systemFont(ofSize: 14)
            str2.foregroundColor = .headerSubtitle
            
            var str3 = AttributedString("\(barrage)")
            str3.font = .systemFont(ofSize: 14)
            str3.foregroundColor = .headerHightlightTitle
            
            var str4 = AttributedString("条弹幕")
            str4.font = .systemFont(ofSize: 14)
            str4.foregroundColor = .headerSubtitle
            
            return str1+str2+str3+str4
        case .end:
            var str1 = AttributedString("直播已结束，可点击查看直播回顾～")
            str1.font = .systemFont(ofSize: 14)
            str1.foregroundColor = .headerSubtitle
            return str1
        }
    }
}

struct MKCLiveWidgetActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MKCWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
//            VStack {
//                Text("Hello \(context.state.emoji)")
//            }

            lockView(context)
                //.activityBackgroundTint(Color.cyan)
                //.activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("compactTrailing")
            } minimal: {
                Text("mini")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
    
    @ViewBuilder
    func lockHeaderView(_ context: ActivityViewContext<MKCWidgetAttributes>) -> some View {
            HStack { // header
                Circle().foregroundColor(.pink).overlay {
                    Image("ecollege_live_icon")
                        .resizable()
                        .foregroundColor(.white)
                        .padding(5)
                        .bold()
                }.frame(width: 48, height: 48).padding(.leading, 5)

                VStack(alignment: .leading, content: {
                    HStack {
                        Text(context.attributes.title)
                            .foregroundStyle(.headerTitle)
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                        Spacer()
                        Image("MK_logo")
                            .resizable()
                            .frame(width: 68.5,height: 10).padding(.trailing, 10)
                    }.padding(.bottom, 4)
                    
                    Text(context.attributes.subTitleString(state: context.state.state))
                }).padding(.leading, 10)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.blue]), startPoint: .top, endPoint: .bottom))
            .frame(height:60)
    }
    
    @ViewBuilder
    func createProcessView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .frame(height:8)
                .background(.progressBar)
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: nil, content: {
                ForEach(0..<8) { index in
                    Circle()
                        .frame(width:6 ,height: 6)
                        .foregroundStyle(.progressDot)
                }
            })
        }
    }
    
    @ViewBuilder
    func lockView(_ context: ActivityViewContext<MKCWidgetAttributes>) -> some View {
        
        VStack {
            lockHeaderView(context).frame(height: 60)
            HStack {
                ZStack {
                    Divider()
                        .frame(height:2)
                        .background(.black.opacity(0.5))
                        .background(in: Capsule())
                        .padding([.leading,.trailing],22)
                    HStack(alignment: .center, spacing: nil) {
                        VStack {
                            let state: MKCLiveActivityState = .notStart
                            Circle().foregroundColor(.pink).overlay {
                                Image(state.imageIcon())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .bold()
                            }.frame(width: 44, height: 44)
                            Text(state.desc())
                        }
                        .frame(width: 60)
                        
                        createProcessView()
                        
                        VStack {
                            let state: MKCLiveActivityState = .playing
                            Circle().foregroundColor(.pink).overlay {
                                Image(state.imageIcon())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .bold()
                            }.frame(width: 44, height: 44)
                            Text(state.desc())
                        }
                        .frame(width: 60)
                        
                        createProcessView()
                        
                        VStack {
                            let state: MKCLiveActivityState = .end
                            Circle().foregroundColor(.pink).overlay {
                                Image(state.imageIcon())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .bold()
                            }.frame(width: 44, height: 44)
                            Text(state.desc())
                        }
                        .frame(width: 60)
                    }
                }
            }.padding(.top,8)
            
        }
        .background(.white)
        .padding(10)
        .frame(height: 140)
    }
}

extension MKCWidgetAttributes {
    fileprivate static var preview: MKCWidgetAttributes {
        MKCWidgetAttributes(audience: 100, barrage: 2000, title: "12月月度沟通会", startTime: Date(timeIntervalSinceNow: 6 * 60 * 60))
    }
}

#Preview("Notification", as: .content, using: MKCWidgetAttributes.preview) {
   MKCLiveWidgetActivity()
} contentStates: {
    MKCWidgetAttributes.ContentState(state: MKCLiveActivityState.notStart)
//    MKCWidgetAttributes.ContentState.smiley
//    MKCWidgetAttributes.ContentState.starEyes
}
