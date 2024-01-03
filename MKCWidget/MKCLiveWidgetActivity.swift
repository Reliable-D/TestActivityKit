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
    case livePreview // 直播预告(未开始)
    case living // 直播中
    case liveReview // 直播回顾
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
                    Text("预计")
                        .font(.system(size: 14))
                        .foregroundStyle(.headerSubtitle)
                    + Text(context.attributes.startTime, style:.date)
                        .font(.system(size: 14))
                        .foregroundStyle(.headerSubtitle)
                    + Text(context.attributes.startTime, style:.time)
                        .foregroundStyle(.headerHightlightTitle)
                        .font(.system(size: 14))
                    + Text("分开始")
                        .font(.system(size: 14))
                        .foregroundStyle(.headerSubtitle)
                }).padding(.leading, 10)
            }
            //.background(LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.blue]), startPoint: .top, endPoint: .bottom))
            //.frame(height:60)
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
                        ForEach(MKCLiveActivityState.allCases, id: \.self) { state in
                            Circle().foregroundColor(.pink).overlay {
                                Image(systemName: "person.and.background.dotted")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .bold()
                            }.frame(width: 44, height: 44)
                        }
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
    MKCWidgetAttributes.ContentState(state: MKCLiveActivityState.livePreview)
//    MKCWidgetAttributes.ContentState.smiley
//    MKCWidgetAttributes.ContentState.starEyes
}
